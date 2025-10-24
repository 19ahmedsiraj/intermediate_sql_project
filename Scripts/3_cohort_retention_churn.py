import os
import matplotlib.pyplot as plt
import pandas as pd

os.makedirs("visuals", exist_ok=True)

data = {
    "cohort_year": [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023],
    "active": [237, 311, 385, 704, 687, 283, 442, 937, 455],
    "churned": [2588, 3086, 3683, 6742, 7068, 2748, 4221, 8073, 4263],
    "total_customers": [2825, 3397, 4068, 7446, 7755, 3031, 4663, 9010, 4718],
    "active_pct": [0.08, 0.09, 0.09, 0.09, 0.09, 0.09, 0.09, 0.10, 0.10],
    "churned_pct": [0.92, 0.91, 0.91, 0.91, 0.91, 0.91, 0.91, 0.90, 0.90]
}

df = pd.DataFrame(data)

plt.figure(figsize=(10,6))
plt.bar(df['cohort_year'], df['churned_pct'], color="#0b8d99", label='Churned')
plt.bar(df['cohort_year'], df['active_pct'], bottom=df['churned_pct'], color="#7EE882", label='Active')

plt.title('Customer Retention vs Churn by Cohort Year', fontsize=14, fontweight='bold')
plt.xlabel('Cohort Year', fontsize=12)
plt.ylabel('Customer Percentage', fontsize=12)
plt.ylim(0, 1)
plt.yticks([0, 0.25, 0.5, 0.75, 1], labels=['0%', '25%', '50%', '75%', '100%'])
plt.legend()
plt.grid(axis='y', linestyle='--', alpha=0.6)
plt.tight_layout()

plt.savefig('visuals/cohort_retention_churn.png', dpi=300)
plt.close()

print(" Chart saved successfully to visuals/cohort_retention_churn.png")
