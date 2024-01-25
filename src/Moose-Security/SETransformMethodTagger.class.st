Class {
	#name : #SETransformMethodTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SETransformMethodTagger >> queryEntitiesToTag [

	^ model allModelMethods select: [ :method |
		               method name = #transform ]
]
