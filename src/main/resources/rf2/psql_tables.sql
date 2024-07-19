
-- Concept file.
DROP TABLE IF EXISTS concept CASCADE;
CREATE TABLE concept (
    id NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    definitionStatusId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (definitionStatusId) REFERENCES concept(id)
);

\copy concept FROM 'Snapshot/Terminology/sct2_Concept_Snapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;

-- Description file.
DROP TABLE IF EXISTS description CASCADE;
CREATE TABLE description (
    id NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    conceptId NUMERIC(20) NOT NULL,
    languageCode CHAR(2) NOT NULL,
    typeId NUMERIC(20) NOT NULL,
    term VARCHAR(4096) NOT NULL,
    caseSignificanceId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (conceptId) REFERENCES concept(id),
    FOREIGN KEY (typeId) REFERENCES concept(id),
    FOREIGN KEY (caseSignificanceId) REFERENCES concept(id)
);

\copy description FROM 'Snapshot/Terminology/sct2_Description_Snapshot-en_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;

-- Identifier file.
DROP TABLE IF EXISTS identifier CASCADE;
CREATE TABLE identifier (
    identifierSchemeId NUMERIC(20) NOT NULL,
    alternateIdentifier VARCHAR(4096) NOT NULL,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id)
);

\copy identifier FROM 'Snapshot/Terminology/sct2_Identifier_Snapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Relationship file.
DROP TABLE IF EXISTS relationship CASCADE;
CREATE TABLE relationship (
    id NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    sourceId NUMERIC(20) NOT NULL,
    destinationId NUMERIC(20) NOT NULL,
    relationshipGroup INT NOT NULL,
    typeId NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (sourceId) REFERENCES concept(id),
    FOREIGN KEY (destinationId) REFERENCES concept(id),
    FOREIGN KEY (typeId) REFERENCES concept(id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept(id),
    FOREIGN KEY (modifierId) REFERENCES concept(id)
);

\copy relationship FROM 'Snapshot/Terminology/sct2_Relationship_Snapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;

-- Relationship concrete values file.
DROP TABLE IF EXISTS relationshipconcretevalues CASCADE;
CREATE TABLE relationshipconcretevalues (
    id NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    sourceId NUMERIC(20) NOT NULL,
    value VARCHAR(256) NOT NULL,
    relationshipGroup INT NOT NULL,
    typeId NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (sourceId) REFERENCES concept(id),
    FOREIGN KEY (typeId) REFERENCES concept(id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept(id),
    FOREIGN KEY (modifierId) REFERENCES concept(id)
);

\copy relationshipconcretevalues FROM 'Snapshot/Terminology/sct2_RelationshipConcreteValues_Snapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- OWL Expression file.
DROP TABLE IF EXISTS owlexpression CASCADE;
CREATE TABLE owlexpression (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    owlExpression VARCHAR(10000) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (referencedComponentId) REFERENCES concept(id)
);

\copy owlexpression FROM 'Snapshot/Terminology/sct2_sRefset_OWLExpressionSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Stated Relationship file.
DROP TABLE IF EXISTS statedrelationship CASCADE;
CREATE TABLE statedrelationship (
    id NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    sourceId NUMERIC(20) NOT NULL,
    destinationId NUMERIC(20) NOT NULL,
    relationshipGroup INT NOT NULL,
    typeId NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (sourceId) REFERENCES concept(id),
    FOREIGN KEY (destinationId) REFERENCES concept(id),
    FOREIGN KEY (typeId) REFERENCES concept(id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept(id),
    FOREIGN KEY (modifierId) REFERENCES concept(id)
);

\copy statedrelationship FROM 'Snapshot/Terminology/sct2_StatedRelationship_Snapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Text Definition file.
DROP TABLE IF EXISTS textdefinition CASCADE;
CREATE TABLE textdefinition (
    id NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    conceptId NUMERIC(20) NOT NULL,
    languageCode CHAR(2) NOT NULL,
    typeId NUMERIC(20) NOT NULL,
    term VARCHAR(2048) NOT NULL,
    caseSignificanceId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (conceptId) REFERENCES concept(id),
    FOREIGN KEY (typeId) REFERENCES concept(id),
    FOREIGN KEY (caseSignificanceId) REFERENCES concept(id)
);

\copy textdefinition FROM 'Snapshot/Terminology/sct2_TextDefinition_Snapshot-en_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Association Reference refset file.
DROP TABLE IF EXISTS association CASCADE;
CREATE TABLE association (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    targetComponent NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (targetComponent) REFERENCES concept(id)
);

\copy association FROM 'Snapshot/Refset/Content/der2_cRefset_AssociationSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Attribute Value refset file.
DROP TABLE IF EXISTS attributevalue CASCADE;
CREATE TABLE attributevalue (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    valueId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (valueId) REFERENCES concept(id)
);

\copy attributevalue FROM 'Snapshot/Refset/Content/der2_cRefset_AttributeValueSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Simple refset file.
DROP TABLE IF EXISTS simple CASCADE;
CREATE TABLE simple (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id)
);

\copy simple FROM 'Snapshot/Refset/Content/der2_Refset_SimpleSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- No more complex map, ICD9CM maps deprecated
-- Complex Map refset file.
-- DROP TABLE IF EXISTS complexmap CASCADE;
-- CREATE TABLE complexmap (
--    id CHAR(52) NOT NULL PRIMARY KEY,
--    effectiveTime DATE NOT NULL,
--    active BOOLEAN NOT NULL,
--    moduleId NUMERIC(20) NOT NULL,
--    refsetId NUMERIC(20) NOT NULL,
--    referencedComponentId NUMERIC(20) NOT NULL,
--    mapGroup INT NOT NULL,
--    mapPriority INT NOT NULL,
--    mapRule VARCHAR(4000) NOT NULL,
--    mapAdvice VARCHAR(4000) NOT NULL,
--    mapTarget VARCHAR(100) NOT NULL,
--    correlationId NUMERIC(20) NOT NULL,
--    FOREIGN KEY (moduleId) REFERENCES concept(id),
--    FOREIGN KEY (refsetId) REFERENCES concept(id),
--    FOREIGN KEY (correlationId) REFERENCES concept(id)
-- );
--
-- LOAD DATA LOCAL INFILE 'Snapshot/Refset/Map/der2_iissscRefset_ComplexMapSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE complexmap LINES TERMINATED BY '\r\n' IGNORE 1 LINES
-- (@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@mapGroup,@mapPriority,@mapRule,@mapAdvice,@mapTarget,@correlationId)
-- SET id = @id,
-- effectiveTime = @effectiveTime,
-- active = @active,
-- moduleId = @moduleId,
-- refsetId = @refsetId,
-- referencedComponentId = @referencedComponentId,
-- mapGroup = @mapGroup,
-- mapPriority = @mapPriority,
-- mapRule = @mapRule,
-- mapAdvice = @mapAdvice,
-- mapTarget = @mapTarget,
-- correlationId = @correlationId;


-- Extended Map refset file.
DROP TABLE IF EXISTS extendedmap CASCADE;
CREATE TABLE extendedmap (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    mapGroup INT NOT NULL,
    mapPriority INT NOT NULL,
    mapRule VARCHAR(4000) NOT NULL,
    mapAdvice VARCHAR(4000) NOT NULL,
    mapTarget VARCHAR(100),
    correlationId NUMERIC(20) NOT NULL,
    mapCategoryId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (correlationId) REFERENCES concept(id),
    FOREIGN KEY (mapCategoryId) REFERENCES concept(id)
);

\copy extendedmap FROM 'Snapshot/Refset/Map/der2_iisssccRefset_ExtendedMapSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Simple Map refset file.
DROP TABLE IF EXISTS simplemap CASCADE;
CREATE TABLE simplemap (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    mapTarget VARCHAR(100) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id)
);

\copy simplemap FROM 'Snapshot/Refset/Map/der2_sRefset_SimpleMapSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Language refset file.
DROP TABLE IF EXISTS language CASCADE;
CREATE TABLE language (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    acceptabilityId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (acceptabilityId) REFERENCES concept(id)
);

\copy language FROM 'Snapshot/Refset/Language/der2_cRefset_LanguageSnapshot-en_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Refset Descriptor refset file.
DROP TABLE IF EXISTS refsetdescriptor CASCADE;
CREATE TABLE refsetdescriptor (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    attributeDescription NUMERIC(20) NOT NULL,
    attributeType NUMERIC(20) NOT NULL,
    attributeOrder NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id)
);

