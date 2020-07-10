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

df = pd.read_csv('duplicated.tsv', sep='\t')


for x in df['id'].tolist():
    client.delete_songs(x)


df['id'].tolist()


for song in all_songs:
    song_id = song.get('id')
    timestamp = song.get('creationTimestamp')
    artist = song.get('albumArtist') or song.get('artist')
    album = song.get('album')
    tracknum = song.get('trackNumber') or 0
    title = song.get('title')
    key = f'{artist} - {album}: {tracknum:02} {title}'
    value = {'id': song_id, 'timestamp': timestamp}
    existing_value = songs_to_keep.get(key, None)
    if existing_value:
        if timestamp < existing_value['timestamp']:
            songs_to_delete[key] = value
            continue
        else:
            songs_to_delete[key] = songs_to_keep[key]
    songs_to_keep[key] = value

len(all_songs)
len(songs_to_keep)
len(songs_to_delete)

song_ids = []
for key, id_time in sorted(songs_to_delete.items()):
    print(key)
    song_ids.append(id_time['id'])

# "Backend Error" if song_ids is too long
client.delete_songs(song_ids)
for x in song_ids:
    client.delete_songs(x)

client.logout()
