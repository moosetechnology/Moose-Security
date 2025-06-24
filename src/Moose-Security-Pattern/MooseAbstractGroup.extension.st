Extension { #name : 'MooseAbstractGroup' }

{ #category : '*Moose-Security-Pattern' }
MooseAbstractGroup >> allClassesAndInterfacesNamedIn: aCollection [

	| res |
	res := OrderedCollection new.
	res addAll: (self allClasses select: [ :class | aCollection includes: class name ]).
	res addAll: ((self allWithType: FamixJavaInterface) select: [ :class | aCollection includes: class name ]).
	res addAll: ((self allWithType: FamixJavaParametricInterface) select: [ :class | aCollection includes: class name ]).

	^ res
]

{ #category : '*Moose-Security-Pattern' }
MooseAbstractGroup >> allMethodsNamed: aString [

	^ self allMethods select: [ :method | method name = aString ]
]
