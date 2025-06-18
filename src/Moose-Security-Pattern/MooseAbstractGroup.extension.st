Extension { #name : 'MooseAbstractGroup' }

{ #category : '*Moose-Security-Pattern' }
MooseAbstractGroup >> allClassesAndInterfacesNamedIn: aCollection [

	| res |
	self flag:#todo. "correct the bug on cc31"
	res := self allClasses.
	res addAll: (self allWithType: FamixJavaInterface ).
	res addAll: (self allWithType: FamixJavaParametricInterface).


	^ res select: [ :entity |
		  aCollection anySatisfy: [ :elem | elem = entity name ] ]
]

{ #category : '*Moose-Security-Pattern' }
MooseAbstractGroup >> allMethodsNamed: aString [

	^ self allMethods select: [ :method | method name = aString ]
]
