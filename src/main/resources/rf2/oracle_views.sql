WHENEVER SQLERROR EXIT -1
SET ECHO ON


-- Session settings.
ALTER
SESSION SET NLS_LENGTH_SEMANTICS='CHAR';


-- Define helper procedure to drop views.
BEGIN
EXECUTE IMMEDIATE 'DROP PROCEDURE drop_view';
EXCEPTION
    WHEN OTHERS THEN
        -- If procedure doesn't exist, it can't be dropped,
        -- so an exception will be thrown.  Ignore it.
        IF SQLCODE != -4043 THEN
            RAISE;
END IF;
END;
/
CREATE PROCEDURE drop_view(view_name IN VARCHAR2) IS
BEGIN
EXECUTE IMMEDIATE 'DROP VIEW ' || view_name || ' CASCADE CONSTRAINTS';
EXCEPTION
    -- If view doesn't exist, it can't be dropped,
    -- so an exception will be thrown.  Ignore it.
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
END IF;
END;
/


-- Concept Preferred Name view, used by other views.
-- 900000000000013009 = Synonym description type
-- 900000000000548007 = Preferred
-- 900000000000509007 = United States of America English language reference set
EXECUTE drop_view('conceptpreferredname');
CREATE VIEW conceptpreferredname AS
SELECT c.id conceptId, NVL(d.term, 'no active preferred synonym') preferredName, d.id descriptionId
FROM concept c
         LEFT OUTER JOIN description d
                         ON c.id = d.conceptId
                             AND d.active = 1
                             AND d.typeId = 900000000000013009
         LEFT OUTER JOIN language l
                         ON d.id = l.referencedComponentId
                             AND l.active = 1
                             AND l.acceptabilityId = 900000000000548007
                             AND l.refSetId = 900000000000509007
WHERE (l.acceptabilityId IS NOT null OR d.TERM IS null);


-- Concept table with names.
EXECUTE drop_view('conceptwithnames');
CREATE VIEW conceptwithnames AS
SELECT id,
       cpn1.preferredName idName,
       effectiveTime,
       active,
       moduleId,
       cpn2.preferredName moduleIdName,
       definitionStatusId,
       cpn3.preferredName definitionStatusIdName
FROM concept,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE id = cpn1.conceptId
  AND moduleId = cpn2.conceptId
  AND definitionStatusId = cpn3.conceptId;


-- Description table.
EXECUTE drop_view('descriptionwithnames');
CREATE VIEW descriptionwithnames AS
SELECT id,
       term,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       d.conceptId,
       cpn2.preferredName conceptIdName,
       languageCode,
       typeId,
       cpn3.preferredName typeIdName,
       caseSignificanceId,
       cpn4.preferredName caseSignificanceIdName
FROM description d,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4
WHERE moduleId = cpn1.conceptId
  AND d.conceptId = cpn2.conceptId
  AND typeId = cpn3.conceptId
  AND caseSignificanceId = cpn4.conceptId;


-- Identifier table.
EXECUTE drop_view('identifierwithnames');
CREATE VIEW identifierwithnames AS
SELECT identifierSchemeId,
       cpn1.preferredName identifierSchemeIdName,
       alternateIdentifier,
       effectiveTime,
       active,
       moduleId,
       cpn2.preferredName moduleIdName,
       referencedComponentId
FROM identifier,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2
WHERE identifierSchemeId = cpn1.conceptId
  AND moduleId = cpn2.conceptId;


-- Relationship table.
EXECUTE drop_view('relationshipwithnames');
CREATE VIEW relationshipwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       sourceId,
       cpn2.preferredName sourceIdName,
       destinationId,
       cpn3.preferredName destinationIdName,
       relationshipGroup,
       typeId,
       cpn4.preferredName typeIdName,
       characteristicTypeId,
       cpn5.preferredName characteristicTypeIdName,
       modifierId,
       cpn6.preferredName modifierIdName
from relationship,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4,
     conceptpreferredname cpn5,
     conceptpreferredname cpn6
WHERE moduleId = cpn1.conceptId
  AND sourceId = cpn2.conceptId
  AND destinationId = cpn3.conceptId
  AND typeId = cpn4.conceptId
  AND characteristicTypeId = cpn5.conceptId
  AND modifierId = cpn6.conceptId;

xxx-- Relationship concrete values table.
EXECUTE drop_view('relationshipconcretevalueswithnames');
CREATE VIEW relationshipconcretevalueswithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       sourceId,
       cpn2.preferredName sourceIdName,
       value,
       relationshipGroup,
       typeId,
       cpn4.preferredName typeIdName,
       characteristicTypeId,
       cpn5.preferredName characteristicTypeIdName,
       modifierId,
       cpn6.preferredName modifierIdName
from relationshipconcretevalues,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn4,
     conceptpreferredname cpn5,
     conceptpreferredname cpn6
WHERE moduleId = cpn1.conceptId
  AND sourceId = cpn2.conceptId
  AND typeId = cpn4.conceptId
  AND characteristicTypeId = cpn5.conceptId
  AND modifierId = cpn6.conceptId;

-- Stated Relationship table.
EXECUTE drop_view('statedrelationshipwithnames');
CREATE VIEW statedrelationshipwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       sourceId,
       cpn2.preferredName sourceIdName,
       destinationId,
       cpn3.preferredName destinationIdName,
       relationshipGroup,
       typeId,
       cpn4.preferredName typeIdName,
       characteristicTypeId,
       cpn5.preferredName characteristicTypeIdName,
       modifierId,
       cpn6.preferredName modifierIdName
