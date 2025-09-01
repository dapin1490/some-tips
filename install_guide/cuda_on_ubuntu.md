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
