Class {
	#name : #MiCallGraphBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'graphModel',
		'nodesDictionary'
	],
	#category : #'MooseIDE-Security'
}

{ #category : #building }
MiCallGraphBuilder >> build [

	rootNode := HNode new.
	self buildGraph.
	self renderIn: self container.
	self container @ RSCanvasController.
	^ self container
]

{ #category : #'as yet unclassified' }
MiCallGraphBuilder >> buildGraph [

	graphModel buildGraph.

	rootNode addAll: (graphModel graphNodes collect: [ :method |
			 self nodeForMethod: method ]).

	graphModel graphEdges do: [ :invocation |
		invocation candidates do: [ :candidate |
			(nodesDictionary at: invocation sender mooseID)
				dependencyTo: (nodesDictionary at: candidate mooseID)
				withModel: invocation ] ]
]

{ #category : #accessing }
MiCallGraphBuilder >> graphModel: aMiCallGraphModel [

	graphModel := aMiCallGraphModel
]

{ #category : #'accessing - attributes' }
MiCallGraphBuilder >> highlightable [

	^ highlightable ifNil: [
		  highlightable := RSHighlightable new
			                   highlightShapes: [ :shape |
				                   self pathFromRootTo: shape ];
			                   when: RSHighlightEvent do: [ :evt |
				                   highlightable
					                   record: (self shapeToHighlightIn: evt shape)
					                   selector: #color
					                   value: Color red ]
			                   for: self;
			                   when: RSUnHighlightEvent do: [ :evt |
				                   highlightable
					                   restore: (self shapeToHighlightIn: evt shape)
					                   selector: #color ]
			                   for: self;
			                   yourself ]
]

{ #category : #'as yet unclassified' }
MiCallGraphBuilder >> initialize [

	super initialize.
	nodesDictionary := Dictionary new
]

{ #category : #hooks }
MiCallGraphBuilder >> nodeAnnouncer [

	baseNode ifNotNil: [ ^ baseNode announcer ].
	baseNode := RSComposite new
		            @ self popup;
		            @
			            (HGhostDraggable new color:
					             Smalltalk ui theme caretColor);
		            @ self menuInteraction;
		            @ self highlightable;
		            @ RSNodeOnTopWhenPositionChanged new;
		            @ HUpdateSelectionBox new;
		            @ HResizeParentWhenChildMoves new;
		            yourself.
	^ baseNode announcer
]

{ #category : #'as yet unclassified' }
MiCallGraphBuilder >> nodeForMethod: aMethod [

	| node |

	node := HNode new
		        name: aMethod name;
		        rawModel: aMethod;
		        style: MiCallGraphStyle new;
		        yourself.

	nodesDictionary at: aMethod mooseID put: node.
	^ node
]

{ #category : #'accessing - attributes' }
MiCallGraphBuilder >> pathFromRootTo: shape [

"ifTrue:ifFalse: to be used if the model returns the edges. Cf model >>#path:fromRootTo: "

	^ (graphModel pathFromRootTo: shape model rawModel) collect: [
		  :entity |
		  entity isMethod
			  ifTrue: [
			  self container shapeFromModel:
				  (nodesDictionary at: entity mooseID) ]
			  "ifFalse: [ self container lines shapeFromModel: entity ] "]
]

{ #category : #layout }
MiCallGraphBuilder >> relayout: aGroupOfShapes parent: shape [

	RSRadialTreeLayout on: aGroupOfShapes
]

{ #category : #'accessing - attributes' }
MiCallGraphBuilder >> shapeToHighlightIn: shape [

	^ shape isComposite
		  ifTrue: [ shape children detect: #isNode ]
		  ifFalse: [ shape ]
]
