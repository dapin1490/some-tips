# 나눔폰트
sudo apt install fontconfig && curl -o nanumfont.zip http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip && sudo unzip -d /usr/share/fonts/nanum nanumfont.zip && rm nanumfont.zip

# d2coding
wget https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip && sudo unzip -d /usr/share/fonts/d2coding D2Coding-Ver1.3.2-20180524.zip && rm D2Coding-Ver1.3.2-20180524.zip && sudo fc-cache -f -v

# vscode
sudo snap install code --classic

# for ubuntu 22.04 in virtualbox
# reference: https://weftnwarp.kr/site-it/archives/%EA%B2%8C%EC%8A%A4%ED%8A%B8-os%EC%9D%B8-%EC%9A%B0%EB%B6%84%ED%88%AC-22-04%EC%97%90-%EA%B2%8C%EC%8A%A4%ED%8A%B8-%ED%99%95%EC%9E%A5-%EC%84%A4%EC%B9%98-%EB%B0%8F-%ED%95%84%EC%88%98-%EC%84%A4%EC%A0%95/#google_vignette
sudo apt update
sudo apt -y upgrade
sudo apt install gcc make perl
# insert guest addition CD, open directory, and open terminal
sudo ./VBoxLinuxAdditions.run
