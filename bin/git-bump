#!/usr/bin/env python3

import argparse
from os.path import basename
from collections import namedtuple
import re
import sys
import os
import semantic_version
import git


def do_major(version):
  return version.next_major()

def do_minor(version):
  return version.next_minor()

def do_patch(version):
  return version.next_patch()

def do_tag(version):
  return version

def is_git_repo(path):
  try:
    _ = git.Repo(path).git_dir
    return True
  except git.exc.InvalidGitRepositoryError:
    return False

def tag_to_semver(tag):
  try:
    return semantic_version.Version(tag.tag.tag)
  except ValueError:
    sys.stderr.write(f"Unable to create a semantic version from tag '{tag}'.\n")
    return None

def ask_yes_no(question, yes={'yes','y', 'ye'}, no={'no','n'}):
  while True:
    sys.stdout.write(f"{question} (y/n) ")
    choice = input().lower()
    if choice in yes:
      return True
    elif choice in no:
      return False
    else:
      sys.stdout.write("Invalid response! ")


def main(args):
  if not is_git_repo(args.path):
    absolute_path = os.path.abspath(args.path)
    sys.stderr.write(f"Cannot find version, {absolute_path} is not a valid repo.\n")
    return

  repo = git.Repo(args.path)
  versions = list(sorted(filter(lambda version: version is not None, map(tag_to_semver, repo.tags))))
  if len(versions) == 0:
    print(f"No tags currently exist.")
    new_version = semantic_version.Version("0.1.0")
  else:
    print(f"The last tag was {str(versions[-1])}.")
    new_version = args.type(versions[-1])
  if ask_yes_no(f"Bump version to {new_version}?"):
    new_tag = repo.create_tag(new_version, force=True, message=f"Version bumped to {new_version}")
    if args.push and ask_yes_no(f"Push tags to {repo.remotes.origin.url}?"):
      try:
        repo.remotes.origin.push(new_tag)
      except ValueError:
        sys.stderr.write(f"Cannot find remote, will not push.\n")


if __name__ == '__main__':
  parser = argparse.ArgumentParser(basename(__file__), __doc__,
    description="This command will bump the version on the git tag and apply the tag to the current commit.!",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
  )
  parser.add_argument('--verbose', action='store_true', help='Add more descriptive output')
  parser.add_argument('--debug', action='store_true', help='Enable debugging output')
  parser.add_argument('-u', '--push', action='store_true', help='Push tags to remote, if it exists')
  parser.add_argument('path', nargs='?', type=str, default=".", help='Root of git repository.')

  group = parser.add_mutually_exclusive_group()
  group.add_argument('-m', '--major', action='store_const', const=do_major, dest='type', help="Bump the major part of the version.")
  group.add_argument('-n', '--minor', action='store_const', const=do_minor, dest='type', help="Bump the minor part of the version.")
  group.add_argument('-p', '--patch', action='store_const', const=do_patch, dest='type', help="Bump the patch part of the version.")
  group.add_argument('-t', '--tag', action='store_const', const=do_tag, dest='type', help="Reset the latest tag to the current commit.")
  parser.set_defaults(type=do_patch)

  args = parser.parse_args()

  global DEBUG
  DEBUG = args.debug

  main(args)
  parser.exit()
