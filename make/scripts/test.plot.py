import sys
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

import utils

data = pd.read_csv(sys.argv[1])
ax = sns.scatterplot(data, x="start", y="latency")
plt.savefig(sys.argv[2])
