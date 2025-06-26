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

	self flag: #todo. "allUsing: FamixTWithInheritances gives FamixJavaAnnotationType, maybe it's not usefull and should be filtrated.
	could be done by writing a method replacing (methodParentTypes includes: entity name) directly in entity and overriding it in FamixJavaAnnotationType"

	possibleParentTypes := (((model allUsing: FamixTWithInheritances) select: [ :entity |
		                         methodParentTypes includes: entity name ]) flatCollect: [ :parent |
		                        parent allRelatedTypeHavingTheMethodNamed: methodName ]) asSet
]

{ #category : 'actions' }
SEMethodInvoctationBlueprint >> calling: aSEMethodBlueprint [

	^ SEPatternBlueprint new
		  addMethodBlueprint: self;
		  addMethodBlueprint: aSEMethodBlueprint;
		  yourself
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

{ #category : 'adding' }
SEMethodInvoctationBlueprint >> methodName: aString [

	methodName := aString
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

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> selectMethodsAsStartingOfPattern [

	^ self isParentTypeWildCard
		  ifTrue: [ model allMethods select: [ :method | method name = methodName ] ]
		  ifFalse: [ self possibleParentTypes collect: [ :entity | entity methodNamed: methodName ] ]
]

{ #category : 'detection' }
SEMethodInvoctationBlueprint >> selectOutgoingInvocationOf: aMethod [

	| res |
	res := Set new.

	(aMethod query outgoing objects dependenciesOfType: FamixTInvocation)
		select: [ :method | method name = methodName ]
		thenDo: [ :method | res addAll: (method parentType allRelatedTypeHavingTheMethodNamed: methodName) ].

	^ self isParentTypeWildCard
		  ifTrue: [ res collect: [ :entity | entity methodNamed: methodName ] ]
		  ifFalse: [
				  res
					  select: [ :entity | self possibleParentTypes includes: entity ]
					  thenCollect: [ :entity | entity methodNamed: methodName ] ]
]
