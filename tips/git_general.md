- 커밋되지 않은 파일 중 100MB를 넘는 파일 확인 [ref: Git 용량 제한을 넘는 파일 확인 방법](https://velog.io/@otoo/Git-%EC%9A%A9%EB%9F%89-%EC%A0%9C%ED%95%9C%EC%9D%84-%EB%84%98%EB%8A%94-%ED%8C%8C%EC%9D%BC-%ED%99%95%EC%9D%B8-%EB%B0%A9%EB%B2%95)  
  ```sh
  git diff --cached --name-only | xargs -I{} du -b {} | awk '$1 > 104857600'
  ```
- 최근 푸시된 커밋 지우기 [ref: Git Push한 커밋(Commit) 되돌리기 (git reset, git push -f)](https://subin-0320.tistory.com/175)  
  ```sh
  git reset HEAD^
  git push -f origin "브랜치명"
  ```
- gh 로그인 상태 확인  
  ```sh
  gh auth status
  ```
- gh로 clone하기: gh로 로그인된 사용자로 git 사용 가능하게 됨  
  ```sh
  gh repo clone <OWNER/REPONAME>
  ```
- 기존 폴더를 깃허브 레포지토리로 init해서 gh로 push하기
  ```sh
  # 레포지토리 초기화, 브랜치 이름은 main
  git init -b main
  # 상태 확인 
  git status
  # 초기 파일 모두 add 후 commit
  git add .
  git commit -m "init"
  # 원격에 비공개 레포지토리로 생성 및 push
  gh repo create <레포지토리-이름> --private --source=. --remote=origin --push # 공개 레포지토리로 할 경우 --private는 안 써도 됨
  ```
- 만약 원격에서 브랜치 이름을 바꿨을 경우 (`master` -> `main`)
  ```sh
  git branch -m master main
  git fetch origin
  git branch -u origin/main main
  git remote set-head origin -a
  ```
