Class {
	#name : #SEDiffModels,
	#superclass : #Object,
	#instVars : [
		'addedtag',
		'removedTag',
		'modifiedTag',
		'diffModel'
	],
	#category : #'Moose-Security'
}

{ #category : #'instance creation' }
SEDiffModels >> baseModel: baseModel targetModel: targetModel [

	diffModel :=  FXDiff runOnBaseModel: baseModel targetModel: targetModel.
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
	entitiesDiff := resultDiff collect: [ :e | e entity ].
	entitiesDiff value miPropagate.

	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ diff ]'
]

{ #category : #'as yet unclassified' }
SEDiffModels >> entitiesTagger [

	| resultDiff removedEntites added addedEntites modifiedEntites |
	resultDiff := diffModel result.

	removedEntites := resultDiff removalChanges collect: [ :e | e entity ].
	removedEntites do: [ :e | e tagWith: removedTag ].

	added := resultDiff select: [ :e | e isAddition ].
	addedEntites := added collect: [ :e | e entity ].
	addedEntites do: [ :e | e tagWith: addedtag ].

	modifiedEntites := resultDiff bodyChanges collect: [ :e | e entity ].

	modifiedEntites do: [ :e | e tagWith: modifiedTag ]
]

{ #category : #'as yet unclassified' }
SEDiffModels >> tagsCreation [

	addedtag := (diffModel baseModel tagNamed: 'added') color:
		            (Color
			             r: 0.07038123167155426
			             g: 1.99022482893451
			             b: 0.30
			             alpha: 1.0).
	removedTag := (diffModel baseModel tagNamed: 'removed') color:
		              (Color
			               r: 1.997038123167155426
			               g: 0.00
			               b: 0.0
			               alpha: 1.0).
	modifiedTag := (diffModel baseModel tagNamed: 'modified')
		               color: (Color
				                r: 2.9938123167155426
				                g: 0.90
				                b: 0.0
				                alpha: 1.0)
]
