#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json

from web import CHttp
from resources.resource import CWebResource


@CHttp.resource('region')
class CRegionResource(CWebResource):

    @CHttp.post()
    def post(self, params):
        try:
            return '200 OK', self._data(int(params['id'])), 'application/json; charset=utf-8'
        except (KeyError, ValueError):
            return '400 Bad Request', 'Bad Request', 'text/plain'

    def _data(self, regionId):
        cities = self._app.db.select('SELECT id, name FROM City WHERE region_id = %s', [regionId])
        return json.dumps([(city['id'], city['name'].encode('utf-8')) for city in cities])