from statedrelationship,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4,
     conceptpreferredname cpn5,
     conceptpreferredname cpn6
WHERE moduleId = cpn1.conceptId
  AND sourceId = cpn2.conceptId
  AND destinationId = cpn3.conceptId
  AND typeId = cpn4.conceptId
  AND characteristicTypeId = cpn5.conceptId
  AND modifierId = cpn6.conceptId;


-- Text Definition table.
EXECUTE drop_view('textdefinitionwithnames');
CREATE VIEW textdefinitionwithnames AS
SELECT id,
       term,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       td.conceptId,
       cpn2.preferredName conceptIdName,
       languageCode,
       typeId,
       cpn3.preferredName typeIdName,
       caseSignificanceId,
       cpn4.preferredName caseSignificanceIdName
from textdefinition td,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4
WHERE moduleId = cpn1.conceptId
  AND td.conceptId = cpn2.conceptId
  AND typeId = cpn3.conceptId
  AND caseSignificanceId = cpn4.conceptId;


-- Association refset table.
EXECUTE drop_view('associationwithnames');
CREATE VIEW associationwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       targetComponent,
       cpn4.preferredName targetComponentName
from association,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId
  AND targetComponent = cpn4.conceptId;


-- Attribute Value refset table.
EXECUTE drop_view('attributevaluewithnames');
CREATE VIEW attributevaluewithnames AS
SELECT attributevalue.id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       valueId,
       cpn4.preferredName valueIdName
FROM attributevalue,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     (SELECT conceptId id, preferredName
      FROM conceptpreferredname
      UNION ALL
      SELECT d.id, term
      from description d) cpn3,
     conceptpreferredname cpn4
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.id
  AND valueId = cpn4.conceptId;


-- Simple refset table.
EXECUTE drop_view('simplewithnames');
CREATE VIEW simplewithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName
FROM simple,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId;


-- No more complex map, ICD9CM maps deprecated
-- Complex Map refset table.
--EXECUTE drop_view('complexmapwithnames');
--CREATE VIEW complexmapwithnames AS
--SELECT id, effectiveTime, active,
--    moduleId, cpn1.preferredName moduleIdName,
--    refsetId, cpn2.preferredName refsetIdName,
--    referencedComponentId, cpn3.preferredName referencedComponentIdName,
--    mapGroup,
--    mapPriority,
--    mapRule,
--    mapAdvice,
--    mapTarget,
--    correlationId, cpn4.preferredName correlationIdName 
--FROM complexmap,
--    conceptpreferredname cpn1,
--    conceptpreferredname cpn2,
--    conceptpreferredname cpn3,
--    conceptpreferredname cpn4
--WHERE moduleId = cpn1.conceptId
--AND refsetId = cpn2.conceptId
--AND referencedComponentId = cpn3.conceptId
--AND correlationId = cpn4.conceptId;


-- Extended Map refset table.
EXECUTE drop_view('extendedmapwithnames');
CREATE VIEW extendedmapwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       mapGroup,
       mapPriority,
       mapRule,
       mapAdvice,
       mapTarget,
       correlationId,
       cpn4.preferredName correlationIdName,
       mapCategoryId,
       cpn5.preferredName mapCategoryIdName
FROM extendedmap,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4,
     conceptpreferredname cpn5
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId
  AND correlationId = cpn4.conceptId
  AND mapCategoryId = cpn5.conceptId;


-- Simple Map refset table.
EXECUTE drop_view('simplemapwithnames');
CREATE VIEW simplemapwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       mapTarget
FROM simplemap,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId;


-- Language refset table.
EXECUTE drop_view('languagewithnames');
CREATE VIEW languagewithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       acceptabilityId,
       cpn4.preferredName acceptabilityIdName
FROM language,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.descriptionId
  AND acceptabilityId = cpn4.conceptId;


-- Refset Descriptor refset table.
EXECUTE drop_view('refsetdescriptorwithnames');
CREATE VIEW refsetdescriptorwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       attributeDescription,
       attributeType,
       attributeOrder
FROM refsetdescriptor,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId;


-- Description Type refset table.
EXECUTE drop_view('descriptiontypewithnames');
CREATE VIEW descriptiontypewithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       descriptionFormat,
       descriptionLength
FROM descriptiontype,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId;


-- Module Dependency refset table.
EXECUTE drop_view('moduledependencywithnames');
CREATE VIEW moduledependencywithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       sourceEffectiveTime,
       targetEffectiveTime
FROM moduledependency,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId;

-- transitive closure table
-- NOTE: this assumes conceptpreferredname has already been created
--       via the standard RF2 load scripts
EXECUTE drop_view('transitiveclosurewithnames');
CREATE VIEW transitiveclosurewithnames AS
SELECT superTypeId,
       cpn1.preferredName superTypeName,
       subTypeId,
       cpn2.preferredName subTypeName,
       a.depth
FROM transitiveclosure a,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2
WHERE a.superTypeId = cpn1.conceptId
  AND a.subTypeId = cpn2.conceptId;

-- Clean up helper procedures.
DROP PROCEDURE drop_view;
