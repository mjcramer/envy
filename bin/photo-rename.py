#!/usr/bin/env python3

import argparse
import sys
import os
import re
import math

# from PIL import Image
# from PIL.ExifTags import TAGS
 
# def get_exif(fn):
#     ret = {}
#     i = Image.open(fn)
#     info = i._getexif()
#     for tag, value in info.items():
#         decoded = TAGS.get(tag, tag)
#         ret[decoded] = value
#     return ret


def find_number(filename):
  print(filename)
  regex = re.compile("(.*)(\d*).(.*)", re.DEBUG if args.debug else 0)
  (base, digit, extension) = regex.match(filename)
  # print(base, digit, extension)

def rename_files(args):

    if not os.path.isdir(args.folder):
        print('Folder (%s) does not exist' % args.folder)
        return

    # os.chdir(args.folder)

    (path, dirs, files) = next(os.walk(args.folder))
    if args.debug:
      print("Walking path: {} {} {}".format(path, dirs, files)) 

    regex = re.compile(args.pattern, re.DEBUG if args.debug else 0)
    source_files = list(map(lambda f: "{}/{}".format(path, f), filter(regex.match, files)))

    # if not args.regex:
    #     target_files = [file for file in all_files if args.pattern in file]
    # else:

    # padding = len(max(target_files, key=len))
    # dest_files = []
    # replacement_string = args.replace
    number = args.number
    padding = int(math.log10(len(source_files) + args.number)) + 1
    regex = re.compile('(.*?)0*(\d+)\.(\w+)', re.DEBUG if args.debug else 0)

    for source_file in source_files:
      d = os.path.dirname(source_file)
      f = os.path.basename(source_file)
      # First check if it has an index number at the end
      m = regex.match(f)
      if not m:
        print("Not matched file {}".format(f))
        continue
      if args.debug:
        print("Match groups: {}".format(m.groups()))
      ext = m.group(3).lower()
      target_file = ("{0}{1}{2:0" + str(padding) + "d}.{3}").format(args.replace, args.separator, number, ext)
      if args.debug or args.test:
        print("Replacing source file {} with {}".format(f, target_file))
      if not args.test:
        os.rename(source_file, target_file)
      number += 1


def main():
    parser = argparse.ArgumentParser(__file__, __doc__,
                                     description="Renames files by pattern",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Required Args
    parser.add_argument('folder', help='the folder to search through')

    parser.set_defaults(mode="ordered")
    subparsers = parser.add_subparsers()
    ordered_parser = subparsers.add_parser('--ordered', help='This mode preserves the filesystem sorted ordering when renaming files')
    ordered_parser.add_argument('-c', '--count', action='store', help='Set the count')

    regex_parser = subparsers.add_parser('--something', help='This mode preserves the filesystem sorted ordering when renaming files')
    regex_parser.add_argument('-f', '--fart', action='store_true', help="Cuts the cheese")

    # Optional Args
    parser.add_argument('-D', '--debug', action='store_true', help='the pattern is a regex')

    parser.add_argument('-p', '--pattern', type=str, default='(.*?)0*(\d+)(\.\w*)', help='The pattern that each file should match')
    # parser.add_argument('-a', '--append', action='store_true', default=False, help='the "replace" string will be appended to the pattern')
    parser.add_argument('-r', '--replace', default="photo", help='the string with which to replace the matched pattern')
    parser.add_argument('-s', '--separator', default="-", help='the string with which to replace the matched pattern')
    parser.add_argument('-n', '--number', type=int, default=1, metavar='NUMBER', help='start numbering at NUMBER')
    parser.add_argument('-t', '--test', action='store_true', help='Test run, does not actually rename the files, just prints out what files would be renamed')
    # parser.add_argument('-r', '--regex', action='store_true', default=False, help='The pattern is a regex')
    # parser.add_argument('-v', '--view', action='store_true', default=False, help='Only view the potential changes, does not rename files')

    args = parser.parse_args()
    
    if args.folder:
        if not os.access(args.folder, os.W_OK):
            print("Folder {} is not writeable.".format(args.folder))
            parser.exit(1)

    if args.debug:
      print("Mode is {}".format(args.mode))
    rename_files(args)
    parser.exit()


if __name__ == '__main__':
    main()
