"
I am a class used to run the diff between two versions of a model and display some maps on it. 

I'll open 3 maps:
- One with the list of new entities that are vigilance points
- One with the list of removed vigilance points
- One with the list of new dependencies to vigilance points

You can open me like this:

```st
	SEDiffModels displayResultsBetween: commonsCollections30 and: commonsCollections31 
```
"
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

{ #category : 'instance creation' }
SEDiffModels class >> displayResultsBetween: baseModel and: targetModel [

	^ self new displayBaseModel: baseModel targetModel: targetModel
]

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

{ #category : 'api' }
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

{ #category : 'accessing' }
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
