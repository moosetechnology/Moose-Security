Class {
	#name : #SEReadObjectMethodTagger,
	#superclass : #SEAbstractVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SEReadObjectMethodTagger class >> tagName [
	^ #ReadObject
]

{ #category : #accessing }
SEReadObjectMethodTagger >> queryEntitiesToTag [

	^ model allModelMethods select: [ :method |
		  method name = #readObject ]
]
