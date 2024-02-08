# Check Files
With a new download of SNOMED international edition or US edition, check that the file list still matches what we are loading.

## Look for extra files (this should return zero rows)
```
find . -name "*txt" | grep -v Refset_Association | grep -v Refset_AttributeValue | grep -v Refset_SimpleSn |\
  grep -v Refset_Language | grep -v Refset_ExtendedMap | grep -v Refset_SimpleMap |\
  grep -v Refset_RefsetDescriptor | grep -v Refset_DescriptionType |\
  grep -v Refset_MRCMAttributeDomain | grep -v Refset_MRCMModuleScope |\
  grep -v Refset_MRCMAttributeRange | grep -v Refset_ModuleDependency |\
  grep -v Refset_MRCMDomain | grep -v sct2_Concept | grep -v sct2_Description |\
  grep -v sct2_Identifier | grep -v sct2_Relationship_ | grep -v Refset_OWLExpression |\
  grep -v sct2_StatedRelationship | grep -v sct2_TextDefinition |\
  grep -v sct2_RelationshipConcreteValues |  wc -l
```

## Look that all files are there (this should equal 21)
```
find . -name "*txt" |\
 perl -ne 'print if /Refset_Association|AttributeValue|Refset_SimpleSn/; \
   print if /Refset_Language|Refset_ExtendedMap|Refset_SimpleMap/; \
   print if /Refset_RefsetDescriptor|Refset_DescriptionType/; \
   print if /Refset_MRCMAttributeDomain|Refset_MRCMModuleScope/; \
   print if /Refset_MRCMAttributeRange|Refset_ModuleDependency/; \
   print if /Refset_MRCMDomain|sct2_Concept|sct2_Description/; \
   print if /sct2_Identifier|sct2_Relationship(ConcreteValues)?_|Refset_OWLExpression/; \
   print if /sct2_StatedRelationship|sct2_TextDefinition/' | wc -l
```