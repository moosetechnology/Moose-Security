Class {
	#name : #SEGetTransletInstanceMethodTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SEGetTransletInstanceMethodTagger >> queryEntitiesToTag [

	^ model allModelMethods select: [ :method |
		  method name = #getTransletInstance ]
]
