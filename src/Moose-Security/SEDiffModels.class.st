Class {
	#name : 'SEDiffModels',
	#superclass : 'Object',
	#instVars : [
		'diffModel',
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

{ #category : 'as yet unclassified' }
SEDiffModels >> display [

	| browser changedEntities |
	addedEntitesTagged value miPropagate.

	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff add]'.

	removedEntitesTagged value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff remove]'.

	assocAddedEntities value miPropagate.
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

{ #category : 'instance creation' }
SEDiffModels >> displayBaseModel: baseModel targetModel: targetModel [
	
	self baseModel:  baseModel targetModel: targetModel.
	self display
]

{ #category : 'as yet unclassified' }
SEDiffModels >> entitiesTagger [

	| resultDiff assocChanges |
	resultDiff := diffModel result.
	SEVulnerabilityTagger tagAllVulnerabilitiesOf: resultDiff associationChanges.

	resultDiff removals ifNotEmpty: [ :removedEntites |
			SEVulnerabilityTagger tagAllVulnerabilitiesOf: removedEntites anyOne entity mooseModel.
			removedEntitesTagged := removedEntites select: #isTagged ].

	resultDiff additions ifNotEmpty: [ :addedEntites |
			SEVulnerabilityTagger tagAllVulnerabilitiesOf: addedEntites anyOne entity mooseModel.
			addedEntitesTagged := addedEntites select: #isTagged ].

	assocChanges := resultDiff associationChanges allWithType: FamixAddChange.
	assocAddedEntities := assocChanges collect: [ :e | e entity ].
	assocAddedEntitiesTagged := assocAddedEntities collect: [ :e | e isTagged ]
]

{ #category : 'accessing' }
SEDiffModels >> removedEntitesTagged [

^ removedEntitesTagged
]
