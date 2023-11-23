Class {
	#name : #MiCallGraphBuilder,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'graphModel',
		'nodesDictionary',
		'linksDictionary'
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

{ #category : #building }
MiCallGraphBuilder >> buildGraph [

	rootNode addAll: (graphModel graphNodes collect: [ :method |
			 self nodeForMethod: method ]).

	graphModel graphEdges do: [ :invocation |
		invocation candidates do: [ :candidate |
			self linkForInvocation: invocation candidate: candidate ] ]
]

{ #category : #accessing }
MiCallGraphBuilder >> graphModel [

	^ graphModel
]

{ #category : #accessing }
MiCallGraphBuilder >> graphModel: aMiCallGraphModel [

	graphModel := aMiCallGraphModel
]

{ #category : #'accessing - attributes' }
MiCallGraphBuilder >> highlightable [

	^ highlightable ifNil: [ highlightable := MiPathHighlight for: self ]
]

{ #category : #initialization }
MiCallGraphBuilder >> initialize [

	super initialize.
	nodesDictionary := Dictionary new.
	linksDictionary := Dictionary new
]

{ #category : #'accessing - attributes' }
MiCallGraphBuilder >> lineRepresenting: anInvocation inPath: aCollectionOfEntities [

	| candidatesInPath |

	candidatesInPath := anInvocation candidates
		                    select: [ :method |
		                    aCollectionOfEntities includes: method ]
		                    thenCollect: [ :method |
			                    self container shapeFromModel:
				                    (self nodesDictionaryAt: method mooseID) ].

	^ candidatesInPath flatCollectAsSet: [ :rsShape |
		  rsShape incomingLines select: [ :rsLine |
			  rsLine model key rawModel = anInvocation sender ] ]
]

{ #category : #building }
MiCallGraphBuilder >> linkForInvocation: invocation candidate: candidate [

	| nodeForSender hLink nodeForCandidate |

	nodeForSender := nodesDictionary at: invocation sender mooseID.
	nodeForCandidate := nodesDictionary at: candidate mooseID.
	hLink := nodeForSender
		         dependencyTo: nodeForCandidate
		         withModel: invocation.

	^ linksDictionary at: nodeForSender -> nodeForCandidate put: hLink
]

{ #category : #accessing }
MiCallGraphBuilder >> linksDictionaryAt: anAssociation [

	^ linksDictionary at: anAssociation
]

{ #category : #'accessing - attributes' }
MiCallGraphBuilder >> menuItemStrategy [

	^ MiCallGraphMenuItemStrategy new
]

{ #category : #accessing }
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

{ #category : #accessing }
MiCallGraphBuilder >> nodesDictionaryAt: aMooseID [

	^ nodesDictionary at: aMooseID
]

{ #category : #initialization }
MiCallGraphBuilder >> pathFromRootTo: shape [

	| entitiesInPath |

	entitiesInPath := graphModel pathFromRootTo: shape model rawModel.

	^ (entitiesInPath collect: [ :entity |
		   entity isMethod
			   ifTrue: [
				   self container shapeFromModel:
					   (self nodesDictionaryAt: entity mooseID) ]
			   ifFalse: [ self lineRepresenting: entity inPath: entitiesInPath ] ])
		  flattened
]

{ #category : #layout }
MiCallGraphBuilder >> relayout: aGroupOfShapes parent: shape [

	RSTreeLayout on: aGroupOfShapes
]
