import time
import random
import os

os.environ['TZ'] = 'Asia/Seoul'
# time.tzset()

random.seed(1490)

def print_time() -> None:
    """
    현재 시간을 한국어 형식으로 출력합니다.
    출력 예시: "2024년 01월 15일 Monday PM 02시 30분 45초"
    """
    print(time.strftime('%Y년 %m월 %d일 %A %p %I시 %M분 %S초'))
    return

def str_time() -> str:
    """
    현재 시간을 한국어 형식 문자열로 반환합니다.
    출력 예시: "2024년 01월 15일 Monday PM 02시 30분 45초"
    """
    return time.strftime('%Y년 %m월 %d일 %A %p %I시 %M분 %S초')

def timestamp() -> str:
    """
    현재 시간을 파일명에 사용할 수 있는 문자열 형식으로 반환합니다.
    Returns:
        str: "YYYY-MM-DD-HH-MM-SS" 형식의 시간 문자열
    예시:
        "2024-01-15-14-30-45"
    """
    return time.strftime('%Y-%m-%d-%H-%M-%S')
