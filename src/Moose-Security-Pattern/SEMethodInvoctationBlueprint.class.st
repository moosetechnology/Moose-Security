"
isWildCard* servira dans le cas ou ne connait pas le nom de la methode ou ses parents (exemple : reflexion)
"
Class {
	#name : 'SEMethodInvoctationBlueprint',
	#superclass : 'Object',
	#instVars : [
		'modelMethodName',
		'methodParentTypes',
		'model'
	],
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'adding' }
SEMethodInvoctationBlueprint >> addMethodParentType: aString [

	methodParentTypes add: aString
]

{ #category : 'adding' }
SEMethodInvoctationBlueprint >> addMethodParentTypes: aCollection [

	aCollection do: [:type | self addMethodParentType: type].
]

{ #category : 'actions' }
SEMethodInvoctationBlueprint >> calling: aSEMethodBlueprint [

	^ SEPatternBlueprint new
		  addMethodBlueprint: self;
		  addMethodBlueprint: aSEMethodBlueprint;
		  yourself
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getAllSpecializedMethodsForClass: aClass [

	| res |
	res := Set new.
	(self isSearched: aClass) ifTrue: [ res add: (aClass methodNamed: modelMethodName) ].

	aClass subInheritances do: [ :entity | res addAll: (self getAllSpecializedMethodsForClass: entity subclass) ].
	^ res
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getAllSpecializedMethodsForInterface: anInterface [

	| res implementingClass subclass|
	res := Set new.
	(self isSearched: anInterface) ifTrue: [ res add: (anInterface methodNamed: modelMethodName) ].
	
	(anInterface implementations ) do: [ :entity |
		implementingClass := entity implementingClass.
		implementingClass isInterface ifTrue: [ res addAll: (self getAllSpecializedMethodsForInterface: implementingClass) ].
		implementingClass isClass ifTrue: [ res addAll: (self getAllSpecializedMethodsForClass: implementingClass) ] ].
	
	(anInterface subInheritances ) do: [ :entity |
		subclass := entity subclass.
		subclass isInterface ifTrue: [ res addAll: (self getAllSpecializedMethodsForInterface: subclass) ].
		subclass isClass ifTrue: [ res addAll: (self getAllSpecializedMethodsForClass: subclass) ] ].
	^
	 res
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getMethodsAfter: aMethod [

	| methodSet |
	
	methodSet := ((aMethod query outgoing objects dependenciesOfType: FamixTInvocation) select: [ :method | method name = self modelMethodName ])
		             asSet.
	^ self getNextStepOfPattern: methodSet
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getNextStepOfPattern: methodCollection [

	| res parent |
	res := Set new.
	
	methodCollection do: [ :method |
		parent := method parentType.
		parent isInterface ifTrue: [ res addAll: (self getAllSpecializedMethodsForInterface: parent) ].
		parent isClass ifTrue: [ res addAll: (self getAllSpecializedMethodsForClass: parent) ].
		(self methodParentTypes includes: parent name) ifTrue: [ res add: method ] ].
	^ res
]

{ #category : 'initialization' }
SEMethodInvoctationBlueprint >> initialize [ 
	super initialize.
	methodParentTypes := OrderedCollection new.
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> isSearched: aClass [

	^ self methodParentTypes isEmpty or: [ self methodParentTypes includes: aClass name ]
]

{ #category : 'getter' }
SEMethodInvoctationBlueprint >> methodParentTypes [

	^ methodParentTypes
]

{ #category : 'getter' }
SEMethodInvoctationBlueprint >> modelMethodName [

	^ modelMethodName
]

{ #category : 'adding' }
SEMethodInvoctationBlueprint >> modelMethodName: aString [

	modelMethodName := aString
]

{ #category : 'getter' }
SEMethodInvoctationBlueprint >> possibleClassesOn: aModel [

	"
		si interface : recherche recursivement dans les implemeteur et dans les interfaces qui herite + les classes qui l'utilisent et leurs sous classes de maniere recursives
		si classe : recherche dans les sous classes recursives"
	
	self flag: #todo. "research all possibles types for every add, and add it to possibleParentTypes"
]
