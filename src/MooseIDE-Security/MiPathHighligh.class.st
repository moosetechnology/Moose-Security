Class {
	#name : #MiPathHighligh,
	#superclass : #RSHighlightable,
	#category : #'MooseIDE-Security'
}

{ #category : #initialization }
MiPathHighligh >> initialize [

	super initialize.
	self highlightShapes: [ :s | self pathFrom: s ]
]

{ #category : #'private - initialization' }
MiPathHighligh >> pathFrom: aShape [

	^ self pathFrom: aShape in: RSGroup new
]

{ #category : #'private - initialization' }
MiPathHighligh >> pathFrom: aShape in: aGroup [

	| outgoingEdges |

	aGroup add: aShape.

	outgoingEdges := aShape outgoingLines.
	aGroup addAll: outgoingEdges.

	outgoingEdges collect: [ :edge | edge to ] thenDo: [ :shape |
		(aGroup includes: shape) ifFalse: [ self pathFrom: shape in: aGroup ] ].

	^ aGroup
]
