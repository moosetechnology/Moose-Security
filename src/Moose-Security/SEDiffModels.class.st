Class {
	#name : 'SEDiffModels',
	#superclass : 'Object',
	#instVars : [
		'addedtag',
		'removedTag',
		'modifiedTag',
		'diffModel',
		'removedEntites',
		'addedEntites',
		'assocAddedEntities',
		'removedEntitesTagged',
		'addedEntitesTagged',
		'assocAddedEntitiesTagged'
	],
	#category : 'Moose-Security',
	#package : 'Moose-Security'
}

{ #category : 'accessing' }
SEDiffModels >> addedEntitesTagged [

^ addedEntitesTagged
]

{ #category : 'instance creation' }
SEDiffModels >> baseModel: baseModel targetModel: targetModel [
	diffModel := FXDiff
		             runOnBaseModel: baseModel
		             targetModel: targetModel.

	self entitiesTagger.
]

{ #category : 'accessing' }
SEDiffModels >> diffModel [

	^ diffModel
]

{ #category : 'accessing' }
SEDiffModels >> diffModel: anObject [

	diffModel := anObject
]

{ #category : 'instance creation' }
SEDiffModels >> display [
	self displayDiff: diffModel result
]

{ #category : 'instance creation' }
SEDiffModels >> displayBaseModel: baseModel targetModel: targetModel [
	
	self baseModel:  baseModel targetModel: targetModel.
	self display
]

{ #category : 'as yet unclassified' }
SEDiffModels >> displayDiff: resultDiff [

	| browser changedEntities |
	"addedEntitesTagged value miPropagate.
    
    browser := MiArchitecturalMapBrowser open.
    browser beFrozen .
    browser window title: browser window title , ' [ diff add]'.

    removedEntitesTagged value miPropagate.
    browser := MiArchitecturalMapBrowser open.
    browser beFrozen.
    browser window title: browser window title , ' [ diff remove]'.""    assocAddedEntities value miPropagate.""1halt."
	changedEntities := assocAddedEntities flatCollect: [ :ass | ass source atScope: FamixTType ].
	changedEntities addAll: (assocAddedEntities flatCollect: [ :ass |
				 ass target isCollection
					 ifTrue: [ ass target flatCollect: [ :c | c atScope: FamixTType ] ]
					 ifFalse: [ ass target atScope: FamixTType ] ]).
	(changedEntities reject: #isPrimitiveType) asSet value miPropagate.

	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff assosChanges]'
]

{ #category : 'as yet unclassified' }
SEDiffModels >> entitiesTagger [

	| resultDiff assocChanges |
	resultDiff := diffModel result.
	SEVulnerabilityTagger tagAllVulnerabilitiesOf: resultDiff associationChanges.

	removedEntites := resultDiff removals collect: [ :e | e entity ].
	removedEntites ifNotEmpty: [
			SEVulnerabilityTagger tagAllVulnerabilitiesOf: removedEntites anyOne mooseModel.
			removedEntitesTagged := removedEntites select: [ :e | e isTagged ] ].

	addedEntites := resultDiff additions collect: [ :e | e entity ].
	addedEntites ifEmpty: [ ^ self ].
	SEVulnerabilityTagger tagAllVulnerabilitiesOf: addedEntites anyOne mooseModel.
	addedEntitesTagged := addedEntites select: [ :e | e isTagged ].

	assocChanges := resultDiff associationChanges allWithType: FamixAddChange.
	assocAddedEntities := assocChanges collect: [ :e | e entity ]
	"assocAddedEntitiesTagged := removedEntites collect: [ :e | e isTagged  ]."
]

{ #category : 'accessing' }
SEDiffModels >> removedEntitesTagged [

^ removedEntitesTagged
]
