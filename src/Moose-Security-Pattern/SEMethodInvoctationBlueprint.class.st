"
# Represent a blueprint for a method of a pattern blueprint.
- modelMethodName : name of the method in the model
- methodParentTypes : names of the parent types of the method (add nothing to make every class possibles)
"
Class {
	#name : 'SEMethodInvoctationBlueprint',
	#superclass : 'Object',
	#instVars : [
		'methodParentTypes',
		'possibleParentTypes',
		'model',
		'methodName'
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
	
	methodParentTypes addAll: aCollection.
	possibleParentTypes := nil.
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

	(aClass hasAnImplemetedMethodNamed: methodName) ifTrue: [ ^ aClass ].
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

	(anInterface hasAnImplemetedMethodNamed: methodName) ifTrue: [ ^ anInterface ].

	^ anInterface superclass ifNotNil: [ :superclass |
		  anInterface = superclass ifFalse: [ self firstParentHavingTheMethodOfInterface: superclass ] ]
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
	(self firstParentHavingTheMethodOfInterface: anInterface) ifNotNil: [ :a | res add: a].

	anInterface implementations do: [ :entity |
		anInterface = entity implementingClass ifFalse: [ res addAll: (self getAllPossibleTypesForClass: entity implementingClass) ] ].
	anInterface subInheritances do: [ :entity |
		anInterface = entity subclass ifFalse: [ res addAll: (self getAllPossibleTypesForInterface: entity subclass) ] ].

	^ res
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getFirstPatternMethods [

	^ self isParentTypeWildCard
		  ifTrue: [ model allMethodsNamed: methodName ]
		  ifFalse: [ self possibleParentTypes collect: [ :parent | parent methodNamed: methodName ] ]
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getMethodsAfter: aMethod [

	| methodSet |
	methodSet := ((aMethod query outgoing objects dependenciesOfType: FamixTInvocation) select: [
		              :method | method name = self methodName ]) asSet.
	^ self getNextStepOfPattern: methodSet
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> getNextStepOfPattern: methodCollection [

	| res |
	res := Set new.

	methodCollection do: [ :method | res addAll: (self getAllPossibleTypesFor: method parentType) ].

	^ self isParentTypeWildCard
		  ifTrue: [ res collect: [ :entity | entity methodNamed: methodName ] ]
		  ifFalse: [
				  res
					  select: [ :entity | self possibleParentTypes includes: entity ]
					  thenCollect: [ :entity | entity methodNamed: methodName ] ]
]

{ #category : 'initialization' }
SEMethodInvoctationBlueprint >> initialize [ 
	super initialize.
	methodParentTypes := OrderedCollection new.
]

{ #category : 'testing' }
SEMethodInvoctationBlueprint >> isParentTypeWildCard [
	^ methodParentTypes isEmpty
]

{ #category : 'getter' }
SEMethodInvoctationBlueprint >> methodName [

	^ methodName
]

{ #category : 'adding' }
SEMethodInvoctationBlueprint >> methodName: aString [

	methodName := aString
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
SEMethodInvoctationBlueprint >> possibleParentTypes [
	
	possibleParentTypes ifNil:[ self calculatePossibleParentTypes ].
	^ possibleParentTypes
]

{ #category : 'printing' }
SEMethodInvoctationBlueprint >> printBlueprintOn: aStream [

	aStream << methodName << ' ['.
	methodParentTypes size = 1
		ifTrue: [ aStream print: methodParentTypes anyOne ]
		ifFalse: [ aStream print: methodParentTypes ].
	aStream << '] '
]
