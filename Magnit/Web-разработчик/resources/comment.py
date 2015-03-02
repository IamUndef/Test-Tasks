#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

from web import CHttp
from database import DatabaseError
from resources.resource import CWebResource


@CHttp.resource('comment')
class CCommentResource(CWebResource):

    @CHttp.get()
    def get(self, params):
        return '200 OK', self._data(), 'text/html; charset=utf-8'

    @CHttp.post('add')
    def add(self, params):
        try:
            self._insert(params)
            self._app.db.commit()
        except (KeyError, ValueError, DatabaseError):
            self._app.db.rollback()
            return '400 Bad Request', 'Bad Request', 'text/plain'
        return '200 OK', self._data(True), 'text/html; charset=utf-8'

    @CHttp.get('delete')
    def delete(self, params):
        try:
            self._delete(int(params['id']))
            self._app.db.commit()
            return '301 Redirect', [('Location', '/view'),
                                    # Чтобы редирект на клиенте не кэшировался
                                    ('Cache-Control', 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'),
                                    ('Expires', 'Sat, 26 Jul 1997 05:00:00 GMT')]
        except (KeyError, ValueError):
            self._app.db.rollback()
            return '400 Bad Request', 'Bad Request', 'text/plain'

    def _data(self, isSuccess=False):
        regions = self._app.db.select('SELECT id, name FROM Region')
        with open(os.path.join(self._app.templates, 'comment.xhtml'), 'r') as f:
            return f.read().format(success=u'Комментарий добавлен'.encode('utf-8') if isSuccess else '',
                                   regions=u''.join(['<option value="%s">%s</option>' % (region['id'], region['name'])
                                                     for region in regions]).encode('utf-8') if regions else '')

    def _insert(self, params):
        if not params['lastName'].strip() or not params['firstName'].strip() or not params['comment'].strip():
            raise ValueError('Required params not set')
        lastName = params['lastName'].strip()
        firstName = params['firstName'].strip()
        patrName = params['patrName'].strip() if 'patrName' in params else None
        try:
            cityId = int(params['city']) if 'city' in params else None
        except ValueError:
            cityId = None
        phone = params['phone'].strip() if 'phone' in params else None
        email = params['email'].strip() if 'email' in params else None
        comment = params['comment'].strip()
        self._app.db.execute('INSERT INTO Comment'
                             ' (lastName, firstName, patrName, city_id, phone, email, comment)'
                             ' VALUES'
                             ' (%s, %s, %s, %s, %s, %s, %s)', [lastName, firstName, patrName, cityId, phone, email,
                                                               comment])

    def _delete(self, commentId):
        self._app.db.execute('DELETE FROM Comment WHERE id = %s', [commentId])