- 커밋되지 않은 파일 중 100MB를 넘는 파일 확인 [ref: Git 용량 제한을 넘는 파일 확인 방법](https://velog.io/@otoo/Git-%EC%9A%A9%EB%9F%89-%EC%A0%9C%ED%95%9C%EC%9D%84-%EB%84%98%EB%8A%94-%ED%8C%8C%EC%9D%BC-%ED%99%95%EC%9D%B8-%EB%B0%A9%EB%B2%95)  
  ```sh
  git diff --cached --name-only | xargs -I{} du -b {} | awk '$1 > 104857600'
  ```
- 최근 푸시된 커밋 지우기 [ref: Git Push한 커밋(Commit) 되돌리기 (git reset, git push -f)](https://subin-0320.tistory.com/175)  
  ```sh
  git reset HEAD^
  git push -f origin "브랜치명"
  ```
