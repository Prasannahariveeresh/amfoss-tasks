import os
import sys
import utils
import click
import requests

movie_ids = ['1375666']

@click.command()
@click.argument('file_path')
@click.option('-l', '--language', default='en', help='Filter subtitles by language.')
@click.option('-o', '--output', default='.', help='Specify the output folder for the subtitles.')
@click.option('-s', '--file-size', is_flag=True, help='Filter subtitles by movie file size.')
@click.option('-h', '--match-by-hash', is_flag=True, help='Match subtitles by movie hash.')
@click.option('-b', '--batch-download', is_flag=True, help='Enable batch mode.')

def cli(file_path, language, output, file_size, match_by_hash, batch_download):
    mp4_file = file_path

    open_sub = utils.OpenSubtitles()
    hash_algo = utils.HashAlgorithm()

    try:
        imdb_name, imdb_id = open_sub.imdb_id(mp4_file.split('/')[-1].split('.')[0])
    except Exception as ex:
        print("Invalid file name")
        sys.exit(-1)

    if not imdb_id:
        click.echo("IMDb ID not found in the filename.")
        return

    file_hash, _ = hash_algo.hash_size_File_url(mp4_file) if match_by_hash else None
    subtitles = open_sub.scrape_subtitles(imdb_id, file_hash, language)

    if not subtitles:
        click.echo("No subtitles found.")
        return

    if not batch_download:
        click.echo("Available subtitles:")
        for i, sub in enumerate(subtitles, 1):
            click.echo(f"{i}: {sub['title']}")

        choice = click.prompt("Choose a subtitle to download", type=int)
        selected_sub = subtitles[choice - 1]

        subtitle_id = selected_sub['link'].split('/')[-2]
        open_sub.download_subtitle(imdb_name, subtitle_id, output)

    else:
        for i, sub in enumerate(subtitles, 1):
            subtitle_id = sub['link'].split('/')[-2]
            open_sub.download_subtitle(imdb_name, subtitle_id, os.path.join(output, f'{i}: {sub["title"]}'))

if __name__ == '__main__':
    cli()