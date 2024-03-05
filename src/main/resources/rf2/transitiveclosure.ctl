options (skip=1,direct=true)
load data
characterset UTF8 length semantics char
infile 'Snapshot/Terminology/sct2_TransitiveClosure_Snapshot_${editionLabel}_${editionVersion}.txt' "str X'0d0a'"
badfile 'transitiveclosure.bad'
discardfile 'transitiveclosure.dsc'
insert
into table transitiveclosure
reenable disabled_constraints
fields terminated by X'09'
trailing nullcols
(
    superTypeId INTEGER EXTERNAL,
    subTypeId INTEGER EXTERNAL,
    depth INTEGER EXTERNAL
)