\copy refsetdescriptor FROM 'Snapshot/Refset/Metadata/der2_cciRefset_RefsetDescriptorSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Description Type refset file.
DROP TABLE IF EXISTS descriptiontype CASCADE;
CREATE TABLE descriptiontype (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    descriptionFormat NUMERIC(20) NOT NULL,
    descriptionLength INT NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id)
);

\copy descriptiontype FROM 'Snapshot/Refset/Metadata/der2_ciRefset_DescriptionTypeSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- MRCM Attribute Domain refset file.
DROP TABLE IF EXISTS mrcmattributedomain CASCADE;
CREATE TABLE mrcmattributedomain (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    domainId NUMERIC(20) NOT NULL,
    grouped INT NOT NULL,
    attributeCardinality VARCHAR(20) NOT NULL,
    attributeInGroupCardinality VARCHAR(20) NOT NULL,
    ruleStrengthId NUMERIC(20) NOT NULL,
    contentTypeId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (domainId) REFERENCES concept(id),
    FOREIGN KEY (ruleStrengthId) REFERENCES concept(id),
    FOREIGN KEY (contentTypeId) REFERENCES concept(id)
);

\copy mrcmattributedomain FROM 'Snapshot/Refset/Metadata/der2_cissccRefset_MRCMAttributeDomainSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- MRCM Module Scope refset file.
DROP TABLE IF EXISTS mrcmmodulescope CASCADE;
CREATE TABLE mrcmmodulescope (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    mrcmRuleRefsetId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (mrcmRuleRefsetId) REFERENCES concept(id)
);

