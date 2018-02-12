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

DEBUG = False

# default_match='(.*?)0*(\d+)(\.\w*)'
default_match = '(.*?)'

total_count = 0

class PhotoFileName:
  def __init__(self, path, base, extension, number = None):
    global total_count
    self.path = path
    self.base = base
    self.extension = extension
    if number:
      self.number = number 
    else:
      total_count += 1
      self.number = total_count

  def __lt__(self, other):
    return self.base < other.base

  def __to_str():
    print("PhotoFileName: path={} base={} ext={} order={}".format(
      self.path, self.base, self.extension, self.number if self.number else "NONE"
    ))

# def find_number(filename):
#   print(filename)
#   regex = re.compile("(.*)(\d*).(.*)", re.DEBUG if DEBUG else 0)
#   (base, digit, extension) = regex.match(filename)
  # print(base, digit, extension)

def collect_files(folders):
  base_extension_regex = re.compile("(.+)\.(\w*)", re.DEBUG if DEBUG else 0)
  for folder in folders:
    if not os.path.isdir(folder):
        print('Input folder {} does not exist, skipping...'.format(folder))
        continue
    for (path, dirs, files) in os.walk(folder):
      if DEBUG:
        print("Walking path: {} {} {}".format(path, dirs, files))
      for file in files:
        m = base_extension_regex.match(file)
        if m:
          full_path = "{}/{}.{}".format(path, m.group(1), m.group(2))
          if DEBUG:
            print("Adding input file: " + full_path)
          yield [full_path, m.group(1), m.group(2)]


def match_base(regex, path, name, ext):
  if DEBUG:
    print("regex={} path={} name={} ext={}".format(regex, path, name, ext))
  m = regex.match(name)
  if m:
    return PhotoFileName(path, m.group(1), ext)
  else:
    return None


def main():
    parser = argparse.ArgumentParser(os.path.basename(__file__), __doc__,
                                     description='''
                                     Bulk renames files according to some replacement string, a separator, and a sequence number.
                                     File name extensions are both preserved and required.''',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Required Args
    parser.add_argument('folders', metavar='folders', type=str, nargs='+', help='the folders to search through')

    parser.set_defaults(mode="ordered")
    # subparsers = parser.add_subparsers()
  #   ordered_parser = subparsers.add_parser('--ordered', help='This mode preserves the filesystem sorted ordering when renaming files.')
  #   ordered_parser.add_argument('-c', '--count', action='store', help='Set the count.')
  #
  #   regex_parser = subparsers.add_parser('--something', help='This mode preserves the filesystem sorted ordering when renaming files.')
  #   regex_parser.add_argument('-f', '--fart', action='store_true', help="Cuts the cheese")

    # Optional Args
    parser.add_argument('-D', '--debug', action='store_true', help='Display verbose debugging information about files and pattern matches.')
    # parser.add_argument('-m', '--match', type=str, default='(.*?)0*(\d+)(\.\w*)', metavar='PATTERN', help='Only rename files matching PATTERN. Note that this applies to the basename only and does not include the file extension.')
    parser.add_argument('-m', '--match', type=str, default=default_match, metavar='PATTERN', help='Only rename files matching PATTERN. Note that this applies to the basename only and does not include the file extension.')

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
    
    parser.add_argument('-d', '--directory', type=str, default='.', help="The directory to which to write the output files.")

    args = parser.parse_args()
    if args.debug:
      print(args)
      global DEBUG 
      DEBUG = True
    
    if not os.access(args.directory, os.W_OK):
      print("Directory {} is not writeable.".format(args.directory))
      parser.exit(1)

    if args.debug:
      print("Mode is {}".format(args.mode))

    regex = re.compile(args.match, re.DEBUG if args.debug else 0)
    if args.debug:
      print("There are {:d} capture groups in this pattern: {}".format(regex.groups, args.match))

    if regex.groups == 0:
      print("You must specify at least one match group (base name) in a specified match pattern!")
      parser.exit(3)
    elif regex.groups == 1:
      if args.basename_field == 1:
        base_group = 1
        number_group = 0
      elif args.order_field == 1:
        base_group = 0
        number_group = 1
      else:
        print("You must set group 1 field!")
        parser.exit(2)
    elif regex.groups == 2:
      if args.basename_field == 1:
        base_group = 1
        number_group = 2
      elif args.order_field == 1:
        base_group = 2
        number_group = 1
      else:
        print("You must set group 1 field!")
        parser.exit(2)
      
    else:
      print("Too many match groups in pattern: {}".format(regex.groups))
      sys.exit(2)
      
    # for i in range(regex.groups):
      # if args.basename_field == i+1:
      #   group[i] =
      # print(i)
      
    # fields = list(filter(lambda x: x>0, [ args.basename_field, args.order_field, args.extension_field ]))
    # if len(fields) != regex.groups:
    #   print("There must be a pattern group for each specified index")
    #   sys.exit(2)

    input_files = list(collect_files(args.folders))
    if DEBUG:
      print("{} collected files:".format(len(input_files)))
      for f in input_files:
        print(f)
      
    source_files = list(map(lambda x: match_base(regex, x[0], x[1], x[2]), input_files))
    if DEBUG:
      print("{} source files".format(len(source_files)))

    filtered_files = list(filter(None.__ne__, source_files))
    if DEBUG:
      print("{} filtered files".format(len(filtered_files)))
   
    filtered_files.sort()

    number = args.number
    padding = args.zero_padding if args.zero_padding else int(math.log10(len(filtered_files) + args.number)) + 1
    for name in filtered_files:
      # First check if it has an index number at the end
      target_file = ("{0}{1}{2:0" + str(padding) + "d}.{3}").format(args.replace, args.separator, number, name.extension.lower())
      if args.debug or args.test:
        print("Replacing source file {} with {}".format(name.path, target_file))
      if not args.test:
        os.rename(name.path, target_file)
      number += 1

    parser.exit()


if __name__ == '__main__':
    main()
