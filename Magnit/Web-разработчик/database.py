#!/usr/bin/env python
# -*- coding: utf-8 -*-

import warnings

from MySQLdb import connect, Error as DatabaseError


class CDatabase(object):

    def __init__(self, **kwargs):
        warnings.filterwarnings("ignore", category=Warning)
        kwargs.update({'charset': 'utf8'})
        self._db = connect(**kwargs)

    def select(self, statement, values=None, isFirst=False):
        cursor = self._db.cursor()
        cursor.execute(statement, values)
        result = [dict((cursor.description[index][0], field) for index, field in enumerate(record))
                  for record in cursor.fetchall()]
        return result if not isFirst else result[0] if result else {}

    def execute(self, statement, values=None):
        cursor = self._db.cursor()
        return cursor.execute(statement, values), cursor.lastrowid

    def commit(self):
        self._db.commit()

    def rollback(self):
        self._db.rollback()

    def close(self):
        self._db.close()