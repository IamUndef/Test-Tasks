#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

from web import CHttp
from resources.resource import CWebResource


@CHttp.resource()
@CHttp.resource('index\.html|index\.htm')
class CIndex(CWebResource):

    @CHttp.get()
    def get(self, params):
        with open(os.path.join(self._app.templates, 'index.xhtml'), 'r') as f:
            return '200 OK', f.read(), 'text/html; charset=utf-8'