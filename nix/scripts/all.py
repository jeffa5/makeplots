import json
import os
import sys

import pandas as pd


def main():
    args = sys.argv[1:]
    configdirs = args[:-1]
    allfile = args[-1]

    all_data = []
    for configdir in configdirs:
        print(configdir)
        configfile = os.path.join(configdir, "configuration.json")
        config = open(configfile, "r", encoding="utf-8").read()
        config = json.loads(config)
        resultsfiles = [
            f
            for f in os.listdir(configdir)
            if os.path.isfile(os.path.join(configdir, f))
            and f.startswith("results")
            and f.endswith(".csv")
        ]
        config_data = []
        for resultsfile in resultsfiles:
            results = pd.read_csv(os.path.join(configdir, resultsfile))
            config_data.append(results)
        config_data = pd.concat(config_data)
        config_df = pd.DataFrame([config])
        config_data = config_df.join(config_data, how="cross")
        all_data.append(config_data)

    all_data = pd.concat(all_data)
    all_data.to_csv(allfile, index=False)


main()
