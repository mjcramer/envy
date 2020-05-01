#!/usr/bin/env python

import argparse
import json
import re
import os
import logging
import logging.handlers
import googleapiclient.discovery

if not os.path.exists("logs"):
    os.makedirs("logs")
logger = logging.getLogger('inventory')
log_file = logging.handlers.RotatingFileHandler('logs/inventory.log', maxBytes=1000000000, backupCount=5)
log_file.doRollover()
log_format = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
log_file.setFormatter(log_format)
logger.addHandler(log_file)
logger.setLevel(logging.INFO)


def items(item_list):
    if 'items' in item_list:
        for item in item_list['items']:
            yield item


class GceInventory(object):
    def __init__(self):
        self.hostgroups = {
            "_meta": {}
        }
        self.hostvars = {}
        self.ssh_config_file = os.path.expanduser('~/.ssh/config.vital0101.com')

        parser = argparse.ArgumentParser(__file__, __doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
        parser.add_argument('--log-level', type=str, choices=['debug', 'info', 'error'])
        modes = parser.add_mutually_exclusive_group(required=True)
        modes.add_argument('--list', action='store_true', help='list all hostgroups')
        modes.add_argument('--host', help='list variables for a single host')
        modes.add_argument('--version', action='store_true', help='print version and exit')
        modes.add_argument('--ssh-config', action='store_true', help='output to ssh config file')
        parser.add_argument('--project', default='vital-fish', help='google compute engine project name')
        parser.add_argument('--zones', type=list, default=("us-west1-b", "us-west1-c"),
                            help='comma separated list of zones')
        parser.add_argument('--pretty', action='store_true', help='pretty-print output JSON')
        args = parser.parse_args()

        if args.log_level == 'debug':
            logger.setLevel(logging.DEBUG)
        if args.version:
            print('%s %s' % (__file__, VERSION))
            parser.exit()

        compute = googleapiclient.discovery.build('compute', 'v1')
        for zone in args.zones:
            for item in items(compute.instances().list(project=args.project, zone=zone).execute()):
                logger.debug("========================================================================================")
                logger.debug("Instances in zone %s: %s", zone, json.dumps(item, indent=4))
                logger.debug("----------------------------------------------------------------------------------------")
                self.process_host(item)

        if args.list:
            self.list_command(args.pretty)
        elif args.host:
            self.host_command(args.host)
        elif args.ssh_config:
            self.ssh_config()

        parser.exit()

    def process_host(self, host):
        if host['status'] != "RUNNING":
            logger.debug("Skipping host %s because it is not running (%s).", host['name'], host['status'])
            return
        self.hostvars[host['name']] = dict()
        for tag in items(host['tags']):
            logger.debug("Processing tag '%s' for host %s", tag, host['name'])
            if tag not in self.hostgroups:
                self.hostgroups[tag] = {
                    "hosts": list(),
                    "vars": dict()
                }
            self.hostgroups[tag]['hosts'].append(host['name'])
        for interface in host['networkInterfaces']:
            self.hostvars[host['name']]['private_ip'] = interface['networkIP']
            if 'accessConfigs' in interface:
                for accessConfig in interface['accessConfigs']:
                    if 'natIP' in accessConfig:
                        self.hostvars[host['name']]['public_ip'] = accessConfig['natIP']
        for meta in items(host['metadata']):
            logger.debug("Processing metadata '%s' for host %s", meta, host['name'])
            self.hostvars[host['name']][meta['key']] = meta['value']

    def ssh_config(self):
        if len(self.hostvars) == 0:
            logger.warning("Empty host list")
            return

        logger.debug("Opening ssh config file for writing...")
        with open(os.path.expanduser("~/.ssh/config"), "a+") as config:
            config.seek(0)
            config_text = config.read()
            logger.debug(config_text)
            include_regex = r"^\s*include\s*" + re.escape(self.ssh_config_file)
            if not re.search(include_regex, config_text):
                logger.debug("No match for regex %s: ", include_regex)
                config.write('include {}\n'.format(self.ssh_config_file))
            else:
                logger.debug("Matched regex %s: ", include_regex)

        bastian_name = None
        bastian_ip = None
        logger.debug("Opening file %s for writing...", self.ssh_config_file)
        with open(self.ssh_config_file, 'w') as ssh_config:
            if 'bastian' in self.hostgroups:
                if len(self.hostgroups['bastian']['hosts']) == 0:
                    logger.warning("Bastian hostgroup is empty, no bastian IP will be configured!")
                else:
                    if 'public_ip' not in self.hostvars[self.hostgroups['bastian']['hosts'][0]]:
                        logger.debug(
                            json.dumps(self.hostgroups[self.hostgroups['bastian']['hosts'][0]]['hosts'][0], indent=4))
                        logger.warning("Bastian host does not have a public IP!")
                    else:
                        bastian_name = self.hostgroups['bastian']['hosts'][0]
                        ssh_config.write('\nHost {}\n'.format(bastian_name))
                        ssh_config.write('\tIdentityFile ~/.ssh/google_compute_engine\n')
                        bastian_ip = self.hostvars[bastian_name]['public_ip']
                        ssh_config.write('\tHostName {}\n'.format(bastian_ip))
            for host in filter(lambda item: item != bastian_name, self.hostvars):
                ssh_config.write('\nHost {}\n'.format(host))
                ssh_config.write('\tIdentityFile ~/.ssh/google_compute_engine\n')
                if bastian_ip:
                    ssh_config.write('\tHostName {}\n'.format(self.hostvars[host]['private_ip']))
                    ssh_config.write(
                        '\tProxyCommand ssh -i ~/.ssh/google_compute_engine -q {} nc %h %p\n'.format(bastian_ip))
                    ssh_config.write('\tStrictHostKeyChecking no\n')
                    ssh_config.write('\tUserKnownHostsFile=/dev/null\n')
                else:
                    if 'public_ip' not in self.hostvars[host]:
                        logger.warning(
                            'Host %s has no public IP, no bastian host, and will therefore be inaccessible from here.',
                            host)
                    else:
                        ssh_config.write('\tHostName {}\n'.format(self.hostvars[host]['public_ip']))

    def list_command(self, pretty=False):
        self.hostgroups['_meta']['hostvars'] = self.hostvars
        print(json.dumps(self.hostgroups, indent=4 if pretty else None))
        self.ssh_config()

    def host_command(self, host, pretty=False):
        if host in self.hostvars:
            print(json.dumps(self.hostvars[host], indent=4 if pretty else None))


# Run the script
if __name__ == '__main__':
    GceInventory()
