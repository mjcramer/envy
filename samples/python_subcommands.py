
class SubcommandExample(object):
    def __init__(self):
        pass


def main(args):
    if args.param:
        print("Hello {}!".format(args.param))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(basename(__file__), __doc__,
                                     description="This absolutely incredible python script will change your life!",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Boolean flag example
    parser.add_argument('--verbose, -v', action='store_true', help='Add more descriptive output')
    parser.add_argument('--debug, -d', action='store_true', help='Enable debugging output')

    parser.add_argument('param', nargs='?', default="world")
    parser = argparse.ArgumentParser('Blame Praise app')
    parser.add_argument(
        '--debug',
        action='store_true',
        help='Print debug info'
    )
    subparsers = parser.add_subparsers(dest='command')
    blame = subparsers.add_parser('blame', help='blame people')
    blame.add_argument(
        '--dry-run',
        help='do not blame, just pretend',
        action='store_true'
    )
    blame.add_argument('name', nargs='+', help='name(s) to blame')
    praise = subparsers.add_parser('praise', help='praise someone')
    praise.add_argument('name', help='name of person to praise')
    praise.add_argument(
        'reason',
        help='what to praise for (optional)',
        default="no reason",
        nargs='?'
    )
    args = parser.parse_args(command_line)
    if args.debug:
        print("debug: " + str(args))
    if args.command == 'blame':
        if args.dry_run:
            print("Not for real")
        print("blaming " + ", ".join(args.name))
    elif args.command == 'praise':
        print('praising ' + args.name + ' for ' + args.reason)

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
