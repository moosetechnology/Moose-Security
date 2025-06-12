Extension { #name : 'FamixTWithMethods' }

{ #category : '*Moose-Security-Pattern' }
FamixTWithMethods >> methodNamed: aString [
		
		^ self methods detect: [ :method |
			method name = aString ] 
]
