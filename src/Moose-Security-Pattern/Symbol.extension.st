Extension { #name : 'Symbol' }

{ #category : '*Moose-Security-Pattern' }
Symbol >> methodIn: aCollection [

	^ SEMethodInvoctationBlueprint new
		  modelMethodName: self;
		  addMethodParentTypes: aCollection;
		  yourself
]

{ #category : '*Moose-Security-Pattern' }
Symbol >> methodInAll [

	^ SEMethodInvoctationBlueprint new
		  modelMethodName: self;
		  yourself
]
