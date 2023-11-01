import pandas as pd
import matplotlib.pyplot as plt

plt.style.use('grayscale')

#Update to local path for experiment1 csv
df =pd.read_csv('C:\\Users\\bisho\\Documents\\ECN5050\\ECN5050-Replication-Project\\experiment2_data.csv')
treatment_labels = {3: "NL", 2: "NM", 1: "NH", 8: "IL", 7: 'IH', 6: 'CL', 5: 'CM', 4: 'CH'}
df["treatment"].replace(treatment_labels, inplace=True)

df = df[df["treatment"].isin(["NL", "NM", "NH", "IL", 'IH', 'CL', 'CM', 'CH'])]

#Calculate means and standard erros
result = df.groupby("treatment").agg(
    m_posteriors1=("posteriors1", "mean"),
    m_posteriors2=("posteriors2", "mean"),
    sem_posteriors1=("posteriors1", "sem"),
    m_recall=("recall_num_orange", "mean"),
    sem_recall=("recall_num_orange", "sem")
).reset_index()

result.loc[result["treatment"].isin(["NL", "NM", "NH"]), "m_posteriors1"] -= 50
result.loc[result["treatment"].isin(["IL", "IH"]), "m_posteriors1"] -= 55
result.loc[result["treatment"].isin(["CL", "CM", "CH"]), "m_posteriors1"] -= 70

#Plot figure 6 panel A
fig, (ax1,ax2) = plt.subplots(1,2,figsize=(12, 6))
width= 0.4
for i, treatment in enumerate(["NL", "NM", "NH", "IL", 'IH', 'CL', 'CM', 'CH']):
    subset = result[result["treatment"] == treatment]
    ax1.bar(i, subset["m_posteriors1"], yerr=subset["sem_posteriors1"],
            width=width, label=treatment)

# Customize the plot
ax1.set_xticks(range(len(result)))
ax1.set_xticklabels(["NL", "NM", "NH", "IL", 'IH', 'CL', 'CM', 'CH'])
ax1.set_xlabel("")
ax1.set_ylabel("")
ax1.set_title("A. Mean Belief of P(Word|Orange) Minus Truth")

#Plot figure 6 panel B

for i, treatment in enumerate(["NL", "NM", "NH", "IL", 'IH', 'CL', 'CM', 'CH']):
    subset = result[result["treatment"] == treatment]
    ax2.bar(i, subset["m_recall"], yerr=subset["sem_recall"],
            width=width, label=treatment)

# Customize the plot
ax2.set_xticks(range(len(result)))
ax2.set_xticklabels(["NL", "NM", "NH", "IL", 'IH', 'CL', 'CM', 'CH'])
ax2.set_xlabel("")
ax2.set_ylabel("")
ax2.set_title("B. Mean Orange Words Recalled")

# Save the plot
plt.show()

#Uncomment if you'd like to save the output
#plt.savefig('FigureVI.png', format='png')