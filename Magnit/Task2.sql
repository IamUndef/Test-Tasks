/*
    Задание №2 (Firebird 1.5)
    Необходимо выбрать все индексы, построенные по одном полю, исключая PK и FK.
    Вывести имя таблицы, имя индекса, имя поля индекса, уникальность.
*/

SELECT
    indexes.RDB$RELATION_NAME tableName,
    indexes.RDB$INDEX_NAME indexName,
    indexSegments.RDB$FIELD_NAME fieldName,
    ( CASE indexes.RDB$UNIQUE_FLAG WHEN 0 THEN 'NO' ELSE 'YES' END ) isUnique
FROM RDB$INDICES indexes
LEFT JOIN RDB$INDEX_SEGMENTS indexSegments ON
    indexSegments.RDB$INDEX_NAME = indexes.RDB$INDEX_NAME
LEFT JOIN RDB$RELATION_CONSTRAINTS constraints ON
    constraints.RDB$INDEX_NAME = indexes.RDB$INDEX_NAME
WHERE 
    ( indexes.RDB$SEGMENT_COUNT = 1 ) AND
    ( constraints.RDB$CONSTRAINT_TYPE IS NULL OR
      ( ( constraints.RDB$CONSTRAINT_TYPE <> 'PRIMARY KEY' ) AND
        ( constraints.RDB$CONSTRAINT_TYPE <> 'FOREIGN KEY' ) ) )
