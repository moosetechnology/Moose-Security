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
	resultPatterns := self getFirstPatternMethods collect: [ :a | { a } asOrderedCollection ].

	self methodBlueprints allButFirst do: [ :methodBlueprint |
		resultPatterns := resultPatterns
			                  collect: [ :collection |
				                  collection
					                  add: (methodBlueprint getMethodsAfter: collection last);
					                  yourself ] 
			                  thenReject: [ :col | col last isEmpty ].
		resultPatterns := resultPatterns flatCollect: [ :col | col last collect: [ :next | col allButLast copyWith: next ] ] ].

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

{ #category : 'detection' }
SEPatternBlueprint >> getFirstPatternMethods [

	| methodSet methodBlueprint |
	methodBlueprint := self methodBlueprints first.
	methodSet := model allMethodsNamed: methodBlueprint modelMethodName.
	self flag: #todo. "adpat this method to take into account that maybe the method have no precised class"
	self flag:#todo. "adapter le code 
	modifier partout methodsTypes en possibleTypes (a implementer)
	possibleTypes :
		si interface : recherche recursivement dans les implemeteur et dans les interfaces qui herite + les classes qui l'utilisent et leurs sous classes de maniere recursives
		si classe : recherche dans les sous classes recursives
	"
	^ methodSet select: [ :method | methodBlueprint methodParentTypes includes: method parentType name ]
]

{ #category : 'initialization' }
SEPatternBlueprint >> initialize [ 
	super initialize.
	methodBlueprints := OrderedCollection new.
]

{ #category : 'adding' }
SEPatternBlueprint >> methodBlueprints [

	^ methodBlueprints
]
