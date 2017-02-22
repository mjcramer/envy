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

def collect_files(args): 
  pass

def rename_files(args):

    if not os.path.isdir(args.folder):
        print('Folder (%s) does not exist' % args.folder)
        return

    # os.chdir(args.folder)

    (path, dirs, files) = next(os.walk(args.folder))
    if args.debug:
      print("Walking path: {} {} {}".format(path, dirs, files)) 

    regex = re.compile(args.match, re.DEBUG if args.debug else 0)
    if args.debug:
      print("There are {:d} capture groups in this pattern: {}".format(regex.groups, args.match))
    
    source_files = list(map(lambda f: "{}/{}".format(path, f), filter(regex.match, files)))
    if args.debug:
      print("Found {} matching source files".format(str(len(source_files))))

    number = args.number
    padding = args.zero_padding if args.zero_padding else int(math.log10(len(source_files) + args.number)) + 1
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
      ext = m.group(args.extension_field).lower()
      target_file = ("{0}{1}{2:0" + str(padding) + "d}.{3}").format(args.replace, args.separator, number, ext)
      if args.debug or args.test:
        print("Replacing source file {} with {}".format(f, target_file))
      if not args.test:
        os.rename(source_file, target_file)
      number += 1


def main():
    parser = argparse.ArgumentParser(os.path.basename(__file__), __doc__,
                                     description='''
                                     Bulk renames files according to some replacement string, a separator, and a sequence number.
                                     File name extensions are both preserved and required.''',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Required Args
    parser.add_argument('folder', help='the folder to search through')

    parser.set_defaults(mode="ordered")
    subparsers = parser.add_subparsers()
    ordered_parser = subparsers.add_parser('--ordered', help='This mode preserves the filesystem sorted ordering when renaming files.')
    ordered_parser.add_argument('-c', '--count', action='store', help='Set the count.')

    regex_parser = subparsers.add_parser('--something', help='This mode preserves the filesystem sorted ordering when renaming files.')
    regex_parser.add_argument('-f', '--fart', action='store_true', help="Cuts the cheese")

    # Optional Args
    parser.add_argument('-D', '--debug', action='store_true', help='Display verbose debugging information about files and pattern matches.')
    # parser.add_argument('-m', '--match', type=str, default='(.*?)0*(\d+)(\.\w*)', metavar='PATTERN', help='Only rename files matching PATTERN. Note that this applies to the basename only and does not include the file extension.')
    parser.add_argument('-m', '--match', type=str, default='(.*?)0*(\d+)(\.\w*)', metavar='PATTERN', help='Only rename files matching PATTERN. Note that this applies to the basename only and does not include the file extension.')

    parser.add_argument('-b', '--basename-field', type=int, default=1, metavar='BASENAME', help='The match group number in the regex pattern that matches the file\'s base name.')
    parser.add_argument('-o', '--order-field', type=int, default=2, metavar='ORDER', help='The match group number in the regex pattern that matches the file\'s order number.')
    parser.add_argument('-e', '--extension-field', type=int, default=3, metavar='EXT', help='The match group number in the regex pattern that matches the file\'s extension.')

    parser.add_argument('-r', '--replace', default='photo', help='the string with which to replace the matched pattern.')
    parser.add_argument('-s', '--separator', default="-", help='the string with which to replace the matched pattern.')
    parser.add_argument('-n', '--number', type=int, default=1, metavar='NUMBER', help='start numbering at NUMBER.')
    parser.add_argument('-z', '--zero-padding', type=int, metavar='PADDING', help='Ensure that at least PADDING digits are present, i.e. a value of 3 will render 1 as 001, 23 as 023, etc.')
    parser.add_argument('-t', '--test', action='store_true', help='Test run, does not actually rename the files, just prints out what files would be renamed.')
    # parser.add_argument('-r', '--regex', action='store_true', default=False, help='The pattern is a regex')
    # parser.add_argument('-v', '--view', action='store_true', default=False, help='Only view the potential changes, does not rename files')

    args = parser.parse_args()
    if args.debug:
      print(args)
    
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
