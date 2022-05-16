#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write(b'Received GET request')
        print(self.request)

    def do_POST(self):
        self._set_headers()
        content_length = int(self.headers.get('content-length', 0))
        post_body = self.rfile.read(content_length)
        self.wfile.write(b'Received POST request')
        print(self.request)
        print(post_body)

    def do_PUT(self):
        self._set_headers()
        self.wfile.write(b'Received PUT request')
        print(self.request)


httpd = HTTPServer(('localhost', 8000), SimpleHTTPRequestHandler)
httpd.serve_forever()
