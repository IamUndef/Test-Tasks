#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

from web import CHttp
from resources.resource import CWebResource


@CHttp.resource('stat')
class CStatResource(CWebResource):

    _REGION_FIELDS = ('regionLink', 'count')
    _CITY_FIELDS = ('name', 'regionName', 'count')

    @CHttp.get()
    def get(self, params):
        if 'id' in params:
            try:
                result = self._data(int(params['id']))
            except ValueError:
                return '400 Bad Request', 'Bad Request', 'text/plain'
        else:
            result = self._data()
        return '200 OK', result, 'text/html; charset=utf-8'

    def _data(self, regionId=None):
        if not regionId:
            regions = self._app.db.select('''SELECT
                                               Region.id AS id,
                                               Region.name AS name,
                                               COUNT(Region.id) AS count
                                             FROM Comment
                                             LEFT JOIN City ON City.id = Comment.city_id
                                             LEFT JOIN Region ON Region.id = City.region_id
                                             GROUP BY Region.id
                                             HAVING COUNT(Region.id) > 5''')
            for region in regions:
                region['regionLink'] = u'<a href="/stat?id=%s">%s</a>' % (region['id'], region['name'])
            with open(os.path.join(self._app.templates, 'stat.xhtml'), 'r') as f:
                return f.read().format(tableTitle=u'Список регионов'.encode('utf-8'),
                                       tableHeaders=u''.join([u'<th>%s</th>' % header for header
                                                              in (u'Регион', u'Количество')]).encode('utf-8'),
                                       tableBody=u''.join(['<tr>%s</tr>' % ''.join(['<td>%s</td>' % region[field]
                                                                                    for field in self._REGION_FIELDS])
                                                           for region in regions]).encode('utf-8') if regions else '')
        else:
            cities = self._app.db.select('''SELECT
                                               City.name AS name,
                                               Region.name AS regionName,
                                               COUNT(City.id) AS count
                                             FROM Comment
                                             LEFT JOIN City ON City.id = Comment.city_id
                                             LEFT JOIN Region ON Region.id = City.region_id
                                             WHERE Region.id = %s
                                             GROUP BY City.id''', [regionId])
            with open(os.path.join(self._app.templates, 'stat.xhtml'), 'r') as f:
                return f.read().format(tableTitle=u'Список городов'.encode('utf-8'),
                                       tableHeaders=u''.join([u'<th>%s</th>' % header for header
                                                              in (u'Город', u'Регион', u'Количество')]).encode('utf-8'),
                                       tableBody=u''.join(['<tr>%s</tr>' % ''.join(['<td>%s</td>' % city[field]
                                                                                    for field in self._CITY_FIELDS])
                                                           for city in cities]).encode('utf-8') if cities else '')