# Operation Pixel Merge

This project uses OpenCV and Pillow, utilizing contouring technique to stitch together these fragmented parts to reveal the secret message!

## Overview

The assets folder in this repository has a bunch of images, each of dimensions 512x512 pixels. Each one is composed of a white background with a **singular** coloured dot on it. The images are named with a number indicating their order in the sequence. 

## Directory Structure

```
task-10
├── assets
│   ├── Layer 10.png
│   ├── Layer 11.png
│   ├── Layer 12.png
│   ...
├── OperationPixel.py
├── output.png
├── README.md
└── run.py
```

**OperationPixel.py**: This file contains two classes,
1. `ImageProcessor` class takes in file path as input and `ImageProcessor(fp).find_dots()` finds the dot in the file using `cv2.findContour`

2. `ImageMerger` class takes in a list with all the paths of dots as input it has three main functions in it

    * `ImageMerger(fp_list).init_canvas()` - Creates a white plane based on the size 512x(Total number of images).

    * `ImageMerger(fp_list).merge()` - Stitches all the consecutive dots and leaves space for images without dots

    * `ImageMerger(fp_list).save_img()` - Saves the output image as `output.png` and opens it

**run.py**: This file is the main entry point, which flows through the assets directory and gets all the file path in a list and initiates the `ImageMerger` class from `OperationPixel.py`

## Output

**ZOOM IN FOR CLEAR VIEW**
![Operation Pixel Output](output.png)