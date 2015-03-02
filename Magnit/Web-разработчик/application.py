#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import os
import sys
from urlparse import parse_qs
from cgi import escape

from web import CHttp
from database import CDatabase
from config import DATABASE_CONFIG
from resources import index, region, comment, view, stat


class CWebApplication(object):

    def __init__(self, environ, start_response):
        self._resources = CHttp().resources
        self._env = environ
        self._start = start_response
        self._db = CDatabase(**DATABASE_CONFIG)
        self._templates = os.path.join(os.path.dirname(__file__), 'templates')

    @property
    def db(self):
        return self._db

    @property
    def templates(self):
        return self._templates

    def __iter__(self):
        exc_info = None
        try:
            context = self._route()
            if not context:
                status = '404 Not Found'
                result = 'Not Found'
                responseHeaders = [('Content-type', 'text/plain')]
            else:
                status = context[0]
                if '301' not in status:
                    result = context[1]
                    responseHeaders = [('Content-type', context[2])]
                else:
                    result = ''
                    responseHeaders = context[1]
        except Exception:
            status = '500 Internal Server Error'
            result = 'Internal Server Error'
            responseHeaders = [('Content-type', 'text/plain')]
            exc_info = sys.exc_info()
        self._start(status, responseHeaders, exc_info)
        yield result

    def close(self):
        self._db.close()

    def _route(self):

        def requestParams():
            if self._env['REQUEST_METHOD'] == 'GET':
                result = parse_qs(self._env['QUERY_STRING'])
            else:
                try:
                    contentLength = int(self._env.get('CONTENT_LENGTH', 0))
                except ValueError:
                    contentLength = 0
                result = parse_qs(self._env['wsgi.input'].read(contentLength))
            for param, values in result.iteritems():
                result[param] = escape(values[0]) if len(values) == 1 else [escape(value) for value in values]
            return result

        requestMethod = self._env['REQUEST_METHOD']
        requestPath = self._env['PATH_INFO'].lstrip('/')
        requestPath = requestPath if requestPath[-1:] == '/' else '%s/' % requestPath
        requestPaths = requestPath.split('/', 1)
        for root, params in self._resources.iteritems():
            if (root or not requestPaths[0]) and re.match(root, requestPaths[0]) \
                    and requestMethod in params['requestMethods']:
                for path, classMethod in params['requestMethods'][requestMethod]:
                    if (path or not requestPaths[1]) and re.match(path, requestPaths[1]):
                        return classMethod(params['class'](self), requestParams())
        return None


if __name__ == '__main__':
    from wsgiref.simple_server import make_server

    httpd = make_server('', 8000, CWebApplication)
    httpd.serve_forever()