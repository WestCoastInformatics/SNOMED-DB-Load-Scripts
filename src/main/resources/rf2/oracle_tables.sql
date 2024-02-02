WHENEVER SQLERROR EXIT -1
SET ECHO ON


-- Session settings.
ALTER
SESSION SET NLS_LENGTH_SEMANTICS='CHAR';


-- Define helper procedure to drop tables.
BEGIN
EXECUTE IMMEDIATE 'DROP PROCEDURE drop_table';
EXCEPTION
    WHEN OTHERS THEN
        -- If procedure doesn't exist, it can't be dropped,
        -- so an exception will be thrown.  Ignore it.
        IF SQLCODE != -4043 THEN
            RAISE;
END IF;
END;
/
CREATE PROCEDURE drop_table(table_name IN VARCHAR2) IS
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE ' || table_name || ' CASCADE CONSTRAINTS';
EXCEPTION
    -- If table doesn't exist, it can't be dropped,
    -- so an exception will be thrown.  Ignore it.
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
END IF;
END;
/


-- Concept table.
EXECUTE drop_table('concept');
CREATE TABLE concept
(
    id                 NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime      DATE        NOT NULL,
    active             NUMERIC(1)  NOT NULL,
    moduleId           NUMERIC(20) NOT NULL,
    definitionStatusId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (definitionStatusId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Description table.
EXECUTE drop_table('description');
CREATE TABLE description
(
    id                 NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime      DATE        NOT NULL,
    active             NUMERIC(1)  NOT NULL,
    moduleId           NUMERIC(20) NOT NULL,
    conceptId          NUMERIC(20) NOT NULL,
    languageCode       CHAR(2)     NOT NULL,
    typeId             NUMERIC(20) NOT NULL,
    term               VARCHAR2(255) NOT NULL,
    caseSignificanceId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (conceptId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (caseSignificanceId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Identifier table.
EXECUTE drop_table('identifier');
CREATE TABLE identifier
(
    identifierSchemeId    NUMERIC(20) NOT NULL,
    alternateIdentifier   VARCHAR2(255) NOT NULL,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Relationship table.
EXECUTE drop_table('relationship');
CREATE TABLE relationship
(
    id                   NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime        DATE        NOT NULL,
    active               NUMERIC(1)  NOT NULL,
    moduleId             NUMERIC(20) NOT NULL,
    sourceId             NUMERIC(20) NOT NULL,
    destinationId        NUMERIC(20) NOT NULL,
    relationshipGroup    INT         NOT NULL,
    typeId               NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId           NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (sourceId) REFERENCES concept (id),
    FOREIGN KEY (destinationId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept (id),
    FOREIGN KEY (modifierId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;

-- Relationship concrete values table.
EXECUTE drop_table('relationshipconcretevalues');
CREATE TABLE relationshipconcretevalues
(
    id                   NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime        DATE        NOT NULL,
    active               NUMERIC(1)  NOT NULL,
    moduleId             NUMERIC(20) NOT NULL,
    sourceId             NUMERIC(20) NOT NULL,
    value                VARCHAR2(256) NOT NULL,
    relationshipGroup    INT         NOT NULL,
    typeId               NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId           NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (sourceId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept (id),
    FOREIGN KEY (modifierId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;

-- OWL Expression table.
EXECUTE drop_table('owlexpression');
CREATE TABLE owlexpression
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    owlExpression         VARCHAR2(4000) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (referencedComponentId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;

-- Stated Relationship table.
EXECUTE drop_table('statedrelationship');
CREATE TABLE statedrelationship
(
    id                   NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime        DATE        NOT NULL,
    active               NUMERIC(1)  NOT NULL,
    moduleId             NUMERIC(20) NOT NULL,
    sourceId             NUMERIC(20) NOT NULL,
    destinationId        NUMERIC(20) NOT NULL,
    relationshipGroup    INT         NOT NULL,
    typeId               NUMERIC(20) NOT NULL,
    characteristicTypeId NUMERIC(20) NOT NULL,
    modifierId           NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (sourceId) REFERENCES concept (id),
    FOREIGN KEY (destinationId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (characteristicTypeId) REFERENCES concept (id),
    FOREIGN KEY (modifierId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Text Definition table.
EXECUTE drop_table('textdefinition');
CREATE TABLE textdefinition
(
    id                 NUMERIC(20) NOT NULL PRIMARY KEY,
    effectiveTime      DATE        NOT NULL,
    active             NUMERIC(1)  NOT NULL,
    moduleId           NUMERIC(20) NOT NULL,
    conceptId          NUMERIC(20) NOT NULL,
    languageCode       CHAR(2)     NOT NULL,
    typeId             NUMERIC(20) NOT NULL,
    term               VARCHAR2(2048) NOT NULL,
    caseSignificanceId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (conceptId) REFERENCES concept (id),
    FOREIGN KEY (typeId) REFERENCES concept (id),
    FOREIGN KEY (caseSignificanceId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Association refset table.
EXECUTE drop_table('association');
CREATE TABLE association
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    targetComponent       NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
    -- TODO: FOREIGN KEY targetComponent?
) PCTFREE 10 PCTUSED 80;


-- Attribute Value refset table.
EXECUTE drop_table('attributevalue');
CREATE TABLE attributevalue
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    valueId               NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (valueId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Simple refset table.
EXECUTE drop_table('simple');
CREATE TABLE simple
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;

-- No more complex map, ICD9CM maps deprecated
-- Complex Map refset table.
--EXECUTE drop_table('complexmap');
--CREATE TABLE complexmap (
--    id CHAR(52) NOT NULL PRIMARY KEY,
--    effectiveTime DATE NOT NULL,
--    active NUMERIC(1) NOT NULL,
--    moduleId NUMERIC(20) NOT NULL,
--    refsetId NUMERIC(20) NOT NULL,
--    referencedComponentId NUMERIC(20) NOT NULL,
--    mapGroup INT NOT NULL,
--    mapPriority INT NOT NULL,
--    mapRule VARCHAR2(4000),
--    mapAdvice VARCHAR2(4000),
--    mapTarget VARCHAR2(100),
--    correlationId NUMERIC(20) NOT NULL,
--    FOREIGN KEY (moduleId) REFERENCES concept(id),
--    FOREIGN KEY (refsetId) REFERENCES concept(id),
--    FOREIGN KEY (correlationId) REFERENCES concept(id)
--)
--PCTFREE 10 PCTUSED 80;


-- Extended Map refset table.
EXECUTE drop_table('extendedmap');
CREATE TABLE extendedmap
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    mapGroup              INT         NOT NULL,
    mapPriority           INT         NOT NULL,
    mapRule               VARCHAR2(4000),
    mapAdvice             VARCHAR2(4000),
    mapTarget             VARCHAR2(100),
    correlationId         NUMERIC(20) NOT NULL,
    mapCategoryId         NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (correlationId) REFERENCES concept (id),
    FOREIGN KEY (mapCategoryId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Simple Map refset table.
EXECUTE drop_table('simplemap');
CREATE TABLE simplemap
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    mapTarget             VARCHAR2(100) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Lanuage refset table.
EXECUTE drop_table('language');
CREATE TABLE language
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    acceptabilityId       NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (acceptabilityId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Refset Descriptor refset table.
EXECUTE drop_table('refsetdescriptor');
CREATE TABLE refsetdescriptor
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    attributeDescription  NUMERIC(20) NOT NULL,
    attributeType         NUMERIC(20) NOT NULL,
    attributeOrder        NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Description Type refset table.
EXECUTE drop_table('descriptiontype');
CREATE TABLE descriptiontype
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    descriptionFormat     NUMERIC(20) NOT NULL,
    descriptionLength     INT         NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- MRCM Attribute Domain refset file.
EXECUTE drop_table('mrcmattributedomain');
CREATE TABLE mrcmattributedomain
(
    id                          CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime               DATE        NOT NULL,
    active                      NUMERIC(1)  NOT NULL,
    moduleId                    NUMERIC(20) NOT NULL,
    refsetId                    NUMERIC(20) NOT NULL,
    referencedComponentId       NUMERIC(20) NOT NULL,
    domainId                    NUMERIC(20) NOT NULL,
    grouped                     INT         NOT NULL,
    attributeCardinality        VARCHAR2(20) NOT NULL,
    attributeInGroupCardinality VARCHAR2(20) NOT NULL,
    ruleStrengthId              NUMERIC(20) NOT NULL,
    contentTypeId               NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (domainId) REFERENCES concept (id),
    FOREIGN KEY (ruleStrengthId) REFERENCES concept (id),
    FOREIGN KEY (contentTypeId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- MRCM Module Scope refset file.
EXECUTE drop_table('mrcmmodulescope');
CREATE TABLE mrcmmodulescope
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    mrcmRuleRefsetId      NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (mrcmRuleRefsetId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- MRCM Attribute Range refset file.
EXECUTE drop_table('mrcmattributerange');
CREATE TABLE mrcmattributerange
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    rangeConstraint       VARCHAR2(4000) NOT NULL,
    attributeRule         VARCHAR2(4000) NOT NULL,
    ruleStrengthId        NUMERIC(20) NOT NULL,
    contentTypeId         NUMERIC(20) NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id),
    FOREIGN KEY (ruleStrengthId) REFERENCES concept (id),
    FOREIGN KEY (contentTypeId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- MRCM Domain refset file.
EXECUTE drop_table('mrcmdomain');
CREATE TABLE mrcmdomain
(
    id                                CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime                     DATE        NOT NULL,
    active                            NUMERIC(1)  NOT NULL,
    moduleId                          NUMERIC(20) NOT NULL,
    refsetId                          NUMERIC(20) NOT NULL,
    referencedComponentId             NUMERIC(20) NOT NULL,
    domainConstraint                  VARCHAR2(4000) NOT NULL,
    parentDomain                      VARCHAR2(4000),
    proximalPrimitiveConstraint       VARCHAR2(4000) NOT NULL,
    proximalPrimitiveRefinement       VARCHAR2(4000),
    domainTemplateForPrecoordination  VARCHAR2(4000) NOT NULL,
    domainTemplateForPostcoordination VARCHAR2(4000) NOT NULL,
    guideURL                          VARCHAR2(4000),
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Module Dependency refset table.
EXECUTE drop_table('moduledependency');
CREATE TABLE moduledependency
(
    id                    CHAR(52)    NOT NULL PRIMARY KEY,
    effectiveTime         DATE        NOT NULL,
    active                NUMERIC(1)  NOT NULL,
    moduleId              NUMERIC(20) NOT NULL,
    refsetId              NUMERIC(20) NOT NULL,
    referencedComponentId NUMERIC(20) NOT NULL,
    sourceEffectiveTime   DATE        NOT NULL,
    targetEffectiveTime   DATE        NOT NULL,
    FOREIGN KEY (moduleId) REFERENCES concept (id),
    FOREIGN KEY (refsetId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;

-- Transitive closure table
EXECUTE drop_table('transitiveclosure');
CREATE TABLE transitiveclosure
(
    superTypeId NUMERIC(20) NOT NULL,
    subTypeId   NUMERIC(20) NOT NULL,
    depth       INTEGER     NOT NULL,
    PRIMARY KEY (superTypeId, subTypeId),
    FOREIGN KEY (superTypeId) REFERENCES concept (id),
    FOREIGN KEY (subTypeId) REFERENCES concept (id)
) PCTFREE 10 PCTUSED 80;


-- Clean up helper procedures.
DROP PROCEDURE drop_table;
