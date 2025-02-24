import pandas as pd
import uproot
import matplotlib.pyplot as plt
import numpy as np

dfsData = []
with uproot.open('/home/mdicosta/LocalTestsO2/dplustree/AO2D.root') as f:
    print(f.keys())
    for iKey, key in enumerate(f.keys()):
        if 'hfcanddpml' in key:
        # if 'hfcanddpml' in key:
            print(key)
            dfData = f[key].arrays(library='pd')
            dfsData.append(dfData)

combined_df = pd.concat([df for df in dfsData], ignore_index=True)
print(f"Number of candidates: {len(combined_df)}")
print(f"Number of columns: {len(combined_df.columns)}")

num_cols = len(combined_df.columns)  # Get the number of columns in the dataframe
cols = 4  # 4 images per row
rows = int(np.ceil(num_cols / cols))  # Compute the required rows

fig, axes = plt.subplots(rows, cols, figsize=(cols * 5, rows * 5))  # Adjust figure size
# fig, axes = plt.subplots(rows, cols, figsize=(16, 8))
axes = axes.flatten()  # Convert to 1D array for easy iteration

# Loop through DataFrame columns and plot histograms
for i, col in enumerate(combined_df.columns):
    combined_df[col].hist(ax=axes[i], bins=200, alpha=0.7, color='blue', log=True, edgecolor='black')
    axes[i].set_title(f'Histogram of {col}')

# Hide unused subplots if there are extra ones
for j in range(i + 1, len(axes)):
    fig.delaxes(axes[j])

# Adjust layout and save the figure
plt.tight_layout()
plt.savefig("histograms.png", dpi=300)

unique_values = combined_df['fFlagMcMatchRec'].unique()
print("Unique values in fFlagMcMatchRec:", unique_values)
unique_values = combined_df['fFlagMcDecayChanRec'].unique()
print("Unique values in fFlagMcDecayChanRec:", unique_values)