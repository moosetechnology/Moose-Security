Extension { #name : 'MooseAbstractGroup' }

{ #category : '*Moose-Security-Pattern' }
MooseAbstractGroup >> allClassesAndInterfacesNamedIn: aCollection [

	| res |
	res := self entities select: [ :entity |
		       entity isClass or: [ entity isInterface ] ].


	^ res select: [ :entity |
		  aCollection anySatisfy: [ :elem | elem = entity name ] ]
]

{ #category : '*Moose-Security-Pattern' }
MooseAbstractGroup >> allMethodsNamed: aString [

	^ self allMethods select: [ :method | method name = aString ]
]
