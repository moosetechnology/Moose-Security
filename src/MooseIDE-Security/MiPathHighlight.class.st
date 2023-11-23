Class {
	#name : #MiPathHighlight,
	#superclass : #RSHighlightable,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-Security'
}

{ #category : #'instance creation' }
MiPathHighlight class >> for: aMiCallGraphBuilder [

	^ self new
		  builder: aMiCallGraphBuilder;
		  yourself
]

{ #category : #accessing }
MiPathHighlight >> builder: aMiCallGraphBuilder [

	builder := aMiCallGraphBuilder
]

{ #category : #initialization }
MiPathHighlight >> initialize [

	super initialize.
	self highlightShapes: [ :shape | builder pathFromRootTo: shape ].
	self
		when: RSHighlightEvent do: [ :evt |
			self
				record: (self shapeToHighlightIn: evt shape)
				selector: #color
				value: Color red ]
		for: self;
		when: RSUnHighlightEvent do: [ :evt |
			self restore: (self shapeToHighlightIn: evt shape) selector: #color ]
		for: self
]

{ #category : #'accessing - attributes' }
MiPathHighlight >> shapeToHighlightIn: shape [

	^ shape isComposite
		  ifTrue: [ shape children detect: #isNode ]
		  ifFalse: [ shape ]
]
