# install git
sudo apt install -y git-all

# install gh
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

# start login
gh auth login
# GitHub.com이 선택된 상태로 엔터,
# HTTPS 선택된 상태로 엔터,
# Login with a web browser 선택된 상태로 엔터,
# First copy your one-time code: 뒤에 나오는 8자리 코드 복사 후 엔터,
# 웹페이지에서 깃허브 로그인 후 6번에서 복사한 코드 붙여넣기
# 이후부터 터미널에서 본인 깃허브 계정의 모든 기능 사용 가능
