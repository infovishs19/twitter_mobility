import pandas as pd
import numpy as np

start_date = '2014-07-02'
end_date = '2014-07-21'
df = pd.read_csv('./natural_disaster_human_mobility_rammasun.csv')

print(df.head())

mask = (df['time'] > start_date) & (df['time'] <= end_date)
df = df.loc[mask]

# sample n elements
df_sample = df.sample(n=10000)

print(df_sample)

df.to_csv('./rammasun_in_dates.csv', index=False)
