Class {
	#name : #SESecurityEntryPointMethodAnalyser,
	#superclass : #Object,
	#instVars : [
		'method',
		'tags',
		'model',
		'entryPoints'
	],
	#category : 'Moose-Security'
}

{ #category : #query }
SESecurityEntryPointMethodAnalyser >> callGraphFor: aMethod [ 
	^self callGraphFor: aMethod in: Set new.
]

{ #category : #query }
SESecurityEntryPointMethodAnalyser >> callGraphFor: aMethod in: graph [

	| calledMethod |
	graph add: aMethod.
	calledMethod := (aMethod queryOutgoing: FamixTInvocation) 
		                flatCollectAsSet: #candidates.
	calledMethod do: [ :m | 
		(graph includes: m) ifFalse: [ self callGraphFor: m in: graph ] ].
	^ graph

	"ajouter la profondeur dans le graphe + utiliser disctionnaire pour cela + association (mais faire attention"
]

{ #category : #query }
SESecurityEntryPointMethodAnalyser >> entryPointsNamed: aMethodName [

	entryPoints := model allModelMethods select: [ :m | 
		               m name = aMethodName ]
]

{ #category : #accessing }
SESecurityEntryPointMethodAnalyser >> tags [

	^ tags
]

{ #category : #accessing }
SESecurityEntryPointMethodAnalyser >> tags: anObject [

	tags := anObject
]
