1. 임시 사용자를 만들고 sudo 권한 부여

```shell
# 새로운 임시 사용자 이름 생성
sudo adduser {tmp username}

# 새로 만든 임시 사용자 sudo 권한 부여
sudo adduser {tmp username} sudo
```

2. 지금 로그인 한 터미널창에서 로그아웃 후 생성한 임시 사용자로 로그인  
  진행 중인 process가 있으면 안되는데 ssh 연결이 붙어있다는 것 자체가 process가 있다는 것이기 때문에  
  꼭 임시 사용자로 로그인하고 진행하기

3. 기존 사용하던 사용자 이름으로 진행 중인 모든 process 죽이기

```shell
sudo pkill -u {기존 사용자 이름} pid

sudo pkill -9 -u {기존 사용자 이름}
```

4. 사용자 이름 변경 및 변경된 사용자 이름으로 홈디렉토리 변경 

```shell
sudo usermod -l {변경하고자 하는 사용자 이름} {기존 사용자 이름}

sudo usermod -d /home/{변경하고자 하는 사용자 이름} -m {변경하고자 하는 사용자 이름}
```

5. groupname 변경

```shell
sudo groupmod -n {변경하고자 하는 사용자 이름} {기존 사용자 이름}

# 확인하기
id {변경한 사용자 이름}
ls -ld /home/{변경한 사용자 이름}
```

6. 접속 끊고 변경된 사용자 이름으로 로그인  
  위에서와 마찬가지로 진행 중인 process 가 있으면 아래가 진행이 안되기 때문에 위와 동일하게

```shell
kill process

sudo pkill -u {임시 사용자 이름} pid

sudo pkill -9 -u {임시 사용자 이름}
```

7. 임시 사용자 계정 및 디렉토리 삭제

```shell
sudo deluser {임시 사용자 이름}

sudo rm -r /home/{임시 사용자 이름}
```


reference: [[Linux] Ubuntu 22.04 사용자 이름(username) 변경하기](https://aeong-dev.tistory.com/8)
