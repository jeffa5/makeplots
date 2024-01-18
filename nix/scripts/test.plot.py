import sys

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import utils

data = pd.read_csv(sys.argv[1])
ax = sns.scatterplot(data, x="start", y="latency")

for output in sys.argv[2:]:
    plt.savefig(output)
