import time
import random
import os

os.environ['TZ'] = 'Asia/Seoul'
# time.tzset()

random.seed(1490)

def print_time() -> None:
    print(time.strftime('%Y년 %m월 %d일 %A %p %I시 %M분 %S초'))
    return

def timestamp() -> str:
    return time.strftime('%Y-%m-%d-%H-%M-%S')
