"
isWildCard* servira dans le cas ou ne connait pas le nom de la methode ou ses parents (exemple : reflexion)
"
Class {
	#name : 'SEMethodInvoctationBlueprint',
	#superclass : 'Object',
	#instVars : [
		'modelMethodName',
		'methodParentTypes',
		'possibleParentTypes',
		'model'
	],
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'adding' }
SEMethodInvoctationBlueprint >> addMethodParentType: aString [

	methodParentTypes add: aString.
	possibleParentTypes := nil.
]

{ #category : 'adding' }
SEMethodInvoctationBlueprint >> addMethodParentTypes: aCollection [

	aCollection do: [:type | self addMethodParentType: type].
]

{ #category : 'actions' }
SEMethodInvoctationBlueprint >> calculatePossibleParentTypes [

	possibleParentTypes := Set new.

	(model allClassesAndInterfacesNamedIn: methodParentTypes)
		do: [ :parent | possibleParentTypes addAll: (self getAllPossibleTypesFor: parent)].
]

{ #category : 'actions' }
SEMethodInvoctationBlueprint >> calling: aSEMethodBlueprint [

	^ SEPatternBlueprint new
		  addMethodBlueprint: self;
		  addMethodBlueprint: aSEMethodBlueprint;
		  yourself
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> firstParentHavingTheMethodOfClass: aClass [

	(aClass hasAnImplemetedMethodNamed: modelMethodName) ifTrue: [ ^ aClass ].
	"doing this first to make sure the class is studied before interfaces (due to java prioritizing classes implementations of methods)"

	aClass superclass ifNotNil: [ :superclass |
		aClass = superclass ifTrue: [ ^ nil ].
		(self firstParentHavingTheMethodOfClass: superclass) ifNotNil: [ :res | ^ res ] ].
	aClass interfaceImplementations do: [ :interface |
		(self firstParentHavingTheMethodOfInterface: interface interface) ifNotNil: [ :res | ^ res ] ].
	^ nil
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> firstParentHavingTheMethodOfInterface: anInterface [

	(anInterface hasAnImplemetedMethodNamed: modelMethodName) ifTrue: [ ^ anInterface ].



	anInterface superclass ifNotNil: [ :superclass |
		anInterface = superclass ifTrue: [ ^ nil ].
		(self firstParentHavingTheMethodOfInterface: superclass) ifNotNil: [ :res | ^ res ] ].
	^ nil
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getAllPossibleTypesFor: anObject [

	^ (anObject isClass
		   ifTrue: [ self getAllPossibleTypesForClass: anObject ]
		   ifFalse: [ self getAllPossibleTypesForInterface: anObject ]) asSet
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getAllPossibleTypesForClass: aClass [

	| res |
	res := Set new.
	(self firstParentHavingTheMethodOfClass: aClass) ifNotNil: [ :a | res add: a ].

	aClass subInheritances do: [ :entity |
		aClass = entity subclass ifFalse: [ res addAll: (self getAllPossibleTypesForClass: entity subclass) ] ].
	^ res
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getAllPossibleTypesForInterface: anInterface [

	| res |
	res := Set new.
	(self firstParentHavingTheMethodOfInterface: anInterface) ifNotNil: [ :a | res add: a ].

	anInterface implementations do: [ :entity |
		anInterface = entity implementingClass ifFalse: [ res addAll: (self getAllPossibleTypesForClass: entity implementingClass) ] ].
	anInterface subInheritances do: [ :entity |
		anInterface = entity subclass ifFalse: [ res addAll: (self getAllPossibleTypesForInterface: entity subclass) ] ].

	^ res
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getFirstPatternMethods [

	| methodSet  |
	methodSet := model allMethodsNamed: self modelMethodName.
	
	^ methodSet select: [ :method | self isSearched: method parentType]
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getMethodsAfter: aMethod [

	| methodSet |
	methodSet := ((aMethod query outgoing objects dependenciesOfType: FamixTInvocation) select: [
		              :method | method name = self modelMethodName ]) asSet.
	^ self getNextStepOfPattern: methodSet
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getNextStepOfPattern: methodCollection [

	| res |
	res := Set new.

	methodCollection do: [ :method | res addAll: (self getAllPossibleTypesFor: method parentType) ].
	^ res
		  select: [ :entity | self isSearched: entity ]
		  thenCollect: [ :entity | entity methodNamed: modelMethodName ]
]

{ #category : 'initialization' }
SEMethodInvoctationBlueprint >> initialize [ 
	super initialize.
	methodParentTypes := OrderedCollection new.
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> isSearched: aClass [

	^ self methodParentTypes isEmpty or: [ self possibleParentTypes includes: aClass ]
]

{ #category : 'getter' }
SEMethodInvoctationBlueprint >> methodParentTypes [

	^ methodParentTypes
]

{ #category : 'getter' }
SEMethodInvoctationBlueprint >> model [
	^ model
]

{ #category : 'getter' }
SEMethodInvoctationBlueprint >> model: aModel [
	model := aModel
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
SEMethodInvoctationBlueprint >> possibleParentTypes [
	
	possibleParentTypes ifNil:[ self calculatePossibleParentTypes ].
	^ possibleParentTypes
]

{ #category : 'printing' }
SEMethodInvoctationBlueprint >> printBlueprintOn: aStream [

	aStream << modelMethodName << ' ['.
	methodParentTypes size = 1
		ifTrue: [ aStream print: methodParentTypes anyOne ]
		ifFalse: [ aStream print: methodParentTypes ].
	aStream << '] '
]
