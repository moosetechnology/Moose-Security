Class {
	#name : #SEGetOutputPropertiesMethodTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SEGetOutputPropertiesMethodTagger >> queryEntitiesToTag [

	^ model allModelMethods select: [ :method |
		  method name = #getOutputProperties ]
]
