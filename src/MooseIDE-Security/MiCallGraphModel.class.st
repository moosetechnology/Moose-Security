Class {
	#name : #MiCallGraphModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'rootMethod',
		'graphNodes',
		'graphEdges',
		'settings'
	],
	#category : #'MooseIDE-Security'
}

{ #category : #graph }
MiCallGraphModel >> addGraphEdgesFrom: aMethod [

	"May be too large when a lot of invocations. Use signature?"

	aMethod outgoingInvocations do: [ :invocation |
		invocation candidates do: [ :candidate |
			(self shouldAddToGraph: candidate) ifTrue: [
				graphEdges at: aMethod at: candidate put: invocation ] ] ]
]

{ #category : #graph }
MiCallGraphModel >> buildGraph [

	graphNodes := Set new.
	graphEdges := Dictionary new.
	self buildGraphFrom: rootMethod
]

{ #category : #graph }
MiCallGraphModel >> buildGraphFrom: aMethod [

	graphNodes add: aMethod.
	self addGraphEdgesFrom: aMethod.

	(aMethod outgoingInvocations flatCollectAsSet: #candidates) do: [
		:method |
		((self shouldAddToGraph: method) and: [
			 (graphNodes includes: method) not ]) ifTrue: [
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

{ #category : #initialization }
MiCallGraphModel >> initializeSettings [

	settings := MiCallGraphSettingsPresenter owner: self
]

{ #category : #actions }
MiCallGraphModel >> openSettings [

	settings open
]

{ #category : #graph }
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

{ #category : #graph }
MiCallGraphModel >> pathFromRootTo: anEntity [

	^ self path: OrderedCollection new fromRootTo: anEntity
]

{ #category : #accessing }
MiCallGraphModel >> rootMethod: anObject [

	rootMethod := anObject
]

{ #category : #accessing }
MiCallGraphModel >> settingsChanged: aBoolean [

	aBoolean ifFalse: [ ^ self ].
	browser updateGraph
]

{ #category : #graph }
MiCallGraphModel >> shouldAddToGraph: method [

	^ (settings getItemValue: #includeStubs) or: [ method isStub not ]
]
