import os
import cv2
import numpy as np

from PIL import Image, ImageDraw

class ImageProcessor(object):

    def __init__(self, path):
        self.__image_path = path

        self.__dot_coords = None
        self.__dot_colour = None
    
    def find_dots(self):
        img = cv2.imread(self.__image_path)

        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, binary = cv2.threshold(gray, 240, 255, cv2.THRESH_BINARY_INV)

        contours, _ = cv2.findContours(binary, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        if not len(contours):
            return None, None

        contours = max(contours, key=cv2.contourArea)
        moments = cv2.moments(contours)

        if not moments['m00']:
            return None, None

        x = int(moments['m10'] / moments['m00'])
        y = int(moments['m01'] / moments['m00'])

        color = img[y, x]

        self.__dot_coords = (x, y)
        self.__dot_colour = tuple(color)

        return self.__dot_coords, self.__dot_colour

class ImageMerger(object):

    def __init__(self, paths):
        self.__img_paths = sorted(
            paths,
            key=lambda x: int(os.path.split(x)[1].split('.')[0].split(' ')[1])
        )

        self.__final_image = None

    def init_canvas(self):
        self.__final_image = Image.new('RGB', (512 * len(self.__img_paths), 512), color='white')

    def merge(self):
        draw = ImageDraw.Draw(self.__final_image)
        prev_dot = None

        for i, path in enumerate(self.__img_paths):
            if np.all(cv2.imread(path) == 255):
                prev_dot = None
                continue

            img_processor = ImageProcessor(path)
            cur_dot, colour = img_processor.find_dots()

            if not cur_dot:
                continue

            if prev_dot:
                draw.line([prev_dot, (512 * i + cur_dot[0], cur_dot[1])], fill=colour, width=4)

            img = Image.open(path)
            self.__final_image.paste(img, (512 * i, 0))

            prev_dot = (512 * i + cur_dot[0], cur_dot[1])

    def save_img(self, op_path="output.png"):
        if self.__final_image:
            self.__final_image.save(op_path)
            self.__final_image.show()

if __name__ == '__main__':
    merger = ImageMerger([])