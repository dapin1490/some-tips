- 커밋되지 않은 파일 중 100MB를 넘는 파일 확인  
    `git diff --cached --name-only | xargs -I{} du -b {} | awk '$1 > 104857600'`
