options (skip=1,direct=true)
load data
characterset UTF8 length semantics char
infile 'Snapshot/Terminology/sct2_Relationship_Snapshot_INT_${version}.txt' "str X'0d0a'"
badfile 'relationship.bad'
discardfile 'relationship.dsc'
insert
into table relationship
reenable disabled_constraints
fields terminated by X'09'
trailing nullcols
(
    id INTEGER EXTERNAL,
    effectiveTime DATE "YYYYMMDD",
    active INTEGER EXTERNAL,
    moduleId INTEGER EXTERNAL,
    sourceId INTEGER EXTERNAL,
    destinationId INTEGER EXTERNAL,
    relationshipGroup INTEGER EXTERNAL,
    typeId INTEGER EXTERNAL,
    characteristicTypeId INTEGER EXTERNAL,
    modifierId INTEGER EXTERNAL
)