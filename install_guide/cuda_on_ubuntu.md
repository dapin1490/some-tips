# install nvidia driver
1. '소프트웨어 & 업데이트(Software & Updates)' 실행: 앱 메뉴에서 검색하여 실행합니다.
2. '추가 드라이버(Additional Drivers)' 탭 선택: 창 상단의 탭 메뉴에서 '추가 드라이버'를 클릭합니다.
3. 드라이버 목록 확인 및 선택: 시스템이 잠시 사용 가능한 드라이버 목록을 검색합니다. 목록이 나타나면, 일반적으로 **'(proprietary, tested)'** 라고 표시된 가장 최신 버전의 드라이버를 선택하는 것이 좋습니다.
4. '변경 사항 적용(Apply Changes)' 클릭: 드라이버를 선택한 후, 변경 사항을 적용하고 관리자 암호를 입력합니다. 설치가 완료되면 시스템을 재시작하라는 메시지가 나타날 수 있습니다.
5. reboot
6. nvidia version check
    ```shell
    $ nvidia-smi

    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 575.64.03              Driver Version: 575.64.03      CUDA Version: 12.9     |
    |-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    |=========================================+========================+======================|
    |   0  NVIDIA GeForce RTX 4080 ...    Off |   00000000:01:00.0 Off |                  N/A |
    | N/A   40C    P0            593W /  150W |      14MiB /  12282MiB |     16%      Default |
    |                                         |                        |                  N/A |
    +-----------------------------------------+------------------------+----------------------+

    +-----------------------------------------------------------------------------------------+
    | Processes:                                                                              |
    |  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
    |        ID   ID                                                               Usage      |
    |=========================================================================================|
    |    0   N/A  N/A            2111      G   /usr/bin/gnome-shell                      3MiB |
    +-----------------------------------------------------------------------------------------+
    ```

## if black screen
업데이트 후 화면이 켜지지 않을 경우 대처 방법
만약의 경우를 대비하여, 문제가 발생했을 때 이전 상태로 복구할 수 있는 방법을 숙지하는 것이 중요합니다.

1. 텍스트 콘솔(TTY)로 전환: 부팅 후 로그인 화면이 나타나지 않거나 검은 화면만 보일 경우, Ctrl + Alt + F3 (또는 F4, F5) 키를 눌러 텍스트 전용 모드로 진입합니다.
2. 사용자 계정으로 로그인: 사용자 이름(ID)과 암호를 입력하여 로그인합니다.
3. 기존 NVIDIA 드라이버 완전 삭제: 다음 명령어를 입력하여 설치된 모든 NVIDIA 관련 패키지를 삭제합니다.
    ```shell
    sudo apt-get purge 'nvidia*'
    ```
4. 권장 드라이버 재설치: 다음 명령어를 통해 시스템이 자동으로 가장 안정적인 드라이버를 다시 설치하도록 합니다.
    ```shell
    sudo ubuntu-drivers autoinstall
    ```
5. 시스템 재부팅: 설치가 완료되면 다음 명령어로 시스템을 재부팅합니다.
    ```shell
    sudo reboot
    ```

이 절차를 통해 대부분의 드라이버 관련 부팅 문제를 해결하고 정상적인 그래픽 환경으로 복구할 수 있습니다.

# install ananconda
1. download miniconda file(`.sh`): <https://www.anaconda.com/download/success>
2. execute downloaded file
    ```shell
    bash Miniconda3-latest-Linux-x86_64.sh
    > yes  # licence accept
    > [ENTER]  # install location
    > no  # Do you wish the installer to initialize Miniconda3? -> yes로 하면 쉘 실행 시 기본적으로 conda 실행됨
    ```
3. conda update
    ```shell
    conda update -n base -c defaults conda
    ```
4. activate venv
    ```shell
    conda activate [venv]
    ```
5. deactivate venv
    ```shell
    conda deactivate
    ```

# tensorflow on conda
1. create conda env
    ```shell
    conda create -n tf311 python=3.11
    ```
2. activate tf311
    ```shell
    conda activate tf311
    ```
3. install tensorflow
    ```shell
    conda install tensorflow -c conda-forge
    ```
4. check GPU activated
    ```shell
    python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
    ```

# pytorch on conda
1. create conda env
    ```shell
    conda create -n torch311 python=3.11
    ```
2. activate torch311
    ```shell
    conda activate torch311
    ```
3. install pytorch: find version on <https://pytorch.org/get-started/previous-versions/>
    ```shell
    # LINUX CUDA 12.8
    pip install torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/cu128
    ```
4. check GPU activated
    ```shell
    python -c "import torch; print(f'PyTorch version: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda}'); print(f'Device name: {torch.cuda.get_device_name(0)}')"
    ```
5. if `pip` error, install dependency
    ```shell
    pip install pyyaml typeguard
    ```
