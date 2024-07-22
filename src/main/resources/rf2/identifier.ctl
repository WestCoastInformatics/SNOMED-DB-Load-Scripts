options (skip=1,direct=true)
load data
characterset UTF8 length semantics char
infile 'Snapshot/Terminology/sct2_Identifier_Snapshot_${editionLabel}_${editionVersion}.txt' "str X'0d0a'"
badfile 'identifier.bad'
discardfile 'identifier.dsc'
insert
into table identifier
reenable disabled_constraints
fields terminated by X'09'
trailing nullcols
(
    identifierSchemeId INTEGER EXTERNAL,
    alternateIdentifier CHAR(4096),
    effectiveTime DATE "YYYYMMDD",
    active INTEGER EXTERNAL,
    moduleId INTEGER EXTERNAL,
    referencedComponentId INTEGER EXTERNAL
)