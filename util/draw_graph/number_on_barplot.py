# bar 그래프에 막대별 숫자 달기
def bar_caption(_bar):
    for rect in _bar:
        height = rect.get_height()
        plt.text(rect.get_x() + rect.get_width()/2.0, height, f'{height}', ha='center', va='bottom', size = 10)  # 'top', 'bottom', 'center', 'baseline', 'center_baseline'
    return _bar
