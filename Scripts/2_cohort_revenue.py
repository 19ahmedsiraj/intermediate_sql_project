import pandas as pd
import matplotlib.pyplot as plt

data = {
    "cohort_year": [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024],
    "total_customers": [2825, 3397, 4068, 7446, 7755, 3031, 4663, 9010, 5890, 1402],
    "total_revenue": [7939067.47, 10309452.10, 12308043.27, 20639179.47, 22261147.58, 6942437.41, 12246413.14, 20565768.62, 12036152.49, 2633485.18],
    "cohort_revenue": [2810.29, 3034.87, 3025.58, 2771.85, 2870.55, 2290.48, 2626.29, 2282.55, 2043.49, 1878.38]
}

df = pd.DataFrame(data)

fig, ax1 = plt.subplots(figsize=(10,6))

ax1.bar(df['cohort_year'], df['total_revenue'], color='skyblue', label='Total Revenue')
ax1.set_xlabel('Cohort Year', fontsize=12)
ax1.set_ylabel('Total Revenue (in Millions)', color='blue', fontsize=12)
ax1.tick_params(axis='y', labelcolor='blue')

ax2 = ax1.twinx()
ax2.plot(df['cohort_year'], df['cohort_revenue'], color='darkorange', marker='o', linewidth=2, label='Cohort Revenue (per customer)')
ax2.set_ylabel('Cohort Revenue per Customer', color='darkorange', fontsize=12)
ax2.tick_params(axis='y', labelcolor='darkorange')

plt.title('Contoso Cohort Revenue and Total Revenue by Year', fontsize=14, fontweight='bold')
fig.tight_layout()
plt.show()
