Class {
	#name : 'SerializationPatternTest',
	#superclass : 'TestCase',
	#category : 'Moose-Security-Pattern-Tests',
	#package : 'Moose-Security-Pattern-Tests'
}

{ #category : 'running' }
SerializationPatternTest >> testComplexResearch1 [

	| patterns model classA classB classC interfaceA interfaceB method |
	
	self flag:#todo. "rename this method"
	
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	classB := model newClassNamed: 'classB'.
	classC := model newClassNamed: 'classC'.
	
	interfaceA := model newInterface. interfaceA name: 'interfaceA'.
	interfaceB := model newInterface. interfaceB name: 'interfaceB'.
	
	model newInheritance superclass: classA; subclass: classB.
	model newInheritance superclass: classB; subclass: classC.
	model newImplementation interface: interfaceA; implementingClass: classB.
	model newImplementation interface: interfaceB; implementingClass: classC.
	
	method := model newMethodNamed: 'method'.
	interfaceB addMethod: method.
	
	

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #interfaceA })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns asSet hasSameElements: {method } 
]

{ #category : 'running' }
SerializationPatternTest >> testComplexResearch2 [

	| patterns model classA classB classC interfaceA interfaceB method1 method2 |
	
	self flag:#todo. "rename this method"
	
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	classB := model newClassNamed: 'classB'.
	classC := model newClassNamed: 'classC'.
	
	interfaceA := model newInterface. interfaceA name: 'interfaceA'.
	interfaceB := model newInterface. interfaceB name: 'interfaceB'.
	
	model newInheritance superclass: classA; subclass: classB.
	model newInheritance superclass: classB; subclass: classC.
	model newImplementation interface: interfaceA; implementingClass: classB.
	model newImplementation interface: interfaceB; implementingClass: classC.
	
	method1 := model newMethodNamed: 'method'.
	interfaceB addMethod: method1.
	
	method2 := model newMethodNamed: 'method'.
	interfaceA addMethod: method2.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #interfaceA })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns asSet hasSameElements: {method2} 
]

{ #category : 'running' }
SerializationPatternTest >> testComplexResearch3 [

	| patterns model classA classB classC interfaceA interfaceB method1 method2 |
	
	self flag:#todo. "rename this method"
	
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	classB := model newClassNamed: 'classB'.
	classC := model newClassNamed: 'classC'.
	
	interfaceA := model newInterface. interfaceA name: 'interfaceA'.
	interfaceB := model newInterface. interfaceB name: 'interfaceB'.
	
	model newInheritance superclass: classA; subclass: classB.
	model newInheritance superclass: classB; subclass: classC.
	model newImplementation interface: interfaceA; implementingClass: classB.
	model newImplementation interface: interfaceB; implementingClass: classC.
	
	method1 := model newMethodNamed: 'method'.
	interfaceB addMethod: method1.
	
	method2 := model newMethodNamed: 'method'.
	classA addMethod: method2.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #interfaceA })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns asSet hasSameElements: {method2} 
]

{ #category : 'running' }
SerializationPatternTest >> testDontLoopWhenSuperclassIsItself [

	| patterns model class  |
	
	self timeLimit: 1 second.
	
	model := FamixJavaModel new name: 'model'.

	class := model newClassNamed: 'class'.
	
	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #class })) applyOn: model.

	self assert: [patterns isEmpty].
]

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
SerializationPatternTest >> testFindingDoubleInterfaceFollowedByDoubleClass [

	| patterns model interfaceA interfaceB classA classB methodA methodB|
	
	model := FamixJavaModel new name: 'model'.

	interfaceA := model newInterfaceNamed: 'interfaceA'.
	methodA := model newMethodNamed: 'method'.
	interfaceA addMethod: methodA.

	interfaceB := model newInterfaceNamed: 'interfaceB'.
	classA := model newClassNamed: 'classA'.
	
	classB := model newClassNamed: 'classB'.
	methodB := model newMethodNamed: 'method'.
	classB addMethod: methodB.

	model newInheritance superclass: interfaceA; subclass: interfaceB.
	model newImplementation interface: interfaceB; implementingClass: classA.
	model newInheritance superclass: classA; subclass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #interfaceA })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {methodA . methodB} 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingInheritanceFollowedByImplementation [

	| patterns model superInterface method1 subInterface method2  class method3|
	
	model := FamixJavaModel new name: 'model'.

	superInterface := model newInterface.
	superInterface name: 'superInterface'.
	method1 := model newMethodNamed: 'method'.
	superInterface addMethod: method1.

	subInterface := model newInterface.
	subInterface name: 'subInterface'.
	method2 := model newMethodNamed: 'method'.
	subInterface addMethod: method2.
	
	class := model newClassNamed: 'class'.
	method3 := model newMethodNamed: 'method'.
	class addMethod: method3.

	model newInheritance superclass: superInterface; subclass: subInterface.
	model newImplementation interface: subInterface; implementingClass: class.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #superInterface . #subInterface . #class })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {method1 . method2. method3 } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingMethodInInterfaceIfNotDefinedInSelfAndAbstractInSuperClasses [

	| patterns model classA classB interface method1 method2|
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	method1 := model newMethodNamed: 'method'.
	classA addMethod: method1.
	method1 isAbstract: true.
	
	classB := model newClassNamed: 'classB'.
	
	interface := model newInterface.
	interface name: 'interface'.
	method2 := model newMethodNamed: 'method'.
	interface addMethod: method2.

	model newInheritance superclass: classA; subclass: classB.
	model newImplementation interface: interface; implementingClass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #classB })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns asSet hasSameElements: {method2 } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingMethodInSuperClassOfAnImplementationIfNotDefined [

	| patterns model classA method classB interface|
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	method := model newMethodNamed: 'method'.
	classA addMethod: method.
	
	classB := model newClassNamed: 'classB'.
	
	interface := model newInterface.
	interface name: 'interface'.

	model newInheritance superclass: classA; subclass: classB.
	model newImplementation interface: interface; implementingClass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #interface })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {method } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingMethodOfSubClassIfNotDefined [

	| patterns model superclass submethod subclass |
	model := FamixJavaModel new name: 'model'.

	superclass := model newClassNamed: 'superclass'.
	
	subclass := model newClassNamed: 'subclass'.
	submethod := model newMethodNamed: 'method'.
	subclass addMethod: submethod.

	model newInheritance superclass: superclass; subclass: subclass.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: {  #superclass })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {submethod } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingMethodOfSuperClassIfNotDefined [

	| patterns model superclass supermethod subclass |
	model := FamixJavaModel new name: 'model'.

	superclass := model newClassNamed: 'superclass'.
	supermethod := model newMethodNamed: 'method'.
	superclass addMethod: supermethod.

	subclass := model newClassNamed: 'subclass'.

	model newInheritance superclass: superclass; subclass: subclass.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: {  #subclass })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {supermethod } 
]

{ #category : 'running' }
SerializationPatternTest >> testFindingSimpleInheritanceForAbstractClasses [

	| patterns model superclass supermethod subclass submethod |
	model := FamixJavaModel new name: 'model'.

	superclass := model newClassNamed: 'superclass'.
	superclass isAbstract: true.
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

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #superclass })) applyOn: model.

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
	
	self flag:#todo. "the parametric class dont have arguments, should it have at leat one to make the concretization?"

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

	| pattern model classA methodA classB methodB |
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
	
	self assert: pattern patternEntities first identicalTo: methodA.
	self assert: pattern patternEntities second identicalTo: methodB.
]

{ #category : 'running' }
SerializationPatternTest >> testShouldFindImplementedMethodInInterfaceIfNotDefinedInSelf [

	| patterns model classB interface method1 |
	model := FamixJavaModel new name: 'model'.
	
	classB := model newClassNamed: 'classB'.
	
	interface := model newInterface.
	interface name: 'interface'.
	method1 := model newMethodNamed: 'method'.
	interface addMethod: method1.
	
	model newImplementation interface: interface; implementingClass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #classB })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {method1 } 
]

{ #category : 'running' }
SerializationPatternTest >> testShouldFindMethodInSuperClassInsteadOfInterfaceWithAbstractMethod [

	| patterns model classA classB interface method1 method2 |
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	method1 := model newMethodNamed: 'method'.
	classA addMethod: method1.
	
	classB := model newClassNamed: 'classB'.
	
	interface := model newInterface.
	interface name: 'interface'.
	method2 := model newMethodNamed: 'method'.
	interface addMethod: method2.
	method2 isAbstract: true.

	model newInheritance superclass: classA; subclass: classB.
	model newImplementation interface: interface; implementingClass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #classB })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {method1 } 
]

{ #category : 'running' }
SerializationPatternTest >> testShouldFindMethodInSuperClassInsteadOfInterfaceWithImplementedMethod [

	| patterns model classA classB interface method1 method2 |
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	method1 := model newMethodNamed: 'method'.
	classA addMethod: method1.
	
	classB := model newClassNamed: 'classB'.
	
	interface := model newInterface.
	interface name: 'interface'.
	method2 := model newMethodNamed: 'method'.
	interface addMethod: method2.

	model newInheritance superclass: classA; subclass: classB.
	model newImplementation interface: interface; implementingClass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #classB })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {method1 } 
]

{ #category : 'running' }
SerializationPatternTest >> testShouldNotFindAbstractMethodInInterfaceIfNotDefinedInSelf [

	| patterns model classB interface method1 |
	model := FamixJavaModel new name: 'model'.
	
	classB := model newClassNamed: 'classB'.
	
	interface := model newInterface.
	interface name: 'interface'.
	method1 := model newMethodNamed: 'method'.
	interface addMethod: method1.
	method1 isAbstract: true.
	
	model newImplementation interface: interface; implementingClass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #classB })) applyOn: model.

	self assert: [patterns isEmpty].
]

{ #category : 'running' }
SerializationPatternTest >> testShouldNotFindMethodInSuperClassIfDefined [

	| patterns model classA methodA classB methodB|
	model := FamixJavaModel new name: 'model'.

	classA := model newClassNamed: 'classA'.
	methodA := model newMethodNamed: 'method'.
	classA addMethod: methodA.
	
	classB := model newClassNamed: 'classB'.
	methodB := model newMethodNamed: 'method'.
	classB addMethod: methodB.

	model newInheritance superclass: classA; subclass: classB.

	patterns := (SEPatternBlueprint new addMethodBlueprint: (#method methodIn: { #classB })) applyOn: model.

	patterns := patterns collect: [:a | a patternEntities first ] .

	self assertCollection: patterns hasSameElements: {methodB } 
]
