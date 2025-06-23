Extension { #name : 'FamixTWithMethods' }

{ #category : '*Moose-Security-Pattern' }
FamixTWithMethods >> hasAnImplemetedMethodNamed: aString [
	^ self methods anySatisfy: [ :method | method name = aString and:[ method isAbstract not ] ]
]

{ #category : '*Moose-Security-Pattern' }
FamixTWithMethods >> methodNamed: aString [

	^ self methods detect: [ :method | method name = aString ]
]
