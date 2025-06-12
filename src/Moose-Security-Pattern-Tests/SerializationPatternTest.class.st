Class {
	#name : 'SerializationPatternTest',
	#superclass : 'TestCase',
	#category : 'Moose-Security-Pattern-Tests',
	#package : 'Moose-Security-Pattern-Tests'
}

{ #category : 'running' }
SerializationPatternTest >> testExpectedCategory [

	| pattern model classA methodA |
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'ClassA'.
	methodA := model newMethodNamed: 'methodA'.
	classA addMethod: methodA.
	pattern := ((SEPatternBlueprint new addMethodBlueprint: (#methodA methodIn: { #ClassA })) applyOn: model) first.

	self assert: pattern category equals: SESerialisationCategory
]

{ #category : 'running' }
SerializationPatternTest >> testFindingSimpleInheritanceForClasses [

	| patterns model superclass supermethod subclass submethod |
	model := FamixJavaModel new name: 'model'.

	superclass := model newClassNamed: 'superclass'.
	supermethod := model newMethodNamed: 'method'.
	superclass addMethod: supermethod.

	subclass := model newClassNamed: 'subclass'.
	submethod := model newMethodNamed: 'method'.
	subclass addMethod: submethod.

	model newInheritance superclass: superclass; subclass: subclass.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #superclass . #subclass })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {supermethod . submethod } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingSimpleInheritanceForInterfaces [

	| patterns model superInterface supermethod subInterface submethod |
	
	model := FamixJavaModel new name: 'model'.

	superInterface := model newInterface.
	superInterface name: 'superInterface'.
	supermethod := model newMethodNamed: 'method'.
	superInterface addMethod: supermethod.

	subInterface := model newInterface.
	subInterface name: 'subInterface'.
	submethod := model newMethodNamed: 'method'.
	subInterface addMethod: submethod.

	model newInheritance superclass: superInterface; subclass: subInterface.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #superInterface . #subInterface })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {supermethod . submethod } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingSimpleInheritanceForParametricClasses1 [

	| patterns model superclass supermethod subclass submethod |
	model := FamixJavaModel new name: 'model'.
	
	self flag: #todo.

	superclass := model newParametricClass.
	superclass name: 'superclass'.
	supermethod := model newMethodNamed: 'method'.
	superclass addMethod: supermethod.

	subclass := model newClassNamed: 'subclass'.
	submethod := model newMethodNamed: 'method'.
	subclass addMethod: submethod.

	model newInheritance superclass: superclass; subclass: subclass.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #superclass . #subclass })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {supermethod . submethod } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingSimpleInheritanceForParametricClasses2 [

	| patterns model superclass supermethod subclass submethod |
	model := FamixJavaModel new name: 'model'.
	
	self flag: #todo.

	superclass := model newClassNamed: 'superclass'.
	supermethod := model newMethodNamed: 'method'.
	superclass addMethod: supermethod.


	subclass := model newParametricClass.
	subclass name: 'subclass'.
	submethod := model newMethodNamed: 'method'.
	subclass addMethod: submethod.

	model newInheritance superclass: superclass; subclass: subclass.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #superclass . #subclass })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {supermethod . submethod } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingSimpleMethodCalling [

	| expected pattern model classA methodA classB methodB |
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'ClassA'.
	methodA := model newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model newClassNamed: 'ClassB'.
	methodB := model newMethodNamed: 'methodB'.
	classB addMethod: methodB.

	model newInvocation
		sender: methodA;
		addCandidate: methodB.

	pattern := (((#methodA methodIn: { #ClassA }) calling: (#methodB methodIn: { #ClassB })) applyOn: model) first.

	expected := SEPattern new
		            category: SESerialisationCategory;
		            addPatternEntity: methodA;
		            addPatternEntity: methodB.

	self assertCollection: pattern patternEntities equals: expected patternEntities
]

{ #category : 'running' }
SerializationPatternTest >> testFindingSimplePatternWithoutClassPrecision [

	| expected pattern model classA methodA classB methodB |
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'ClassA'.
	methodA := model newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model newClassNamed: 'ClassB'.
	methodB := model newMethodNamed: 'methodB'.
	classB addMethod: methodB.

	model newInvocation
		sender: methodA;
		addCandidate: methodB.

	pattern := (((#methodA methodIn: {  }) calling: (#methodB methodIn: {  })) applyOn: model) first.

	expected := SEPattern new
		            addPatternEntity: methodA;
		            addPatternEntity: methodB.

	self flag: #todo. "ce test est-il bon ou faut-il une egalite sur SEPattern"
	self assert: pattern patternEntities equals: expected patternEntities
]
