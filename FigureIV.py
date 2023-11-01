import pandas as pd
import matplotlib.pyplot as plt

#Update to local path for experiment1 csv
df =pd.read_csv('C:\\Users\\bisho\\Documents\\ECN5050\\ECN5050-Replication-Project\\experiment1_data.csv')
plt.style.use('grayscale')


# Map treatment labels
treatment_labels = {1: "T1", 2: "T2", 3: "T3", 5: "T4"}
df["treatment"].replace(treatment_labels, inplace=True)

# Filter data
df = df[df["treatment"].isin(["T1", "T2", "T3", "T4"])]

# Modify belief1 values based on treatment
df.loc[df["treatment"] == "T2", "belief1"] -= 20
df.loc[df["treatment"].isin(["T1", "T3", "T4"]), "belief1"] -= 40

# Calculate means and standard errors
result = df.groupby("treatment").agg(
    m_belief1=("belief1", "mean"),
    m_frac_correct_land=("frac_correct_land", "mean"),
    sem_belief1=("belief1", "sem"),
    sem_frac_correct_land=("frac_correct_land", "sem")
).reset_index()

# Plot Figure 4 Panel A
fig, (ax1, ax2) = plt.subplots(1,2,figsize=(12, 6))
width = 0.4

for i, treatment in enumerate(result["treatment"]):
    subset = result[result["treatment"] == treatment]
    ax1.bar(i, subset["m_belief1"], yerr=subset["sem_belief1"],
            width=width, label=treatment)

# Customize the plot
ax1.set_xticks(range(len(result)))
ax1.set_xticklabels(result["treatment"])
ax1.set_xlabel("")
ax1.set_ylabel("")
ax1.set_title("A. Mean Belief of P(Animal) Minus Truth")

# Plot Figure 4 Panel B

for i, treatment in enumerate(result["treatment"]):
    subset = result[result["treatment"] == treatment]
    ax2.bar(i, subset["m_frac_correct_land"], yerr=subset["sem_frac_correct_land"],
            width=width, label=treatment)

# Customize the plot
ax2.set_xticks(range(len(result)))
ax2.set_xticklabels(result["treatment"])
ax2.set_xlabel("")
ax2.set_ylabel("")
ax2.set_title("B. Fraction Animals Recalled")

# Save the plot
plt.show()

#Uncomment if you'd like to save the output
#plt.savefig('FigureIV.png', format='png')