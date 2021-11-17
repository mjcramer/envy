#!/usr/bin/env python3

import argparse
from os.path import basename


def main(args):
    if args.param:
        print("Hello {}!".format(args.param))

   
if __name__ == '__main__':
    parser = argparse.ArgumentParser(basename(__file__), __doc__,
                                     description="This absolutely incredible python script will change your life!",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Boolean flag example
    parser.add_argument('--verbose', action='store_true', help='Add more descriptive output')
    parser.add_argument('--debug', action='store_true', help='Enable debugging output')

    parser.add_argument('param', nargs='?', default="world")

    # modes = parser.add_mutually_exclusive_group(required=True)
    # modes.add_argument('--list',
    #                    action='store_true',
    #                    help='list all variables')
    # modes.add_argument('--host',
    #                    help='list variables for a single host')
    # modes.add_argument('--addhost',
    #                    help='add variables for a single host')
    # modes.add_argument('--removehost',
    #                    help='add variables for a single host')
    # modes.add_argument('--etchosts',
    #                    action='store_true',
    #                    help='generate instance entries for /etc/hosts')
    # modes.add_argument('--sshconfig',
    #                    action='store_true',
    #                    help='generate instance entries for ~/.ssh/config')
    # parser.add_argument('--nometa',
    #                     action='store_true',
    #                     help='with --list, exclude hostvars')
 
    args = parser.parse_args()
    global DEBUG
    DEBUG = args.debug

    main(args)
    parser.exit()
