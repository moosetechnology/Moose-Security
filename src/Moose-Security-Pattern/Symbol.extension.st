Extension { #name : 'Symbol' }

{ #category : '*Moose-Security-Pattern' }
Symbol >> methodIn: aCollection [

	^ SEMethodInvoctationBlueprint new
		  modelMethodName: self;
		  addMethodParentTypes: aCollection;
		  yourself
]
