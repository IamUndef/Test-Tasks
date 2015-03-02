#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

from web import CHttp
from resources.resource import CWebResource


@CHttp.resource('view')
class CViewResource(CWebResource):

    _COMMENT_FIELDS = ('lastName',
                       'firstName',
                       'patrName',
                       'region',
                       'city',
                       'phone',
                       'email',
                       'comment',
                       'deleteLink')

    @CHttp.get()
    def get(self, params):
        return '200 OK', self._data(), 'text/html; charset=utf-8'

    def _data(self):
        comments = self._app.db.select('''SELECT
                                            Comment.id AS id,
                                            lastName AS %s,
                                            firstName AS %s,
                                            IFNULL(patrName, '') AS %s,
                                            IFNULL(Region.name, '') AS %s,
                                            IFNULL(City.name, '') AS %s,
                                            IFNULL(phone, '') AS %s,
                                            IFNULL(email, '') AS %s,
                                            comment AS %s
                                          FROM Comment
                                          LEFT JOIN City ON City.id = Comment.city_id
                                          LEFT JOIN Region ON Region.id = City.region_id''' % self._COMMENT_FIELDS[:-1])
        for comment in comments:
            comment['deleteLink'] = u'<a href="/comment/delete?id=%s">Удалить</a>' % comment['id']
        with open(os.path.join(self._app.templates, 'view.xhtml'), 'r') as f:
            return f.read().format(comments=u''.join(['<tr>%s</tr>' % ''.join(['<td>%s</td>' % comment[field]
                                                                               for field in self._COMMENT_FIELDS])
                                                      for comment in comments]).encode('utf-8') if comments else '')