\copy mrcmmodulescope FROM 'Snapshot/Refset/Metadata/der2_cRefset_MRCMModuleScopeSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- MRCM Attribute Range refset file.
DROP TABLE IF EXISTS mrcmattributerange CASCADE;
CREATE TABLE mrcmattributerange (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    rangeConstraint VARCHAR(4000) NOT NULL,
    attributeRule VARCHAR(4000) NOT NULL,
    ruleStrengthId NUMERIC(20) NOT NULL,
    contentTypeId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id),
    FOREIGN KEY (ruleStrengthId) REFERENCES concept(id),
    FOREIGN KEY (contentTypeId) REFERENCES concept(id)
);

\copy mrcmattributerange FROM 'Snapshot/Refset/Metadata/der2_ssccRefset_MRCMAttributeRangeSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- MRCM Domain refset file.
DROP TABLE IF EXISTS mrcmdomain CASCADE;
CREATE TABLE mrcmdomain (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    domainConstraint VARCHAR(4000) NOT NULL,
    parentDomain VARCHAR(4000),
    proximalPrimitiveConstraint VARCHAR(4000) NOT NULL,
    proximalPrimitiveRefinement VARCHAR(4000),
    domainTemplateForPrecoordination VARCHAR(40000) NOT NULL,
    domainTemplateForPostcoordination VARCHAR(40000) NOT NULL,
    guideURL VARCHAR(4000),
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id)
);

\copy mrcmdomain FROM 'Snapshot/Refset/Metadata/der2_sssssssRefset_MRCMDomainSnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;


-- Module Dependency refset file.
DROP TABLE IF EXISTS moduledependency CASCADE;
CREATE TABLE moduledependency (
    id CHAR(52) NOT NULL PRIMARY KEY,
    effectiveTime DATE NOT NULL,
    active BOOLEAN NOT NULL,
    moduleId NUMERIC(20) NOT NULL,
    refsetId NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    sourceEffectiveTime DATE NOT NULL,
    targetEffectiveTime DATE NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept(id),
    FOREIGN KEY (refsetId) REFERENCES concept(id)
);

\copy moduledependency FROM 'Snapshot/Refset/Metadata/der2_ssRefset_ModuleDependencySnapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;

-- Transitive closure table.
DROP TABLE IF EXISTS transitiveclosure CASCADE;
CREATE TABLE transitiveclosure (
    superTypeId NUMERIC(20) NOT NULL,
    subTypeId NUMERIC(20) NOT NULL,
    depth INT NOT NULL,
    PRIMARY KEY (superTypeId, subTypeId),
    FOREIGN KEY (superTypeId) REFERENCES concept(id),
    FOREIGN KEY (subTypeId) REFERENCES concept(id)
);

\copy transitiveclosure FROM 'Snapshot/Terminology/sct2_TransitiveClosure_Snapshot_${editionLabel}_${editionVersion}.txt' WITH DELIMITER E'\t' QUOTE E'\\' ENCODING 'UTF8' CSV HEADER;
