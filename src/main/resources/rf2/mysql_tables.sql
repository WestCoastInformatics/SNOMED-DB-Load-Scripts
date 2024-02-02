-- Show warnings after every statement.
\W

-- Disable foreign key checks so tables can be dropped/created in any order.
SET FOREIGN_KEY_CHECKS = 0;


-- Concept file.
DROP TABLE IF EXISTS concept;
CREATE TABLE concept
(
    id                 NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime      DATE        NOT NULL,
    active             BOOLEAN     NOT NULL,
    moduleId           NUMERIC(20) NOT NULL,
    definitionStatusId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (definitionStatusId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_Concept_Snapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE concept LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@definitionStatusId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
definitionStatusId = @definitionStatusId;


-- Description file.
DROP TABLE IF EXISTS description;
CREATE TABLE description
(
    id                 NUMERIC(20)  NOT NULL PRIMARY KEY,
    effectiveTime      DATE         NOT NULL,
    active             BOOLEAN      NOT NULL,
    moduleId           NUMERIC(20)  NOT NULL,
    conceptId          NUMERIC(20)  NOT NULL,
    languageCode       CHAR(2)      NOT NULL,
    typeId             NUMERIC(20)  NOT NULL,
    term               VARCHAR(255) NOT NULL,
    caseSignificanceId NUMERIC(20)  NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (conceptId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (caseSignificanceId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_Description_Snapshot-en_${editionLabel}_${editionVersion}.txt' INTO TABLE description LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@conceptId,@languageCode,@typeId,@term,@caseSignificanceId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
conceptId = @conceptId,
languageCode = @languageCode,
typeId = @typeId,
term = @term,
caseSignificanceId=@caseSignificanceId;


-- Identifier file.
DROP TABLE IF EXISTS identifier;
CREATE TABLE identifier
(
    identifierSchemeId    NUMERIC(20)  NOT NULL,
    alternateIdentifier   VARCHAR(255) NOT NULL,
    effectiveTime         DATE         NOT NULL,
    active                BOOLEAN      NOT NULL,
    moduleId              NUMERIC(20)  NOT NULL,
    referencedComponentId NUMERIC(20)  NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_Identifier_Snapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE identifier LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@identifierSchemeId,@alternateIdentifier,@effectiveTime,@active,@moduleId,@referencedComponentId)
SET identifierSchemeId = @identifierSchemeId,
alternateIdentifier = @alternateIdentifier,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
referencedComponentId = @referencedComponentId;


-- Relationship file.
DROP TABLE IF EXISTS relationship;
CREATE TABLE relationship
(
    id                   NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime        DATE        NOT NULL,
    active               BOOLEAN     NOT NULL,
    moduleId             NUMERIC(20) NOT NULL,
    sourceId             NUMERIC(20) NOT NULL,
    destinationId        NUMERIC(20) NOT NULL,
    relationshipGroup    INT UNSIGNED NOT NULL,
    typeId               NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId           NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (sourceId) REFERENCES concept (id),
    FOREIGN KEY (destinationId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept (id),
    FOREIGN KEY (modifierId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_Relationship_Snapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE relationship LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@sourceId,@destinationId,@relationshipGroup,@typeId,@characteristicTypeId,@modifierId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
sourceId = @sourceId,
destinationId = @destinationId,
relationshipGroup = @relationshipGroup,
typeId = @typeId,
characteristicTypeId = @characteristicTypeId,
modifierId = @modifierId;

-- Relationship concrete values file.
DROP TABLE IF EXISTS relationshipconcretevalues;
CREATE TABLE relationshipconcretevalues
(
    id                   NUMERIC(20)  NOT NULL PRIMARY KEY,
    effectiveTime        DATE         NOT NULL,
    active               BOOLEAN      NOT NULL,
    moduleId             NUMERIC(20)  NOT NULL,
    sourceId             NUMERIC(20)  NOT NULL,
    value                VARCHAR(256) NOT NULL,
    relationshipGroup    INT UNSIGNED NOT NULL,
    typeId               NUMERIC(20)  NOT NULL,
    characteristicTypeId NUMERIC(20)  NOT NULL,
    modifierId           NUMERIC(20)  NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (sourceId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept (id),
    FOREIGN KEY (modifierId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_RelationshipConcreteValues_Snapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE relationshipconcretevalues LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@sourceId,@value,@relationshipGroup,@typeId,@characteristicTypeId,@modifierId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
sourceId = @sourceId,
value = @value,
relationshipGroup = @relationshipGroup,
typeId = @typeId,
characteristicTypeId = @characteristicTypeId,
modifierId = @modifierId;

-- OWL Expression file.
DROP TABLE IF EXISTS owlexpression;
CREATE TABLE owlexpression
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    owlExpression         TEXT        NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (referencedComponentId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_sRefset_OWLExpressionSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE owlexpression LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@owlExpression)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
owlExpression = @owlExpression;


-- Stated Relationship file.
DROP TABLE IF EXISTS statedrelationship;
CREATE TABLE statedrelationship
(
    id                   NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime        DATE        NOT NULL,
    active               BOOLEAN     NOT NULL,
    moduleId             NUMERIC(20) NOT NULL,
    sourceId             NUMERIC(20) NOT NULL,
    destinationId        NUMERIC(20) NOT NULL,
    relationshipGroup    INT UNSIGNED NOT NULL,
    typeId               NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId           NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (sourceId) REFERENCES concept (id),
    FOREIGN KEY (destinationId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept (id),
    FOREIGN KEY (modifierId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_StatedRelationship_Snapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE statedrelationship LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@sourceId,@destinationId,@relationshipGroup,@typeId,@characteristicTypeId,@modifierId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
sourceId = @sourceId,
destinationId = @destinationId,
relationshipGroup = @relationshipGroup,
typeId = @typeId,
characteristicTypeId = @characteristicTypeId,
modifierId = @modifierId;

-- Text Definition file.
DROP TABLE IF EXISTS textdefinition;
CREATE TABLE textdefinition
(
    id                 NUMERIC(20)   NOT NULL PRIMARY KEY,
    effectiveTime      DATE          NOT NULL,
    active             BOOLEAN       NOT NULL,
    moduleId           NUMERIC(20)   NOT NULL,
    conceptId          NUMERIC(20)   NOT NULL,
    languageCode       CHAR(2)       NOT NULL,
    typeId             NUMERIC(20)   NOT NULL,
    term               VARCHAR(2048) NOT NULL,
    caseSignificanceId NUMERIC(20)   NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (conceptId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (caseSignificanceId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_TextDefinition_Snapshot-en_${editionLabel}_${editionVersion}.txt' INTO TABLE textdefinition LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@conceptId,@languageCode,@typeId,@term,@caseSignificanceId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
conceptId = @conceptId,
languageCode = @languageCode,
typeId = @typeId,
term = @term,
caseSignificanceId = @caseSignificanceId;


-- Association Reference refset file.
DROP TABLE IF EXISTS association;
CREATE TABLE association
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    targetComponent       NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (targetComponent) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Content/der2_cRefset_AssociationSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE association LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@targetComponent)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
targetComponent = @targetComponent;


-- Attribute Value refset file.
DROP TABLE IF EXISTS attributevalue;
CREATE TABLE attributevalue
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    valueId               NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (valueId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Content/der2_cRefset_AttributeValueSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE attributevalue LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@valueId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
valueId = @valueId;


-- Simple refset file.
DROP TABLE IF EXISTS simple;
CREATE TABLE simple
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Content/der2_Refset_SimpleSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE simple LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId;


-- No more complex map, ICD9CM maps deprecated
-- Complex Map refset file.
-- DROP TABLE IF EXISTS complexmap;
-- CREATE TABLE complexmap (
--    id CHAR(52) NOT NULL PRIMARY KEY,
--    effectiveTime DATE NOT NULL,
--    active BOOLEAN NOT NULL,
--    moduleId NUMERIC(20) NOT NULL,
--    refsetId NUMERIC(20) NOT NULL,
--    referencedComponentId NUMERIC(20) NOT NULL,
--    mapGroup INT UNSIGNED NOT NULL,
--    mapPriority INT UNSIGNED NOT NULL,
--    mapRule VARCHAR(4000) NOT NULL,
--    mapAdvice VARCHAR(4000) NOT NULL,
--    mapTarget VARCHAR(100) NOT NULL,
--    correlationId NUMERIC(20) NOT NULL,
--    FOREIGN KEY (moduleId) REFERENCES concept(id),
--    FOREIGN KEY (refsetId) REFERENCES concept(id),
--    FOREIGN KEY (correlationId) REFERENCES concept(id)
-- ) CHARACTER SET utf8;
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
DROP TABLE IF EXISTS extendedmap;
CREATE TABLE extendedmap
(
    id                    CHAR(52)      NOT NULL PRIMARY KEY,
    effectiveTime         DATE          NOT NULL,
    active                BOOLEAN       NOT NULL,
    moduleId              NUMERIC(20)   NOT NULL,
    refsetId              NUMERIC(20)   NOT NULL,
    referencedComponentId NUMERIC(20)   NOT NULL,
    mapGroup              INT UNSIGNED NOT NULL,
    mapPriority           INT UNSIGNED NOT NULL,
    mapRule               VARCHAR(4000) NOT NULL,
    mapAdvice             VARCHAR(4000) NOT NULL,
    mapTarget             VARCHAR(100)  NOT NULL,
    correlationId         NUMERIC(20)   NOT NULL,
    mapCategoryId         NUMERIC(20)   NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (correlationId) REFERENCES concept (id),
    FOREIGN KEY (mapCategoryId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Map/der2_iisssccRefset_ExtendedMapSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE extendedmap LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@mapGroup,@mapPriority,@mapRule,@mapAdvice,@mapTarget,@correlationId,@mapCategoryId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
mapGroup = @mapGroup,
mapPriority = @mapPriority,
mapRule = @mapRule,
mapAdvice = @mapAdvice,
mapTarget = @mapTarget,
correlationId = @correlationId,
mapCategoryId = @mapCategoryId;


-- Simple Map refset file.
DROP TABLE IF EXISTS simplemap;
CREATE TABLE simplemap
(
    id                    CHAR(52)     NOT NULL PRIMARY KEY,
    effectiveTime         DATE         NOT NULL,
    active                BOOLEAN      NOT NULL,
    moduleId              NUMERIC(20)  NOT NULL,
    refsetId              NUMERIC(20)  NOT NULL,
    referencedComponentId NUMERIC(20)  NOT NULL,
    mapTarget             VARCHAR(100) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Map/der2_sRefset_SimpleMapSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE simplemap LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@mapTarget)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
mapTarget = @mapTarget;


-- Language refset file.
DROP TABLE IF EXISTS language;
CREATE TABLE language
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    acceptabilityId       NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (acceptabilityId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Language/der2_cRefset_LanguageSnapshot-en_${editionLabel}_${editionVersion}.txt' INTO TABLE language LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@acceptabilityId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
acceptabilityId = @acceptabilityId;


-- Refset Descriptor refset file.
DROP TABLE IF EXISTS refsetdescriptor;
CREATE TABLE refsetdescriptor
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    attributeDescription  NUMERIC(20) NOT NULL,
    attributeType         NUMERIC(20) NOT NULL,
    attributeOrder        NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Metadata/der2_cciRefset_RefsetDescriptorSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE refsetdescriptor LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@attributeDescription,@attributeType,@attributeOrder)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
attributeDescription = @attributeDescription,
attributeType = @attributeType,
attributeOrder = @attributeOrder;


-- Description Type refset file.
DROP TABLE IF EXISTS descriptiontype;
CREATE TABLE descriptiontype
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    descriptionFormat     NUMERIC(20) NOT NULL,
    descriptionLength     INT UNSIGNED NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Metadata/der2_ciRefset_DescriptionTypeSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE descriptiontype LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@descriptionFormat,@descriptionLength)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
descriptionFormat = @descriptionFormat,
descriptionLength = @descriptionLength;


-- MRCM Attribute Domain refset file.
DROP TABLE IF EXISTS mrcmattributedomain;
CREATE TABLE mrcmattributedomain
(
    id                          CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime               DATE        NOT NULL,
    active                      BOOLEAN     NOT NULL,
    moduleId                    NUMERIC(20) NOT NULL,
    refsetId                    NUMERIC(20) NOT NULL,
    referencedComponentId       NUMERIC(20) NOT NULL,
    domainId                    NUMERIC(20) NOT NULL,
    grouped                     INT         NOT NULL,
    attributeCardinality        VARCHAR(20) NOT NULL,
    attributeInGroupCardinality VARCHAR(20) NOT NULL,
    ruleStrengthId              NUMERIC(20) NOT NULL,
    contentTypeId               NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (domainId) REFERENCES concept (id),
    FOREIGN KEY (ruleStrengthId) REFERENCES concept (id),
    FOREIGN KEY (contentTypeId) REFERENCES concept (id)
);

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Metadata/der2_cissccRefset_MRCMAttributeDomainSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE mrcmattributedomain LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@domainId,@grouped,@attributeCardinality,@attributeInGroupCardinality,@ruleStrengthId,@contentTypeId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
domainId = @domainId,
grouped = @grouped,
attributeCardinality = @attributeCardinality,
attributeInGroupCardinality = @attributeInGroupCardinality,
ruleStrengthId = @ruleStrengthId,
contentTypeId = @contentTypeId;


-- MRCM Module Scope refset file.
DROP TABLE IF EXISTS mrcmmodulescope;
CREATE TABLE mrcmmodulescope
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    mrcmRuleRefsetId      NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (mrcmRuleRefsetId) REFERENCES concept (id)
);

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Metadata/der2_cRefset_MRCMModuleScopeSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE mrcmmodulescope LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@mrcmRuleRefsetId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
mrcmRuleRefsetId = @mrcmRuleRefsetId;


-- MRCM Attribute Range refset file.
DROP TABLE IF EXISTS mrcmattributerange;
CREATE TABLE mrcmattributerange
(
    id                    CHAR(52)      NOT NULL PRIMARY KEY,
    effectiveTime         DATE          NOT NULL,
    active                BOOLEAN       NOT NULL,
    moduleId              NUMERIC(20)   NOT NULL,
    refsetId              NUMERIC(20)   NOT NULL,
    referencedComponentId NUMERIC(20)   NOT NULL,
    rangeConstraint       VARCHAR(4000) NOT NULL,
    attributeRule         VARCHAR(4000) NOT NULL,
    ruleStrengthId        NUMERIC(20)   NOT NULL,
    contentTypeId         NUMERIC(20)   NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (ruleStrengthId) REFERENCES concept (id),
    FOREIGN KEY (contentTypeId) REFERENCES concept (id)
);

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Metadata/der2_ssccRefset_MRCMAttributeRangeSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE mrcmattributerange LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@rangeConstraint,@attributeRule,@ruleStrengthId,@contentTypeId)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
rangeConstraint = @rangeConstraint,
attributeRule = @attributeRule,
ruleStrengthId = @ruleStrengthId,
contentTypeId = @contentTypeId;


-- MRCM Domain refset file.
DROP TABLE IF EXISTS mrcmdomain;
CREATE TABLE mrcmdomain
(
    id                                CHAR(52)      NOT NULL PRIMARY KEY,
    effectiveTime                     DATE          NOT NULL,
    active                            BOOLEAN       NOT NULL,
    moduleId                          NUMERIC(20)   NOT NULL,
    refsetId                          NUMERIC(20)   NOT NULL,
    referencedComponentId             NUMERIC(20)   NOT NULL,
    domainConstraint                  VARCHAR(4000) NOT NULL,
    parentDomain                      VARCHAR(4000),
    proximalPrimitiveConstraint       VARCHAR(4000) NOT NULL,
    proximalPrimitiveRefinement       VARCHAR(4000),
    domainTemplateForPrecoordination  TEXT          NOT NULL,
    domainTemplateForPostcoordination TEXT          NOT NULL,
    guideURL                          VARCHAR(4000),
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Metadata/der2_sssssssRefset_MRCMDomainSnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE mrcmdomain LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@domainConstraint,@parentDomain,@proximalPrimitiveConstraint,@proximalPrimitiveRefinement,@domainTemplateForPrecoordination,@domainTemplateForPostcoordination,@guideURL)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
domainConstraint = @domainConstraint,
proximalPrimitiveConstraint = @proximalPrimitiveConstraint,
proximalPrimitiveRefinement = @proximalPrimitiveRefinement,
domainTemplateForPrecoordination = @domainTemplateForPrecoordination,
domainTemplateForPostcoordination = @domainTemplateForPostcoordination,
guideURL = @guideURL;


-- Module Dependency refset file.
DROP TABLE IF EXISTS moduledependency;
CREATE TABLE moduledependency
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                BOOLEAN     NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    sourceEffectiveTime   DATE        NOT NULL,
    targetEffectiveTime   DATE        NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Refset/Metadata/der2_ssRefset_ModuleDependencySnapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE moduledependency LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@id,@effectiveTime,@active,@moduleId,@refsetId,@referencedComponentId,@sourceEffectiveTime,@targetEffectiveTime)
SET id = @id,
effectiveTime = @effectiveTime,
active = @active,
moduleId = @moduleId,
refsetId = @refsetId,
referencedComponentId = @referencedComponentId,
sourceEffectiveTime = @sourceEffectiveTime,
targetEffectiveTime = @targetEffectiveTime;


-- Transitive Closure table.
DROP TABLE IF EXISTS transitiveclosure;
CREATE TABLE transitiveclosure
(
    superTypeId NUMERIC(20) NOT NULL,
    subTypeId   NUMERIC(20) NOT NULL,
    depth       INT         NOT NULL,
    PRIMARY KEY (superTypeId, subTypeId),
    FOREIGN KEY (superTypeId) REFERENCES concept (id),
    FOREIGN KEY (subTypeId) REFERENCES concept (id)
) CHARACTER SET utf8;

LOAD
DATA LOCAL INFILE 'Snapshot/Terminology/sct2_TransitiveClosure_Snapshot_${editionLabel}_${editionVersion}.txt' INTO TABLE transitiveclosure LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@superTypeId,@subTypeId,@depth)
SET superTypeId = @superTypeId,
subTypeId = @subTypeId,
depth = @depth;

-- Restore foreign key checks to enforce referential integrity.
SET
FOREIGN_KEY_CHECKS = 1;