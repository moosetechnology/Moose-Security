Class {
	#name : 'SEDiffModelsBuilder',
	#superclass : 'Object',
	#category : 'Moose-Security',
	#package : 'Moose-Security'
}

{ #category : 'accessing - name' }
SEDiffModelsBuilder >> captureTaggedEntitiesMooseNamesOf: aModel [

	| taggedElementOfFirstModel taggedEntitiesNameFirstModel |
	taggedElementOfFirstModel := self collectTaggedElementsOf: aModel.
	taggedEntitiesNameFirstModel := taggedElementOfFirstModel collect:
		                                #mooseName.

	^ taggedEntitiesNameFirstModel
]

{ #category : 'private-cleaning' }
SEDiffModelsBuilder >> cleanBeforeDiffOf: aFirstModel and: aSecondModel [

	{
		aFirstModel.
		aSecondModel } do: [ :model |
		SEVulnerabilityTagger removeAllGeneratedTagsOf: model ]
]

{ #category : 'tagging' }
SEDiffModelsBuilder >> collectTaggedElementsOf: aModel [

	| taggedEntitiesOfAModel |
	taggedEntitiesOfAModel := aModel select: [ :e | e isTagged ].

	^ taggedEntitiesOfAModel
]

{ #category : 'as yet unclassified' }
SEDiffModelsBuilder >> generateTheDiffBetween: aFirstModel and: aSecondModel [
	"First step: tag entities of the two models"

	| taggedEntitiesNameFirstModel taggedEntitiesNameSecondModel taggedElementOfSecondModel taggedDiffM2MinusM1 taggedElementOfFirstModel tagSecondModel |
	SEVulnerabilityTagger tagAllVulnerabilitiesOf: aFirstModel.
	taggedElementOfFirstModel := aFirstModel entities select: [ :e |
		                             e isTagged ].
	SEVulnerabilityTagger tagAndVisualizeTags: aSecondModel.
	taggedElementOfSecondModel := aSecondModel entities select: [ :e |
		                              e isTagged ].

	"Second step: capture the Moose names of the tagged entities in the two models"
	taggedEntitiesNameFirstModel := self
		                                captureTaggedEntitiesMooseNamesOf:
		                                aFirstModel.
	taggedEntitiesNameSecondModel := self
		                                 captureTaggedEntitiesMooseNamesOf:
		                                 aSecondModel.

	"Third step: calculate the diff between the taged models : aSecondModel tags - aFirstModel tags"
	taggedDiffM2MinusM1 := taggedElementOfSecondModel reject: [ :e |
		                       taggedEntitiesNameFirstModel includes:
			                       e mooseName ].
	"Fourth step: create the tag for the diff in the architecturalMap of aSecondModel"
	aSecondModel allTags
		detect: [ :tag | tag name = 'Model2MinusModel1' ]
		ifFound: [ :tag | tag remove ].

	aSecondModel createTagNamed: 'Model2MinusModel1'.
	tagSecondModel := aSecondModel allTags detect: [ :t |
		                  t name = 'Model2MinusModel1' ].

	taggedDiffM2MinusM1 do: [ :e | e tagWith: tagSecondModel ].
	SEVulnerabilityTagger tagAndVisualizeTags: aSecondModel
]

{ #category : 'tagging' }
SEDiffModelsBuilder >> generatesTagsFor: aFirstModel and: aSecondModel [

	{
		aFirstModel.
		aSecondModel } do: [ :model |
		SEVulnerabilityTagger tagAndVisualizeTags: model ]
]

{ #category : 'comparing' }
SEDiffModelsBuilder >> old_calculateTheDiffBetween: aFirstModel and: aSecondModel [
	"This method supposes that a step of cleaning of the existing tags is performed for the two models in parameter"

	| taggedDiffM1M2 taggedElementOfFirstModel taggedElementOfSecondModel taggedEntitiesNameFirstModel taggedEntitiesNameSecondModel tagSModel |
	self generatesTagsFor: aFirstModel and: aSecondModel.
	taggedElementOfFirstModel := self collectTaggedElementsOf:
		                             aFirstModel.
	taggedElementOfSecondModel := self collectTaggedElementsOf:
		                              aSecondModel.

	taggedEntitiesNameFirstModel := taggedElementOfFirstModel collect:
		                                #mooseName.
	taggedEntitiesNameSecondModel := taggedElementOfSecondModel collect:
		                                 #mooseName.

	taggedDiffM1M2 := taggedElementOfSecondModel reject: [ :e |
		                  taggedEntitiesNameFirstModel includes: e mooseName ].
	aSecondModel createTagNamed: 'Model2MinusModel1'.
	tagSModel := aSecondModel allTags detect: [ :t |
		             t name = 'Model2MinusModel1' ].
	taggedDiffM1M2 do: [ :e | e tagWith: tagSModel ]
]
