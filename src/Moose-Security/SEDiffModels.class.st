Class {
	#name : #SEDiffModels,
	#superclass : #Object,
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
	#category : #'Moose-Security'
}

{ #category : #'instance creation' }
SEDiffModels >> baseModel: baseModel targetModel: targetModel [
	diffModel := FXDiff
		             runOnBaseModel: baseModel
		             targetModel: targetModel.


"	self tagsCreation."
	self entitiesTagger.
	self displayDiff: diffModel result
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
SEDiffModels >> displayDiff: resultDiff [

	| entitiesDiff  test browser |
	"resultDiff = diffModel result."
	
	"entitiesDiff := resultDiff select: [ :e | e entity isTagged ].
	test:= entitiesDiff collect: [:e | e entity].
	test value miPropagate."
	
	"addedEntitesTagged value miPropagate."
	
	addedEntites value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen .
	browser window title: browser window title , ' [ diff add]'.

"	removedEntitesTagged value miPropagate."
	removedEntites value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff remove]'.


"	assocAddedEntitiesTagged value miPropagate."
	
	assocAddedEntities value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff assosChanges]'
]

{ #category : #'as yet unclassified' }
SEDiffModels >> entitiesTagger [

	| resultDiff "removedEntites addedEntites"   "assocAdded" assocChanges |
	resultDiff := diffModel result.

	"SESerialisationTagger assocChanges: resultDiff  ."
	
	"SEVulnerabilityTagger tagAllVulnerabilitiesOf: diffModel targetModel."
	
	removedEntites := resultDiff removalChanges collect: [ :e | e entity ].
	removedEntitesTagged := removedEntites collect: [ :e | e isTagged  ].
	
	addedEntites := resultDiff addChanges collect: [ :e | e entity ].
	addedEntitesTagged := removedEntites collect: [ :e | e isTagged  ].
	
	
	assocChanges := resultDiff assocChanges allWithType: FamixAddChange.
	assocAddedEntities := assocChanges  collect: [ :e | e entity ].
	"assocAddedEntitiesTagged := removedEntites collect: [ :e | e isTagged  ]."
	
	"SESerialisationTagger assocChanges: resultDiff assocChanges ."

	"SESerialisationTagger tagAllVulnerabilitiesOf: addedEntites ."
	
	"addedtag := (addedEntites  tagNamed: 'added') color: 
						 Color blue."
	
	
	

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

	"addedtag := (diffModel baseModel tagNamed: 'added') color: Color blue.

	removedTag := (diffModel baseModel tagNamed: 'removed') color:
		              Color red.
""
	modifiedTag := (diffModel baseModel tagNamed: 'modified') color:
		               Color yellow"
]
