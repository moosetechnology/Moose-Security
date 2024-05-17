Class {
	#name : #SEDiffModels,
	#superclass : #Object,
	#instVars : [
		'addedtag',
		'removedTag',
		'modifiedTag',
		'diffModel',
		'removedEntites',
		'addedEntites'
	],
	#category : #'Moose-Security'
}

{ #category : #'instance creation' }
SEDiffModels >> baseModel: baseModel targetModel: targetModel [
	diffModel := FXDiff
		             runOnBaseModel: baseModel
		             targetModel: targetModel.


	self tagsCreation.
	self entitiesTagger.
	self displayDiff
]

{ #category : #accessing }
SEDiffModels >> diffModel [

^diffModel 
]

{ #category : #accessing }
SEDiffModels >> diffModel: anObject [

	diffModel := anObject
]

{ #category : #'as yet unclassified' }
SEDiffModels >> displayDiff [

	| entitiesDiff resultDiff browser |
	resultDiff := diffModel result.

	"entitiesDiff := resultDiff collect: [ :e | e entity ].
	diffModel baseModel value miPropagate."


	addedEntites value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff add]'.

	removedEntites value miPropagate.

	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff remove]'
]

{ #category : #'as yet unclassified' }
SEDiffModels >> entitiesTagger [

	| resultDiff "removedEntites addedEntites" |
	resultDiff := diffModel result.
	SEVulnerabilityTagger tagAndVisualizeTags:  diffModel baseModel.

	removedEntites := resultDiff removalChanges collect: [ :e | e entity ].
	removedEntites do: [ :e | e tagWith: removedTag ].


	addedEntites := resultDiff addChanges collect: [ :e | e entity ].
	addedEntites do: [ :e | e tagWith: addedtag ]
]

{ #category : #'as yet unclassified' }
SEDiffModels >> propagate: ablock [ 
	
	| browser|
	
	ablock value miPropagate.

	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title:
		browser window title , ' [Test]'
]

{ #category : #'as yet unclassified' }
SEDiffModels >> tagsCreation [

	addedtag := (diffModel baseModel tagNamed: 'added') color: Color blue.

	removedTag := (diffModel baseModel tagNamed: 'removed') color:
		              Color red.
"
	modifiedTag := (diffModel baseModel tagNamed: 'modified') color:
		               Color yellow"
]
