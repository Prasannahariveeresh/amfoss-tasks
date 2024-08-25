# Pirate's Dilemma

In this task I've been asked to scrape data from OpenSubtitles website to download subtitles from it.

## Goal

I was asked to created a CLI app using Python that accepts an mp4 file and returns a list of subtitles for it, allowing the user to choose and download their preferred option.

## Requirements

1. **Set Up Environment**
   * As I'm using anaconda package manager, I created a virtual environment in anaconda

2. **CLI Interface with Click**
   * Using the click module the below mentioned parameters are accepted
     - `-l, --language`: Filter subtitles by language.
     - `-o, --output`: Specify the output folder for the subtitles.
     - `-s, --file-size`: Filter subtitles by movie file size.
     - `-h, --match-by-hash`: Match subtitles by movie hash.
     - `-b, --batch-download`: Enable batch mode.

3. **Find IMDb ID and Hash/Filesize**
   - I've been asked to find IMDb ID from the filename, so I created a function to map movie name to it's IMDb ID where all these data are scraped from IMDb's website

5. **Scrape Subtitles**
    - Search using the IMDb ID and movie hash/file size (bonus points if you can come up with an algorithm to search using a selection of the three to maximise the chances of getting a result)
    - Apply the specified filters.
    - Sort the results by "Downloaded" in descending order.

6. **Download Subtitles**
   - List all the subtitles available for the given movie
   - Prompt the user to choose one and download it.

7. **Batch Mode**
   - If batch mode is enabled, a directory should be specified instead of a single file.
   - Automatically download subtitles for all movies within the specified directory instead of listing and prompting.

## Directory Structure

```
task-07
├── inputs
│   └── plan-9-from-outer-space.mpeg4
├── output
│   └── subtitle-Plan 9 from Outer Space.zip
├── README.md
├── run.py
└── utils.py
```
**utils.py** - This file has two classes in it, they are
    
- `HashAlgorithm` - This class deals with the hashing algorithm which is file size + 64bit sum of the first and last 64k of the file

- `OpenSubtitles` - This class deals with scraping all the subtitle links
    - `scrape_subtitles` function gets all the subtitle link from the website
    - `download_subtitle` function downloading it as a batch or as a single file

**run.py** - This is the main entry point that handles CLI argument