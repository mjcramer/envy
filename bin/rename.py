#!/usr/bin/env python3

import argparse
import os
import re

def rename_files(args):

    if not os.path.isdir(args.folder):
        print('Folder (%s) does not exist' % args.folder)
        return

    # os.chdir(args.folder)

    (path, dirs, files) = next(os.walk(args.folder))
    print("{} {} {}".format(path, dirs, files))
    # if not args.regex:
    #     target_files = [file for file in all_files if args.pattern in file]
    # else:
    regex = re.compile(args.pattern)
    source_files = map(lambda f: "{}/{}".format(path, f), filter(regex.match, files))

    # padding = len(max(target_files, key=len))
    dest_files = []
    replacement_string = args.replace
    for source_file in source_files:
        if not args.regex:
            # if args.append:
            #     replacement_string = args.pattern + args.replace
            # elif args.prepend:
            #     replacement_string = args.replace + args.pattern
            dest_file = source_file.replace(args.pattern, replacement_string)
            if args.directory:
                dest_file += args.directory
            if DEBUG:
                print("Replacing pattern {} with string {}: {} --> {}".format(args.pattern, replacement_string, source_file, dest_file))
        # else:
        #     for matched_pattern in target_files[file]:
        #         if args.append:
        #             replacement_string = matched_pattern + args.replace
        #         elif args.prepend:
        #             replacement_string = args.replace + matched_pattern
        #
        #         altered = file.replace(matched_pattern, replacement_string)
        #
        # dest_files.append('%s --> %s' % (file.ljust(padding), altered))
        # if not args.view:
        #     os.rename(file, altered)
    #
    # # Dictionaries aren't sorted
    # dest_files.sort()
    # for file in dest_files:
    #     print(file)


def parse_args(parser):
    # Required Args
    parser.add_argument('folder', help='the folder to search through')
    parser.add_argument('replace', help='string to replace the pattern with')

    # Optional Args
    parser.add_argument('-p', '--pattern', type=str, default=".*", help='The pattern that each file should match')
    parser.add_argument('-a', '--append', action='store_true', default=False, help='the "replace" string will be appended to the pattern')
    parser.add_argument('-e', '--prepend', action='store_true', default=False, help='the "replace" string will be prepended to the pattern')
    parser.add_argument('-d', '--directory', type=str, help="The destination directory to which to copy.")
    parser.add_argument('-D', '--debug', action='store_true', help='the pattern is a regex')
    parser.add_argument('-r', '--regex', action='store_true', default=False, help='The pattern is a regex')
    parser.add_argument('-v', '--view', action='store_true', default=False, help='Only view the potential changes, does not rename files')

    return parser.parse_args()


def main():
    parser = argparse.ArgumentParser(__file__, __doc__,
                                     description="Renames files by pattern",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    args = parse_args(parser)
    global DEBUG
    DEBUG = args.debug

    if args.directory:
        if not os.access(args.directory, os.W_OK):
            print("Directory {} is not writeable.".format(args.directory))
            parser.exit(1)

    rename_files(args)
    parser.exit()


if __name__ == '__main__':
    main()
