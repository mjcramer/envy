#!/usr/bin/env python

import argparse
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import SocketServer
import simplejson
import random

DEFAULT_PORT = '8080'UI
O0 NNN  
class S(BaseHTTPRequestHandler):

    def do_HEAD(self):
        print("HEAD")
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_OPTIONS(self):
        print("OPTIONS")
        self.send_response(200, "ok")
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header("Access-Control-Allow-Headers", "X-Requested-With")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self):
        print("GET")
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        f = open("index.html", "r")
        self.wfile.write(f.read())

    def do_POST(self):
        print("POST")
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header("Access-Control-Allow-Headers", "X-Requested-With")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()
        self.data_string = self.rfile.read(int(self.headers['Content-Length']))
        print(self.data_string)
        # data = simplejson.loads(self.data_string)
        # with open("test123456.json", "w") as outfile:
        #     simplejson.dump(data, outfile)
        # print "{}".format(data)
        # f = open("for_presen.py")
        # self.wfile.write(f.read())
        return


def run(server_class=HTTPServer, handler_class=S, port=DEFAULT_PORT):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print 'Starting httpd...'
    httpd.serve_forever()

def main():
    parser = argparse.ArgumentParser(__file__, __doc__,
                                     description="This absolutely incredible python script will change your life!",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    # Boolean flag example
    parser.add_argument('--verbose', action='store_true', help='Add more descriptive output')
    parser.add_argument('--debug', action='store_true', help='Enable debugging output')
    parser.add_argument('--port', '-p', type=str, default=DEFAULT_PORT, help='The port on which to listen')
    args = parser.parse_args()
    print(args)
    global DEBUG
    DEBUG = args.debug

    run(args.port)
    parser.exit()


if __name__ == '__main__':
    main()
