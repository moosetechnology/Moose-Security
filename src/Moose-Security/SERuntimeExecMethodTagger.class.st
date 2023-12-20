Class {
	#name : #SERuntimeExecMethodTagger,
	#superclass : #SEAbstractVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SERuntimeExecMethodTagger class >> tagName [
	^ 'RuntimeExec'
]

{ #category : #accessing }
SERuntimeExecMethodTagger >> queryEntitiesToTag [

	^ model allModelMethods select: [ :method |
		               method name = #exec ]
]
