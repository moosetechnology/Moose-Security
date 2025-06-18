Class {
	#name : 'SEPatternBlueprint',
	#superclass : 'Object',
	#instVars : [
		'methodBlueprints',
		'model'
	],
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'adding' }
SEPatternBlueprint >> addMethodBlueprint: aMethodBlueprint [

	methodBlueprints add: aMethodBlueprint.
]

{ #category : 'detection' }
SEPatternBlueprint >> applyOn: aModel [

	| resultPatterns |
	model := aModel.
	methodBlueprints := methodBlueprints collect: [ :blueprint | blueprint model: aModel ].
	resultPatterns := methodBlueprints first getFirstPatternMethods collect: [ :a |
		                  { a } asOrderedCollection ].

	methodBlueprints allButFirst do: [ :methodBlueprint |
			resultPatterns := resultPatterns
				                  collect: [ :collection |
						                  collection
							                  add: (methodBlueprint getMethodsAfter: collection last);
							                  yourself ]
				                  thenReject: [ :col | col last isEmpty ].
			resultPatterns := resultPatterns flatCollect: [ :col |
				                  col last collect: [ :next | col allButLast copyWith: next ] ] ].

	^ resultPatterns collect: [ :collected |
			  SEPattern new
				  category: SESerialisationCategory;
				  addPatternEntities: collected ]
]

{ #category : 'actions' }
SEPatternBlueprint >> calling: aSEMethodBlueprint [

	^ self
		  addMethodBlueprint: aSEMethodBlueprint;
		  yourself
]

{ #category : 'initialization' }
SEPatternBlueprint >> initialize [ 
	super initialize.
	methodBlueprints := OrderedCollection new.
]
