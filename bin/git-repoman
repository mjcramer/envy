#!/usr/bin/env python3

import argparse
from os.path import basename
import re
import subprocess
from github import Github
#from git import Repo
from termcolor import colored
import datetime
import fnmatch

pull_wait_red=3
pull_wait_yellow=1
pull_indent=5

def list_repos(github, repos, **kwargs):
    if kwargs['path'] and not os.path.isdir(kwargs['path']):
        print(colored("{0} is not a valid directory".format(kwargs['path']), 'red'))
        return
    for repo in sorted(repos, key=lambda repo: repo.name):
        print(repo.name, end='')
        if kwargs['path']:
            repo_path = os.path.join(kwargs['path'], repo.name)
            if not os.path.exists(repo_path):
                Repo.clone_from("git@github.com:{0}".format(repo.full_name), repo_path)
            else:
                print(colored(" (directory {0} already exists)".format(os.path.abspath(repo_path)), 'yellow'), end='')
            if kwargs['exec']:
                print("")
                commands = kwargs['exec'].split(kwargs['pipe_char'])
                if len(commands) > 1:
                    p0 = subprocess.Popen(commands[0].strip().split(' '), cwd=repo_path, stdout=subprocess.PIPE)
                    count = 1
                    while count < len(commands) - 1:
                        p0 = subprocess.Popen(commands[count].strip().split(' '), cwd=repo_path, stdin=p0.stdout, stdout=subprocess.PIPE)
                        count += 1
                    p = subprocess.Popen(commands[count].strip().split(' '), cwd=repo_path, stdin=p0.stdout)
                else:
                    p = subprocess.Popen(commands[0].strip().split(' '), cwd=repo_path)
                p.communicate()
        print("")


