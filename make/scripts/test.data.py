import sys

import pandas as pd

data = pd.read_csv(sys.argv[1])
print(data)
data = data[data["repeat"] == 1]
data["latency"] = data["end"] - data["start"]
print(data)
data.to_csv(sys.argv[2], index=False)
