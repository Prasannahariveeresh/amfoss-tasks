import os

from OperationPixel import ImageMerger

img_paths = [os.path.join('.', 'assets', path) for path in os.listdir('./assets')]

img_merger = ImageMerger(img_paths)
img_merger.merge()
img_merger.save_img()