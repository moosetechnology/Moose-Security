Class {
	#name : 'SEMethodInvoctationBlueprintTest',
	#superclass : 'TestCase',
	#category : 'Moose-Security-Pattern-Tests',
	#package : 'Moose-Security-Pattern-Tests'
}

{ #category : 'as yet unclassified' }
SEMethodInvoctationBlueprintTest >> testPossibleParentTypesForDescandantsOfInterface [

	| blueprint model interfaceA interfaceB classA classB|
	
	model := FamixJavaModel new name: 'model'.

	interfaceA := model newInterfaceNamed: 'interfaceA'.
	interfaceA addMethod: (model newMethodNamed: 'method').

	interfaceB := model newInterfaceNamed: 'interfaceB'.
	
	classA := model newClassNamed: 'classA'.
	
	classB := model newClassNamed: 'classB'.
	classB addMethod: (model newMethodNamed: 'method').

	model newInheritance superclass: interfaceA; subclass: interfaceB.
	model newImplementation interface: interfaceB; implementingClass: classA.
	model newImplementation interface: interfaceB; implementingClass: classB.
	
	blueprint := SEMethodInvoctationBlueprint new modelMethodName: #method ; addMethodParentType: #interfaceA; model: model.

	self assertCollection: (blueprint possibleParentTypes) hasSameElements: {interfaceA . classB } 
]
