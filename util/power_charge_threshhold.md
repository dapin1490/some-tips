ref: [Ubuntu 22.04 및 24.04에서 배터리 충전 제한을 설정하는 방법](https://ko.linux-terminal.com/?p=7554)

# 1단계: 노트북이 충전 제한을 지원하는지 확인

대부분의 최신 노트북은 충전 제한을 지원하지만 오래된 컴퓨터는 그렇지 않을 수도 있습니다.

먼저 키보드에서 `Ctrl+Alt+T`를 눌러 터미널 창을 엽니다. 그런 다음 명령을 실행하십시오.

```shell
ls /sys/class/power_supply/
```

배터리를 포함한 장치 이름이 나열됩니다(일반적으로 BAT0, BAT1, BATC, BATT 등).

제 경우에는 BAT0입니다. 배터리 충전 제한을 지원하는지 확인하려면 다음을 실행하세요.

```shell
ls /sys/class/power_supply/BAT0
```

마지막 명령의 BAT0을 그에 맞게 교체하세요. 그리고 해당 기능을 지원한다는 것을 알리는 다음 2개의 파일이 출력됩니다!

```shell
charge_control_start_threshold
charge_control_end_threshold
```

`charge_start_threshold` 및 `charge_stop_threshold`는 이전 2개와 자동으로 동기화되는 레거시 API(일반적으로 ThinkPad용)입니다.

# 2단계: 배터리 충전 시작 및 최대 제한 수준 설정

청구 한도를 설정하려면 위에 나열된 2개의 키 파일의 값 번호(0 ~ 100)를 설정하기만 하면 됩니다.

예를 들어 배터리 충전 시작 레벨을 80으로 설정하세요. 따라서 전원 공급 장치가 연결되면 배터리가 80% 미만일 때만 충전이 시작됩니다.

```shell
sudo sh -c "echo 80 > /sys/class/power_supply/BAT0/charge_control_start_threshold"
```

여기서 마지막 단계에 따라 BAT0을 교체하고 원하는 대로 값 80을 변경해야 합니다.

최대 배터리 충전 한도를 설정하려면 다음 명령을 실행하세요.

```shell
sudo sh -c "echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold"
```

위의 명령을 실행한 후 변경 사항이 즉시 적용됩니다. 시스템 트레이에서 배터리 아이콘 상태를 확인하거나 아래 명령을 실행하여 충전 중인지 확인할 수 있습니다.

```shell
cat /sys/class/power_supply/BAT0/status
```

# 3단계: 배터리 충전 임계값 서비스 생성(선택 사항)

이전 단계가 재부팅 후에 자동으로 작동하지 않는다면 시스템 서비스를 만들어 영구적으로 만드십시오.

시작 시 최대 배터리 충전 한도를 자동으로 설정하는 서비스를 만들려면 다음을 수행하세요.

1. 먼저 키보드의 Ctrl+Alt+T를 눌러 터미널을 엽니다. 열리면 다음 명령을 실행하십시오.

  ```shell
  sudo nano /etc/systemd/system/battery-charge-end-threshold.service
  ```

  이 명령은 서비스 파일을 생성하고 `nano` 명령줄 텍스트 편집기를 통해 편집합니다. Ubuntu 22.04의 경우 `nano`를 `gedit`으로, Ubuntu 24.04의 경우 `gnome-text-editor`로 바꿀 수 있습니다. 하지만 `nano`는 대부분의 데스크톱 환경에서 작동합니다.

  파일이 열리면 다음 줄을 붙여넣습니다.

  ```shell
  [Unit]
  Description=Set Battery Charge Maximum Limit
  After=multi-user.target
  StartLimitBurst=0
  
  [Service]
  Type=oneshot
  Restart=on-failure
  ExecStart=/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'
  
  [Install]
  WantedBy=multi-user.target
  ```

  여기서 1단계에 따라 `BAT0`를 바꾸고 원하는 대로 숫자 `80`을 변경합니다. 마지막으로 `ctrl+s`를 눌러 파일을 저장하고 `ctrl+x`를 눌러 종료하세요.

2. 서비스 파일을 생성한 후 다음 명령을 하나씩 실행하여 활성화 및 시작합니다.

  ```shell
  systemctl enable battery-charge-end-threshold.service
  systemctl daemon-reload
  systemctl start battery-charge-end-threshold.service
  ```

  배터리 시작 충전 수준을 설정하는 서비스도 생성하려면 마지막 단계를 다시 수행하되, 서비스 이름, 수준 번호, `charge_control_end_threshold`를 `charge_control_start_threshold`로 바꾸세요. > 파일 내용에 있습니다.

# 서비스 삭제 및 설정 복구

수동으로 생성된 시작 서비스를 제거하려면 아래 명령을 하나씩 실행하여 서비스 파일을 중지, 비활성화 및 제거합니다.

```shell
systemctl stop battery-charge-end-threshold.service
systemctl disable battery-charge-end-threshold.service
sudo rm /etc/systemd/system/battery-charge-end-threshold.service
```

마지막으로 명령을 통해 충전 시작 및 종료 임계값을 재설정할 수 있습니다(BAT0도 이에 맞게 교체).

```shell
sudo sh -c "echo 0 > /sys/class/power_supply/BAT0/charge_control_start_threshold"
sudo sh -c "echo 100 > /sys/class/power_supply/BAT0/charge_control_end_threshold"
```
