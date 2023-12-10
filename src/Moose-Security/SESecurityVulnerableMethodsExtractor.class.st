Class {
	#name : #SESecurityVulnerableMethodsExtractor,
	#superclass : #Object,
	#instVars : [
		'methods',
		'classes'
	],
	#category : #'Moose-Security'
}

{ #category : #accessing }
SESecurityVulnerableMethodsExtractor >> classes [

	^ classes
]

{ #category : #accessing }
SESecurityVulnerableMethodsExtractor >> classes: anObject [

	classes := anObject
]

{ #category : #accessing }
SESecurityVulnerableMethodsExtractor >> methods [

	^ methods
]

{ #category : #accessing }
SESecurityVulnerableMethodsExtractor >> methods: anObject [

	methods := anObject
]
