Extension { #name : 'Symbol' }

{ #category : '*Moose-Security-Pattern' }
Symbol >> methodIn: aCollection [

	^ SEMethodInvoctationBlueprint new
		  methodName: self;
		  addMethodParentTypes: aCollection;
		  yourself
]

{ #category : '*Moose-Security-Pattern' }
Symbol >> methodInAll [

	^ SEMethodInvoctationBlueprint new
		  methodName: self;
		  yourself
]
