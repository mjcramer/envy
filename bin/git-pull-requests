#!/usr/bin/env python3

import argparse
import os
import re
from github import Github
from termcolor import colored
import datetime 
import fnmatch

pull_wait_red=5
pull_wait_yellow=2
pull_indent=5

def list_pull_requests(github, org_name, glob):
    regex = re.compile("{0}/{1}".format(org_name, fnmatch.translate(glob)))
    repos = list(filter(lambda r: regex.match(getattr(r, 'full_name')), github.get_organization(org_name).get_repos('all')))

    current = datetime.datetime.utcnow()
    for repo in repos:
        pulls = repo.get_pulls(state='open', sort='long-running')
        if pulls.totalCount > 0:
            print(colored("Open pull requests for", 'white'), 
                colored(repo.full_name, 'cyan', attrs=['bold','underline']))
            for pull in pulls:
                delta = current - pull.updated_at
                units = 'days' if delta.days > 1 else 'day' if delta.days > 0 else 'hours'
                color = 'red' if delta.days > pull_wait_red else 'yellow' if delta.days > pull_wait_yellow else 'white'
                number = delta.days if delta.days > 0 else round(delta.seconds / 3600)
                print("{0:>{1}}:".format(pull.number, pull_indent),
                    colored(pull.title, 'white', attrs=['bold']),
                    colored("created on {0}".format(pull.created_at.strftime("%b %d, %Y")), 'blue', attrs=['bold']))
                print((pull_indent+1)*' ', 
                    colored(pull.html_url, 'white', attrs=['dark']),
                    colored("(waiting for {0} {1})".format(number, units), color))
            print(' ')
            
if __name__ == '__main__':
    # setup_logging()
    parser = argparse.ArgumentParser(__file__, __doc__,
                                     description="This absolutely incredible python script will change your life!",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Boolean flag example
    parser.add_argument('--verbose', action='store_true', help='Add more descriptive output.')
    parser.add_argument('--debug', action='store_true', help='Enable debugging output.')
    parser.add_argument('--token', help='Access token to allow api calls to github.')
    parser.add_argument('--org', default='norwegian-cruise-line', help='The name of the github organization.')
    parser.add_argument('project', nargs='?', default="zero-*", help='Project repository glob by which to filter.')
    args = parser.parse_args()
   
    global DEBUG
    DEBUG = args.debug

    token = args.token if args.token else os.getenv('GITHUB_ACCESS_TOKEN')
    if token:
        list_pull_requests(Github(token), args.org, args.project)
    else:
        print(colored("You must specify a github access token either via the --token option or the GITHUB_ACCESS_TOKEN environment variable.", 'red'))

    parser.exit()
