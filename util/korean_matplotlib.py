import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
from matplotlib import rc
import seaborn as sns
import platform

plt.rcParams['axes.unicode_minus'] = False
plt.rcParams['font.family'] = "NanumGothicCoding"

plt.rcParams['font.size'] = 13  # 기본 폰트 크기
plt.rcParams['axes.labelsize'] = 13  # x,y축 label 폰트 크기
plt.rcParams['xtick.labelsize'] = 13  # x축 눈금 폰트 크기
plt.rcParams['ytick.labelsize'] = 13  # y축 눈금 폰트 크기
plt.rcParams['legend.fontsize'] = 13  # 범례 폰트 크기
plt.rcParams['figure.titlesize'] = 15  # figure title 폰트 크기

if platform.system() == 'Windows':
	path = "c:/Windows/Fonts/malgun.ttf"
	font_name = fm.FontProperties(fname=path).get_name()
	rc('font', family=font_name)
elif platform.system() == 'Linux':
    rc('font', family='Liberation Sans')  # 기본은 'Liberation Sans' 나눔고딕은 NanumBarunGothic, 나눔고딕코딩은 NanumGothicCoding

if __name__ == '__main__':
    print(plt.rcParams['axes.unicode_minus'])
    print(plt.rcParams['font.family'])
    print(plt.rcParams['axes.labelsize'])
    
    plt.plot([1, 2, 3, 4, 5])
    plt.title('abcil10gqpcluster')
    plt.show()
