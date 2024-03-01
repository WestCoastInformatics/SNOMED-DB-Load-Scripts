-- Concept Preferred Name view, used by other views.
-- 900000000000013009 = Synonym description type
-- 900000000000548007 = Preferred
-- 900000000000509007 = United States of America English language reference set
DROP VIEW IF EXISTS conceptpreferredname;
CREATE VIEW conceptpreferredname AS
SELECT c.id conceptId, NULLIF(d.term, 'no active preferred synonym') preferredName, d.id descriptionId
FROM concept c
         LEFT OUTER JOIN description d
                         ON c.id = d.conceptId
                             AND d.active = TRUE
                             AND d.typeId = 900000000000013009
         LEFT OUTER JOIN language l
                         ON d.id = l.referencedComponentId
                             AND l.active = TRUE
                             AND l.acceptabilityId = 900000000000548007
                             AND l.refSetId = 900000000000509007
WHERE (l.acceptabilityId IS NOT null OR d.TERM IS null);


-- Concept table with names.
DROP VIEW IF EXISTS conceptwithnames;
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
DROP VIEW IF EXISTS descriptionwithnames;
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
DROP VIEW IF EXISTS identifierwithnames;
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
DROP VIEW IF EXISTS relationshipwithnames;
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

-- Relationship concrete values table.
DROP VIEW IF EXISTS relationshipconcretevalueswithnames;
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


-- OWL Expression table
DROP VIEW IF EXISTS owlexpressionwithnames;
CREATE VIEW owlexpressionwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       owlExpression
from owlexpression,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId;

-- Stated Relationship table.
DROP VIEW IF EXISTS statedrelationshipwithnames;
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
DROP VIEW IF EXISTS textdefinitionwithnames;
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
DROP VIEW IF EXISTS associationwithnames;
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
DROP VIEW IF EXISTS attributevaluewithnames;
CREATE VIEW attributevaluewithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName                                                            moduleIdName,
       refsetId,
       cpn2.preferredName                                                            refsetIdName,
       referencedComponentId,
       REPLACE(cpn3.preferredName, 'no active preferred synonym', 'no such concept') referencedComponentIdName,
       valueId,
       cpn4.preferredName                                                            valueIdName
FROM attributevalue
         LEFT OUTER JOIN conceptpreferredname cpn3 ON referencedComponentId = cpn3.conceptId
         INNER JOIN conceptpreferredname cpn1 ON moduleId = cpn1.conceptId
         INNER JOIN conceptpreferredname cpn2 ON refsetId = cpn2.conceptId
         INNER JOIN conceptpreferredname cpn4 ON valueId = cpn4.conceptId;


-- Simple refset table.
DROP VIEW IF EXISTS simplewithnames;
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
-- DROP VIEW IF EXISTS complexmapwithnames;
-- CREATE VIEW complexmapwithnames AS
-- SELECT id, effectiveTime, active,
--    moduleId, cpn1.preferredName moduleIdName,
--    refsetId, cpn2.preferredName refsetIdName,
--    referencedComponentId, cpn3.preferredName referencedComponentIdName,
--    mapGroup,
--    mapPriority,
--    mapRule,
--    mapAdvice,
--    mapTarget,
--    correlationId, cpn4.preferredName correlationIdName 
-- FROM complexmap,
--    conceptpreferredname cpn1,
--    conceptpreferredname cpn2,
--    conceptpreferredname cpn3,
--    conceptpreferredname cpn4
-- WHERE moduleId = cpn1.conceptId
-- AND refsetId = cpn2.conceptId
-- AND referencedComponentId = cpn3.conceptId
-- AND correlationId = cpn4.conceptId;


-- Extended Map refset table.
DROP VIEW IF EXISTS extendedmapwithnames;
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
DROP VIEW IF EXISTS simplemapwithnames;
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
DROP VIEW IF EXISTS languagewithnames;
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
DROP VIEW IF EXISTS refsetdescriptorwithnames;
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
DROP VIEW IF EXISTS descriptiontypewithnames;
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


-- MRCM Attribute Domain refset table.
DROP VIEW IF EXISTS mrcmattributedomainwithnames;
CREATE VIEW mrcmattributedomainwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       domainId,
       cpn4.preferredName domainIdName,
       grouped,
       attributeCardinality,
       attributeInGroupCardinality,
       ruleStrengthId,
       cpn4.preferredName ruleStrengthIdName,
       contentTypeId,
       cpn4.preferredName contentTypeIdName
FROM mrcmattributedomain,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4,
     conceptpreferredname cpn5,
     conceptpreferredname cpn6
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId
  AND domainId = cpn4.conceptId
  AND ruleStrengthId = cpn5.conceptId
  AND contentTypeId = cpn6.conceptId;


-- MRCM Module Scope refset table.
DROP VIEW IF EXISTS mrcmmodulescopewithnames;
CREATE VIEW mrcmmodulescopewithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       mrcmRuleRefsetId,
       cpn4.preferredName mrcmRuleRefsetIdName
FROM mrcmmodulescope,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId
  AND mrcmRuleRefsetId = cpn4.conceptId;


-- MRCM Attribute Range refset table.
DROP VIEW IF EXISTS mrcmattributerangewithnames;
CREATE VIEW mrcmattributerangewithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       rangeConstraint,
       attributeRule,
       ruleStrengthId,
       cpn4.preferredName ruleStrengthIdName,
       contentTypeId,
       cpn4.preferredName contentTypeIdName
FROM mrcmattributerange,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3,
     conceptpreferredname cpn4,
     conceptpreferredname cpn5
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId
  AND ruleStrengthId = cpn4.conceptId
  AND contentTypeId = cpn5.conceptId;


-- MRCM Domain refset table.
DROP VIEW IF EXISTS mrcmdomainwithnames;
CREATE VIEW mrcmdomainwithnames AS
SELECT id,
       effectiveTime,
       active,
       moduleId,
       cpn1.preferredName moduleIdName,
       refsetId,
       cpn2.preferredName refsetIdName,
       referencedComponentId,
       cpn3.preferredName referencedComponentIdName,
       domainConstraint,
       parentDomain,
       proximalPrimitiveConstraint,
       proximalPrimitiveRefinement,
       domainTemplateForPrecoordination,
       domainTemplateForPostcoordination,
       guideURL
FROM mrcmdomain,
     conceptpreferredname cpn1,
     conceptpreferredname cpn2,
     conceptpreferredname cpn3
WHERE moduleId = cpn1.conceptId
  AND refsetId = cpn2.conceptId
  AND referencedComponentId = cpn3.conceptId;


-- Module Dependency refset table.
DROP VIEW IF EXISTS moduledependencywithnames;
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

-- transitive closure table with names
-- NOTE: this assumes conceptpreferredname has already been created
--       via the standard RF2 load scripts
DROP VIEW IF EXISTS transitiveclosurewithnames;
CREATE VIEW transitiveclosurewithnames AS
SELECT superTypeId, cpn1.preferredName superTypeName,
       subTypeId, cpn2.preferredName subTypeName, a.depth
FROM transitiveclosure a,
    conceptpreferredname cpn1,
    conceptpreferredname cpn2
WHERE a.superTypeId = cpn1.conceptId
  AND a.subTypeId = cpn2.conceptId;
