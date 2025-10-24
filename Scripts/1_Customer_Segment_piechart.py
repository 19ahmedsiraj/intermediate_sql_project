import matplotlib.pyplot as plt
import os

segments = ['1-LOW', '2-MID', '3-HIGH']
total_ltv = [4298367.21, 66367810.48, 135606968.77]

colors = ['#F8D7DA', '#FFE599', '#A8D08D']

plt.figure(figsize=(7, 7))
plt.pie(
    total_ltv,
    labels=segments,
    autopct='%1.1f%%',
    startangle=90,
    colors=colors,
    textprops={'fontsize': 11}
)
plt.title('Revenue Contribution by Customer Segment', fontsize=14, fontweight='bold')
plt.tight_layout()