def list_pull_requests(github, repos, state, ignore_no_review):
    pr_total = 0
    pr_total_red = 0
    pr_total_yellow = 0
    pr_no_review = 0
    pr_red = []
    pr_yellow = []
    pr_users = {}
    current = datetime.datetime.utcnow()
    for repo in repos:
        pulls = repo.get_pulls(state=state, sort='long-running')
        if pulls.totalCount > 0:
            print(colored("Open pull requests for", 'white'),
                colored(repo.full_name, 'cyan', attrs=['bold','underline']))
            for pull in pulls:
                pr_total += 1
                owner = pull.user.name if pull.user.name else pull.user.login

                print("{0:>{1}}:".format(pull.number, pull_indent),
                    colored(pull.title, 'white', attrs=['bold']),
                    colored("created by {0} on {1}".format(owner, pull.created_at.strftime("%b %d, %Y")), 'blue', attrs=['bold'])
                )

                if not ignore_no_review and 'no review' in map(lambda l: l.name, pull.labels):
                    pr_no_review += 1
                    print((pull_indent+1)*' ',
                        colored("Marked as do not review", 'white', attrs=['dark']))
                    continue

                pr_users[owner] = (pr_users[owner] + [pull.html_url]) if owner in pr_users else [pull.html_url]

                # is_priority = 'priority' in map(lambda l: l.name, pull.labels)
                #     is_priority = True
                #     print((pull_indent+1)*' ',
                #         colored("Marked as do not review", 'white', attrs=['dark']))
                #     continue

                delta = current - pull.updated_at
                if delta.days >= pull_wait_red:
                    color = 'red'
                    pr_total_red += 1
                    pr_red.append([delta, pull.html_url])
                elif delta.days >= pull_wait_yellow:
                    color = 'yellow'
                    pr_total_yellow += 1
                    pr_yellow.append([delta, pull.html_url])
                else:
                    color = 'white'
                number = delta.days if delta.days > 0 else round(delta.seconds / 3600)
                units = 'days' if delta.days > 1 else 'day' if delta.days > 0 else 'hours' if number != 1 else 'hour'

                status = "(mergeable, waiting for {0} {1})" if pull.mergeable else "(waiting for {0} {1})"

                print((pull_indent+1)*' ',
                    colored(pull.html_url, 'white', attrs=['dark']),
                    colored(status.format(number, units), color)
                )
            print(' ')

    print("Total of {0} open pull requests:".format(pr_total))
    summary1 = "\t{0} have been waiting for more than {1} days"
    if pr_total_red > 0:
        print(colored(summary1.format(pr_total_red, pull_wait_red), 'red'))
        for pr in sorted(pr_red, key=lambda x: x[0], reverse=True):
            print(colored("\t{}".format(pr[1]), 'white', attrs=['dark']), colored("(waiting for {0} days)".format(pr[0]), 'red', attrs=['dark']))
    if pr_total_yellow > 0:
        print(colored(summary1.format(pr_total_yellow, pull_wait_yellow), 'yellow'))
        for pr in sorted(pr_yellow, key=lambda x: x[0], reverse=True):
            print(colored("\t{}".format(pr[1]), 'white', attrs=['dark']), colored("(waiting for {0} days)".format(pr[0]), 'yellow', attrs=['dark']))
    if pr_no_review > 0:
        print("\t{0} are marked as do not review".format(pr_no_review))

    print("\nPull requests by user:")
    for user in pr_users:
        print("\t{0: <30} - {1} open pull requests".format(user, len(pr_users[user])))
        for pr in pr_users[user]:
            print(colored("\t{}".format(pr), 'white', attrs=['dark']))
    print("Last updated {}".format(current.strftime("on %b %d, %Y at %H:%m")))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(basename(__file__), __doc__,
                                     description="This script contains utilities to assist with core platform team tasks.",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    parser.add_argument('--verbose', action='store_true', help='Add more descriptive output.')
    parser.add_argument('--debug', action='store_true', help='Enable debugging output.')
    parser.add_argument('--token', help='Access token to allow api calls to github.')
    parser.add_argument('--org', default='norwegian-cruise-line', help='The name of the github organization.')
    parser.add_argument('--repo', default='zero-*', help='A glob to filter which github repositories are accessed.')
    parser.add_argument('--exclude', help='Comma separated list of projects to exclude')

    subparsers = parser.add_subparsers(dest='command', required=True, help='sub-command help')

    list_repos_parser = subparsers.add_parser('repos', help='Lists all repos and optionally perform actions in them.')
    list_repos_parser.add_argument('--path', help='If specified, all repos will be cloned to this directory')
    list_repos_parser.add_argument('--exec', help='Command to run in each repo')
    list_repos_parser.add_argument('--pipe-char', default='|', help='Change the pipe char for exec strings, for example, if your command contains "|".')

    list_pull_requests_parser = subparsers.add_parser('pull-requests', help='Lists all open pull requests.')
    list_pull_requests_parser.add_argument('--ignore-no-review', action='store_true', default=False, help='Pull requests labeled "no review" will be counted anyway')
    list_pull_requests_parser.add_argument('--state', default='open', help='List pull requests with specified state')

    args = parser.parse_args()

    global DEBUG
    DEBUG = args.debug

    token = args.token if args.token else os.getenv('GITHUB_ACCESS_TOKEN')
    if not token:
        parser.error("You must specify a github access token either via the --token option or the GITHUB_ACCESS_TOKEN environment variable.")

    github = Github(token)
    regex = re.compile("{0}/{1}".format(args.org, fnmatch.translate(args.repo)))
    repos = filter(lambda r: regex.match(getattr(r, 'full_name')), github.get_organization(args.org).get_repos('all'))

    if args.exclude:
        repos = filter(lambda r: r.name not in args.exclude.split(","), repos)

    if args.command == 'repos':
        list_repos(github, repos, path=args.path, exec=args.exec, pipe_char=args.pipe_char)
    elif args.command == 'pull-requests':
       list_pull_requests(github, list(repos), args.state, args.ignore_no_review)

    parser.exit()




# SUBCOMMAND HANDLER PATTERN SNIPPET FROM zero-control - integrate this

# parser = argparse.ArgumentParser(basename(__file__), __doc__,
#         formatter_class=argparse.ArgumentDefaultsHelpFormatter,
#         description="""
#             This tool controls all Project Zero deployments to Openshift, including creation and deletion of infrastructure components,
#             supporting tools, as well as the system services themselves. It is intended to be used primarily by system operators and
#             devops engineers, but is also suitable for developers working in non-production environments. It is intentionally simple and
#             limited in feature, as the focus is stability and reliablity. For questions please contact
#         """)

#     # Boolean flag example
#     parser.add_argument('--verbose', action='store_true', help='Add more descriptive output')
#     parser.add_argument('--debug', '-D', action='store_true', help='Enable debugging output')
#     parser.add_argument('--version', action='version', version='%(prog)s 1.0.0')
#     parser.add_argument('--environment', '-e', type=str, help='Target environment to which to deploy Project Zero')
#     parser.add_argument('--environment-dir', '-E', type=str, default=f"{dirname(__file__)}/project/environments",
#         help='Target environment to which to deploy Project Zero'
#     )
#     parser.add_argument('--save', '-s', action='store_false', default=True, help='Add more descriptive output')
#     subparsers = parser.add_subparsers(dest='object_sub', title="sub title", description="sub desc")

#     environment_parser = subparsers.add_parser('environment')
#     environment_parser.add_argument('action', type=str, help="Operations on available environments for Project Zero.")
#     environment_parser.set_defaults(handler=handle_environment)

#     cluster_parser = subparsers.add_parser('cluster')
#     cluster_parser.add_argument('--resume-failed', '-r', action='store_true', default=False,
#         help='Target environment to which to deploy Project Zero'
#     )
#     cluster_parser.add_argument('--service', '-s', help='Comma separated list of individual services to deploy`')
#     playbooks = list(map(lambda name: splitext(basename(name))[0], glob.glob(f"{dirname(__file__)}/project/*.yml")))
#     cluster_parser.add_argument('playbook', choices=playbooks, help="Playbook to apply to Project Zero environment.")
#     cluster_parser.add_argument('projects', nargs='*', help="List of projects to target")
#     cluster_parser.set_defaults(handler=handle_cluster)

#     service_parser = subparsers.add_parser('services')
#     service_parser.add_argument('services', nargs='*', help="List of services to target")

#     args = parser.parse_args()
#     if args.debug:
#         print(yaml.dump(args, sort_keys=True))

#     if not isdir(args.environment_dir):
#         parser.error(f"ERROR: {args.environment_dir} is not a directory")

#     result = args.handler(args)
#     if result:
