Extension { #name : 'Symbol' }

{ #category : '*Moose-Security-Pattern' }
Symbol >> methodIn: aCollection [
	"create an instance of SEMethodInvoctationBlueprint with self as the name of the method
	and the given collection as the names of the searched parent where the method can be found"

	^ SEMethodInvoctationBlueprint new
		  methodName: self;
		  addMethodParentTypes: aCollection;
		  yourself
]

{ #category : '*Moose-Security-Pattern' }
Symbol >> methodInAll [

	"create an instance of SEMethodInvoctationBlueprint with self as the name of the method and the possibility to be in every entities"

	^ SEMethodInvoctationBlueprint new
		  methodName: self;
		  yourself
]
