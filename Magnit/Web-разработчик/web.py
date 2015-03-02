#!/usr/bin/env python
# -*- coding: utf-8 -*-


class CHttp(object):

    _resources = {}

    @property
    def resources(self):
        return self._resources

    @classmethod
    def resource(cls, path=''):

        def decorator(resourceClass):
            root = path.strip('/')
            if root in cls._resources:
                raise ValueError('Resource with the path "%s" already exists' % root)
            for classMethod in resourceClass.__dict__.itervalues():
                if hasattr(classMethod, "__REQUEST_METHOD__") and hasattr(classMethod, "__REQUEST_PATH__"):
                    resource = cls._resources.setdefault(root, {'class': resourceClass, 'requestMethods': {}})
                    requestMethod = resource['requestMethods'].setdefault(classMethod.__REQUEST_METHOD__, [])
                    requestMethod.append((classMethod.__REQUEST_PATH__, classMethod))
            return resourceClass

        return decorator

    @classmethod
    def get(cls, path=''):
        return cls._add_params('GET', path)

    @classmethod
    def post(cls, path=''):
        return cls._add_params('POST', path)

    @classmethod
    def put(cls, path=''):
        return cls._add_params('PUT', path)

    @classmethod
    def delete(cls, path=''):
        return cls._add_params('DELETE', path)

    @classmethod
    def _add_params(cls, httpMethod, path):

        def decorator(func):
            setattr(func, '__REQUEST_METHOD__', httpMethod)
            setattr(func, '__REQUEST_PATH__', path.strip('/'))
            return func

        return decorator