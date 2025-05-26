#!/bin/bash

function logging() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$2"
}

LOG_FILE="install_humble_log.txt"
: > "$LOG_FILE"  # 초기화

locale  # check for UTF-8

logging "start setup locale" "install_humble_log.txt"
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
logging "end setup locale" "install_humble_log.txt"

locale  # verify settings

logging "start install software-properties-common" "install_humble_log.txt"
sudo apt install -y software-properties-common
sudo add-apt-repository universe
logging "end install software-properties-common" "install_humble_log.txt"

logging "curl ros-archive-keyring" "install_humble_log.txt"
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

logging "apt update and upgrade" "install_humble_log.txt"
sudo apt update

sudo apt -y upgrade

logging "install ros-humble-desktop" "install_humble_log.txt"
sudo apt install -y ros-humble-desktop

logging "install ros-humble-ros-base" "install_humble_log.txt"
sudo apt install -y ros-humble-ros-base

logging "install ros-dev-tools" "install_humble_log.txt"
sudo apt install -y ros-dev-tools

source /opt/ros/humble/setup.bash

logging "install gazebo" "install_humble_log.txt"
sudo apt install -y ros-humble-gazebo-*

logging "install cartographer" "install_humble_log.txt"
sudo apt install -y ros-humble-cartographer
sudo apt install -y ros-humble-cartographer-ros

logging "install navigation" "install_humble_log.txt"
sudo apt install -y ros-humble-navigation2
sudo apt install -y ros-humble-nav2-bringup

logging "install pkgs" "install_humble_log.txt"
source /opt/ros/humble/setup.bash
mkdir -p ~/turtlebot3_ws/src
cd ~/turtlebot3_ws/src/
git clone -b humble https://github.com/ROBOTIS-GIT/DynamixelSDK.git
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git
sudo apt install -y python3-colcon-common-extensions
cd ~/turtlebot3_ws
colcon build --symlink-install
echo 'source ~/turtlebot3_ws/install/setup.bash' >> ~/.bashrc
source ~/.bashrc

echo 'export ROS_DOMAIN_ID=30 #TURTLEBOT3' >> ~/.bashrc
echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc
echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc
echo 'export TURTLEBOT3_MODEL=waffle' >> ~/.bashrc
source ~/.bashrc

logging "install gazebo" "install_humble_log.txt"
sudo apt install ros-humble-gazebo-*
cd ~/turtlebot3_ws/src/
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
cd ~/turtlebot3_ws && colcon build --symlink-install

echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc
echo 'source /usr/share/gazebo-11/setup.sh' >> ~/.bashrc
echo 'source /usr/share/gazebo-11/setup.bash' >> ~/.bashrc
source ~/.bashrc
