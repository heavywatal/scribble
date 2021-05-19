"""Remove duplicated songs from Google Play Music.
"""
import csv
import pandas as pd
from gmusicapi import Mobileclient

client = Mobileclient()
# client.perform_oauth()  # once
client.oauth_login(Mobileclient.FROM_MAC_ADDRESS)

all_songs = client.get_all_songs()
songs_to_keep = {}
songs_to_delete = {}

cols = set()
for song in all_songs:
    cols.update(song.keys())

with open('gmusic.tsv', 'w') as fout:
    writer = csv.DictWriter(fout, fieldnames=cols, delimiter='\t')
    writer.writeheader()
    for song in all_songs:
        writer.writerow(song)

# Extract duplicates with R: gmusic.tsv => duplicated.tsv

df = pd.read_csv('duplicated.tsv', sep='\t')

for x in df['id'].tolist():
    client.delete_songs(x)

client.logout()
