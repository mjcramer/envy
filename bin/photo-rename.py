#!/usr/bin/env python

import argparse
import sys
from PIL import Image
from PIL.ExifTags import TAGS
 
def get_exif(fn):
    ret = {}
    i = Image.open(fn)
    info = i._getexif()
    for tag, value in info.items():
        decoded = TAGS.get(tag, tag)
        ret[decoded] = value
    return ret
    

def main():
    parser = argparse.ArgumentParser(__file__, __doc__,
                                     description="This absolutely incredible python script will change your life!",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Boolean flag example
    parser.add_argument('--verbose', action='store_true', help='Add more descriptive output')
    parser.add_argument('--debug', action='store_true', help='Enable debugging output')
    parser.add_argument('photo', nargs='?', default="world")

    args = parser.parse_args()

    global DEBUG
    DEBUG = args.debug

    if args.photo:
      print("{}".format(get_exif(args.photo)))
    parser.exit()

if __name__ == '__main__':
    main()
