Class {
	#name : 'SEDiffModels',
	#superclass : 'Object',
	#instVars : [
		'diffModel',
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

	| browser |
	addedEntitesTagged value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff add]'.

	removedEntitesTagged value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff remove]'.

	assocAddedEntitiesTagged value miPropagate.
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

	| resultDiff |
	resultDiff := diffModel result.

	resultDiff removals ifNotEmpty: [ :removedEntites |
			SEVulnerabilityTagger tagAllVulnerabilitiesOf: removedEntites anyOne entity mooseModel.
			removedEntitesTagged := removedEntites
				                        collect: #entity
				                        thenSelect: #isTagged ].

	resultDiff additions ifNotEmpty: [ :addedEntites |
			SEVulnerabilityTagger tagAllVulnerabilitiesOf: addedEntites anyOne entity mooseModel.
			addedEntitesTagged := addedEntites
				                      collect: #entity
				                      thenSelect: #isTagged ].

	(resultDiff associationChanges allWithType: FamixAddChange) ifNotEmpty: [ :assocChanges |
			SEVulnerabilityTagger tagAllVulnerabilitiesOf: (assocChanges collect: #entity).
			assocAddedEntitiesTagged := assocChanges
				                            collect: #entity
				                            thenSelect: #isTagged ]
]

{ #category : 'accessing' }
SEDiffModels >> removedEntitesTagged [

^ removedEntitesTagged
]
