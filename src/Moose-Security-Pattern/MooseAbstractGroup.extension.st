Extension { #name : 'MooseAbstractGroup' }

{ #category : '*Moose-Security-Pattern' }
MooseAbstractGroup >> allMethodsNamed: aString [
	^ self allMethods select: [ :method |
		   method name = aString ]
]
