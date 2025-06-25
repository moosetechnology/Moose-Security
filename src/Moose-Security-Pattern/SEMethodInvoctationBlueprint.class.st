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

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> allPossibleTypesFor: anObject [

	^ anObject isClass
		  ifTrue: [ self allPossibleTypesForClass: anObject ]
		  ifFalse: [ self allPossibleTypesForInterface: anObject ]
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> allPossibleTypesForClass: aClass [

	| res |
	res := Set new.
	(self firstParentHavingTheMethodOfClass: aClass) ifNotNil: [ :a | res add: a. ].

	aClass subInheritances do: [ :inheritance |
		aClass = inheritance subclass ifFalse: [ res addAll: (self allPossibleTypesForClass: inheritance subclass) ] ].
	^ res
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> allPossibleTypesForInterface: anInterface [

	| res |
	res := Set new.
	(self firstParentHavingTheMethodOfInterface: anInterface) ifNotNil: [ :a | res add: a].

	anInterface implementations do: [ :implementation |
		anInterface = implementation implementingClass ifFalse: [ res addAll: (self allPossibleTypesForClass: implementation implementingClass) ] ].
	anInterface subInheritances do: [ :inheritance |
		anInterface = inheritance subclass ifFalse: [ res addAll: (self allPossibleTypesForInterface: inheritance subclass) ] ].

	^ res
]

{ #category : 'actions' }
SEMethodInvoctationBlueprint >> calculatePossibleParentTypes [

	possibleParentTypes := (model allClassesAndInterfacesNamedIn: methodParentTypes) asSet flatCollect: [ :parent |
		                       self allPossibleTypesFor: parent ]
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
	aClass interfaceImplementations do: [ :implementation |
		(self firstParentHavingTheMethodOfInterface: implementation interface) ifNotNil: [ :res | ^ res ] ].
	^ nil
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> firstParentHavingTheMethodOfInterface: anInterface [

	(anInterface hasAnImplemetedMethodNamed: methodName) ifTrue: [ ^ anInterface ].

	^ anInterface superclass ifNotNil: [ :superclass |
		  anInterface = superclass ifFalse: [ self firstParentHavingTheMethodOfInterface: superclass ] ]
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> firstPatternMethods [

	^ self isParentTypeWildCard
		  ifTrue: [ model allMethodsNamed: methodName ]
		  ifFalse: [ self possibleParentTypes collect: [ :entity | entity methodNamed: methodName ] ]
]

{ #category : 'initialization' }
SEMethodInvoctationBlueprint >> initialize [ 
	super initialize.
	methodParentTypes := OrderedCollection new.
]

{ #category : 'getter' }
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

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> methodsAfter: aMethod [

	| res |
	res := Set new.

	(aMethod query outgoing objects dependenciesOfType: FamixTInvocation)
		select: [ :method | method name = self methodName ]
		thenDo: [ :method | res addAll: (self allPossibleTypesFor: method parentType) ].

	^ self isParentTypeWildCard
		  ifTrue: [ res collect: [ :entity | entity methodNamed: methodName ] ]
		  ifFalse: [
				  res
					  select: [ :entity | self possibleParentTypes includes: entity ]
					  thenCollect: [ :entity | entity methodNamed: methodName ] ]
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
