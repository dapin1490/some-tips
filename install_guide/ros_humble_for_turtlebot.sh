: << "END"
- prepare microSDcard
- Download the Raspberry Pi Imager to install Ubuntu Server 22.04 for Raspberry Pi.
- Install Ubuntu 22.04 in SDcard
    1. Run Raspberry Pi Imager
    2. Click CHOOSE OS.
    3. Select Other gerneral-purpose OS.
    4. Select Ubuntu.
    5. Select Ubuntu Server 22.04.5 LTS (64-bit) that support RPi 3/4/400. (Choose Server OS, not desktop OS)
    6. Click CHOOSE STORAGE and select the micro SD card.
    7. Click Next to install Ubuntu.
    8. Click Edit Setting for wifi and ssh setting.
    9. Set username and password, Configure wireless LAN, Wireless LAN country. And activate Enable SSH with Use password authenication in SERVIES tab.
    10. By completing this configuring setup process, the following Wi-Fi configuration steps (up to step 4) can be skipped.
END

# SDcard 설정할 때 이미 커스텀했으면 스킵 가능
sudo nano /etc/netplan/50-cloud-init.yaml
# Edit the content to match the image below while replacing WIFI_SSID and WIFI_PASSWORD with your actual wifi SSID and password.

sudo nano /etc/apt/apt.conf.d/20auto-upgrades
# Change the update settings to match those below.
: << "END"
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
END

systemctl mask systemd-networkd-wait-online.service
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
sudo reboot

# If you are using the TurtleBot3 2GB, make sure to create swap memory for building packages. Otherwise, you may run out of memory and package building may fail.
# Create 2GB or more swap memory
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# The following command ensures that the swap file is automatically activated when the system is rebooted.
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
# Check swap memory
free -h

# ======================================

# install ROS 2

locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME
sudo apt install /tmp/ros2-apt-source.deb

sudo apt update && sudo apt upgrade -y

sudo apt install -y ros-humble-desktop ros-humble-ros-base ros-dev-tools

source /opt/ros/humble/setup.bash

# ====================================

# Install and Build ROS Packages
# if get wrong, just retry

sudo apt install python3-argcomplete python3-colcon-common-extensions libboost-system-dev build-essential
sudo apt install ros-humble-hls-lfcd-lds-driver
sudo apt install ros-humble-turtlebot3-msgs
sudo apt install ros-humble-dynamixel-sdk
sudo apt install libudev-dev
mkdir -p ~/turtlebot3_ws/src && cd ~/turtlebot3_ws/src
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git
git clone -b humble https://github.com/ROBOTIS-GIT/ld08_driver.git
cd ~/turtlebot3_ws/src/turtlebot3
rm -r turtlebot3_cartographer turtlebot3_navigation2
cd ~/turtlebot3_ws/
echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc
source ~/.bashrc
colcon build --symlink-install --parallel-workers 1
echo 'source ~/turtlebot3_ws/install/setup.bash' >> ~/.bashrc
source ~/.bashrc

sudo cp `ros2 pkg prefix turtlebot3_bringup`/share/turtlebot3_bringup/script/99-turtlebot3-cdc.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger

echo 'export ROS_DOMAIN_ID=30 #TURTLEBOT3' >> ~/.bashrc
source ~/.bashrc

echo 'export LDS_MODEL=LDS-02' >> ~/.bashrc

source ~/.bashrc

# ==============================

# Raspberry Pi Camera

# ===
# Method 1. Using the camera-ros package
sudo apt update
sudo apt install -y python3-pip git python3-jinja2 \
libboost-dev libgnutls28-dev openssl libtiff-dev pybind11-dev \
qtbase5-dev libqt5core5a libqt5widgets5 meson cmake \
python3-yaml python3-ply \
libglib2.0-dev libgstreamer-plugins-base1.0-dev
sudo apt install ros-humble-camera-ros

git clone https://github.com/raspberrypi/libcamera.git

cd libcamera
meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=true -Dgstreamer=enabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=enabled
ninja -C build
sudo ninja -C build install
sudo ldconfig

# launch at turtlebot
ros2 launch turtlebot3_bringup camera.launch.py
# launch at remote PC
rqt_image_view

# ===
# Method 2. Using the v4l2-camera package

sudo apt-get install ros-humble-v4l2-camera raspi-config ros-humble-image-transport-plugins v4l-utils

sudo raspi-config
# Select Interface Options
# Select I1 and set enable legacy camera support. This allows the use of the legacy driver, bcm2835 MMAL.

sudo nano /boot/firmware/config.txt
# Modify or add the following lines
: << "END"
# Disable libcamera auto detect
camera_auto_detect=0
# Enable legacy camera stack for bcm2835-v4l2
start_x=1
END

sudo reboot

v4l2-ctl --list-devices

# turtlebot
ros2 run v4l2_camera v4l2_camera_node
# remote PC
rqt_image_view

# ==================================

# OpenCR setup

sudo dpkg --add-architecture armhf
sudo apt-get update
sudo apt-get install libc6:armhf

export OPENCR_PORT=/dev/ttyACM0
export OPENCR_MODEL=burger
rm -rf ./opencr_update.tar.bz2

wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS2/latest/opencr_update.tar.bz2
tar -xvf opencr_update.tar.bz2

cd ./opencr_update
./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr
