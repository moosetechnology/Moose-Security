Class {
	#name : #MiCallGraphModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'rootMethod',
		'graphNodes',
		'graphEdges'
	],
	#category : #'MooseIDE-Security'
}

{ #category : #'as yet unclassified' }
MiCallGraphModel >> addGraphEdgesFrom: aMethod [

	"May be too large when a lot of invocations. Use signature?"

	aMethod outgoingInvocations do: [ :invocation |
		invocation candidates do: [ :candidate |
			candidate isStub ifFalse: [
				graphEdges at: aMethod at: candidate put: invocation ] ] ]
]

{ #category : #'as yet unclassified' }
MiCallGraphModel >> buildGraph [

	graphNodes := Set new.
	graphEdges := Dictionary new.
	self buildGraphFrom: rootMethod
]

{ #category : #'as yet unclassified' }
MiCallGraphModel >> buildGraphFrom: aMethod [

	graphNodes add: aMethod.
	self addGraphEdgesFrom: aMethod.

	(aMethod outgoingInvocations flatCollectAsSet: #candidates) do: [
		:method |
		(method isStub or: [ graphNodes includes: method ]) ifFalse: [
			self buildGraphFrom: method ] ]
]

{ #category : #accessing }
MiCallGraphModel >> entities [

	^ rootMethod
]

{ #category : #accessing }
MiCallGraphModel >> graphEdges [

	^ graphEdges flattened
]

{ #category : #accessing }
MiCallGraphModel >> graphNodes [

	^ graphNodes
]

{ #category : #'as yet unclassified' }
MiCallGraphModel >> path: aSet fromRootTo: anEntity [

	| senders |

	aSet add: anEntity.
	senders := Set new.
	graphEdges keysAndValuesDo: [ :sender :receiverDict |
		receiverDict at: anEntity ifPresent: [ :invocation |
			senders add: sender.
			aSet add: invocation ] ].
	senders do: [ :sender |
		(aSet includes: sender) ifFalse: [
			self path: aSet fromRootTo: sender ] ].
	^ aSet
]

{ #category : #'as yet unclassified' }
MiCallGraphModel >> pathFromRootTo: anEntity [

	^ self path: OrderedCollection new fromRootTo: anEntity
]

{ #category : #accessing }
MiCallGraphModel >> rootMethod [

	^ rootMethod
]

{ #category : #accessing }
MiCallGraphModel >> rootMethod: anObject [

	rootMethod := anObject
]
