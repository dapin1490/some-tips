# GNU radio 설치 처음부터 끝까지 스크립트 모음
# 가이드 순서대로 썼으니 순서대로 따라가면 됨, 각 가이드 링크 주석에 있음
# 중복 설치 가능 ㄱㅊ
# 다만 혹시 모르니 bash 실행 말고 직접 복붙하는 거 추천함. bash로 실행하면 오류메시지가 지나가도 제때 멈출 수가 없음. + 출력이 엄청 많아서 보이지도 않음
# make -j5 실행 시 주의사항: -j5는 설치할 때 CPU 코어 5개 쓴다는 뜻임. 실행중인 PC의 사양에 맞게 숫자 고쳐서 쓸 것. CPU 코어 올인하면 화면 멈출 수도 있다고 가이드에 써있었음. 최대 (전체 CPU - 1)까지 가능.
# 모든 설치는 홈 디렉토리를 기준으로 함. 다른 데 설치되면 그냥 지우고 홈에서 다시 설치해도 일단 오류는 안 났음(어쩌다 해봤음,,^^)
# 혹시 모르니 써둠 Ubuntu 22.04 LTS 기준
# 만약 sudo apt install 있는 거 실행하는데 오류난다 -> sudo apt update && sudo apt upgrade -y 실행하고 다시 시도해보기
# 혹시 모르니 우분투 깔 때 처음 만든 사용자는 냅두고 새 사용자 만들어서 해보기 추천: 여차할 때 뒷처리가 비교적 쉬움 통삭제 가능
# 요 아래 END부터 END까지 다 주석이니 참고 바람
:<<'END'
대략적인 설치 순서: 처음 배울 때 교수님이 소스로 빌드하는 걸 권장하셔서 전부 깃허브 소스 받아서 빌드하는 코드임
1. 의존성 패키지: sudo apt install인데 전부 yes되어 있으니 알아서 설치될 거임
2. UHD + uhd_images_downloader(요건 약간 USB 드라이버 설치 비슷한 거라고 이해했음. SDR 장비들이 각자 드라이버 설치가 따로 필요하다고 알고 있음)
3. Volk: 이거 반드시 GNU radio보다 먼저 설치하라고 써있었음
4. GNU Radio: 사실상 요게 본체임
5. gr-osmosdr: 본체 2
6. RTL-SDR: 잘 기억은 안 나는데 따로 설치하라고 시키심
7. 기타 추가 패키지 설치 후 gr-osmosdr 다시 빌드해서 변경사항 확인: 여기서 cmake ../ 하고 나면 아래처럼 생긴 출력이 나올 건데, 완벽히 같을 필요는 없지만 enabled components에 리스트가 더 많아야 이상적이긴 함

# 출력 예시
-- ######################################################
-- # gr-osmosdr enabled components                         
-- ######################################################
--   * Python support
--   * Osmocom IQ Imbalance Correction
--   * sysmocom OsmoSDR
--   * FUNcube Dongle
--   * FUNcube Dongle Pro+
--   * IQ File Source
--   * Osmocom RTLSDR
--   * RTLSDR TCP Client
--   * Ettus USRP Devices
--   * Osmocom MiriSDR
--   * HackRF Jawbreaker
--   * nuand bladeRF
--   * RFSPACE Receivers
-- 
-- ######################################################
-- # gr-osmosdr disabled components                        
-- ######################################################
-- 
-- Building for version: v0.1.0-4-g37aba331 / 0.1.1git
-- Using install prefix: /usr/local
END

# 모든 패키지 최신 상태로 시작하는 것을 권장함
sudo apt update && sudo apt upgrade -y

# 이건 vscode인데 있으면 코딩하기 편함 추천
# 쓸 생각 있으면 주석 해제하고 쓰기
# sudo snap install code --classic

# 덤
# 쓸 거면 주석 해제하고 쓰기
# 홈에서 실행하는 거 기준임
# 폰트 압축파일을 받은 후 설치 끝나고 자동으로 삭제하니 똑같이 홈에서 실행하는 거 권장함
# 네이버 나눔 시리즈 폰트 설치하기
# sudo apt install fontconfig && curl -o nanumfont.zip http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip && sudo unzip -d /usr/share/fonts/nanum nanumfont.zip && rm nanumfont.zip && sudo fc-cache -f -v
# 나눔고딕코딩 설치하기: 설치되는 이름은 D2Coding임 참고하기
# wget https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip && sudo unzip -d /usr/share/fonts/d2coding D2Coding-Ver1.3.2-20180524.zip && rm D2Coding-Ver1.3.2-20180524.zip && sudo fc-cache -f -v

echo "==================================="
# Installing Dependencies
# https://wiki.gnuradio.org/index.php?title=UbuntuInstall#Install_Dependencies
echo "Installing Dependencies"

echo "-----------------------------------"

