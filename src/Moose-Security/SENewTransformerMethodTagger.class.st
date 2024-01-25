Class {
	#name : #SENewTransformerMethodTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SENewTransformerMethodTagger >> queryEntitiesToTag [

	^ model allModelMethods select: [ :method |
		  method name = #newTransformer ]
]