echo "install 1/3"
sudo apt install -y git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy python3-gi python3-gi-cairo gir1.2-gtk-3.0 \
libcodec2-dev libgsm1-dev libusb-1.0-0 libusb-1.0-0-dev libudev-dev python3-setuptools

echo "-----------------------------------"

echo "install 2/3"
sudo apt install -y pybind11-dev python3-matplotlib libsndfile1-dev \
libsoapysdr-dev soapysdr-tools python3-pygccxml python3-pyqtgraph

echo "-----------------------------------"

echo "install 3/3"
sudo apt install -y libiio-dev libad9361-dev libspdlog-dev python3-packaging python3-jsonschema python3-qtpy

echo "==================================="

# Installing UHD
# https://wiki.gnuradio.org/index.php?title=Draft-AN-445#Building_and_installing_UHD_from_source_code
echo "Installing UHD"
cd $HOME/
git clone https://github.com/EttusResearch/uhd.git
cd $HOME/uhd
git checkout v4.6.0.0
cd host
mkdir build
cd build
echo "start build UHD"
echo "-----------------------------------"
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ../
echo "-----------------------------------"
make -j5
echo "-----------------------------------"
make test
echo "-----------------------------------"
sudo make install
echo "-----------------------------------"
sudo ldconfig
echo "sudo ldconfig complete"

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
echo "For this change to take effect, you will need to close the current terminal window, and open a new terminal."
sleep 60

echo "check UHD installed"
uhd_find_devices
echo "ideal output is: [INFO] [UHD] linux; GNU C++ version 11.4.0; Boost_107400; UHD_4.6.0.HEAD-0-g50fa3baa \n No UHD Devices Found"

echo "start sudo uhd_images_downloader"
echo "You can now download the UHD FPGA Images for this installation."
sudo uhd_images_downloader

echo "==================================="

# Installing Volk
# https://wiki.gnuradio.org/index.php?title=LinuxInstall#Installing_Volk
echo "Installing Volk"
cd
git clone --recursive https://github.com/gnuradio/volk.git
cd volk
mkdir build
cd build
echo "start build Volk"
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
echo "-----------------------------------"
make -j5
echo "-----------------------------------"
make test
echo "-----------------------------------"
sudo make install
echo "-----------------------------------"
sudo ldconfig
echo "sudo ldconfig complete"

echo "==================================="

# Installing GNU Radio
# https://wiki.gnuradio.org/index.php?title=LinuxInstall#Installing_GNU_Radio
echo "Installing GNU Radio"
cd
git clone https://github.com/gnuradio/gnuradio.git
cd gnuradio
git checkout maint-3.9
mkdir build
cd build
echo "start build GNU Radio"
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
echo "-----------------------------------"
# 여기서 오류가 날건데, cmake 파일에서 cpp 버전을 17로 바꾸고 이어서 실행해야 함
make -j5
echo "-----------------------------------"
make test
echo "-----------------------------------"
sudo make install
echo "-----------------------------------"
sudo ldconfig
echo "sudo ldconfig complete"

echo "==================================="

# 새 창 열리고 뭔 프로그램 화면 나오면 설치 제대로 된거임
# 그 창 끄고 이후 과정 이어서 하면 됨
# 아무것도 쓴 거 없을테니 끌 때 close without save 해도 됨
echo "check gnuradio-companion"
gnuradio-companion

echo "==================================="

# Install gr-osmosdr
# https://github.com/osmocom/gr-osmosdr
cd
echo "Install gr-osmosdr"
git clone https://gitea.osmocom.org/sdr/gr-osmosdr
cd gr-osmosdr/
mkdir build
cd build/
echo "start build gr-osmosdr"
cmake ../
echo "-----------------------------------"
make -j5
echo "-----------------------------------"
sudo make install
echo "-----------------------------------"
sudo ldconfig
echo "sudo ldconfig complete"

echo "==================================="

# install RTL-SDR
# https://osmocom.org/projects/rtl-sdr/wiki
echo "install RTL-SDR"
cd
git clone https://gitea.osmocom.org/sdr/rtl-sdr.git
cd rtl-sdr/
mkdir build
cd build
echo "start build RTL-SDR"
cmake ../
echo "-----------------------------------"
make -j5
echo "-----------------------------------"
sudo make install
echo "-----------------------------------"
sudo ldconfig
echo "sudo ldconfig complete"
echo "-----------------------------------"
sudo make install-udev-rules

echo "==================================="

# install etc
echo "install etc"
sudo apt install -y libsoapysdr-dev libfreesrp-dev libmirisdr-dev libbladerf-dev libhackrf-dev libairspy-dev librtlsdr-dev
echo "build gr-osmosdr again"
cd
cd gr-osmosdr/
mkdir build
cd build/
echo "start build gr-osmosdr again"
cmake ../
echo "-----------------------------------"
make -j5
echo "-----------------------------------"
sudo make install
echo "-----------------------------------"
sudo ldconfig
echo "sudo ldconfig complete"

echo "==================================="
echo "COMPLETE GG"
