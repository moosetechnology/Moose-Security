"
I am a browser that displays a call graph.
Accepted entities: a FamixTMethod.

When passing over a method, I show the path going from the root method to the highlighted method.
You can select or inspect this path from the context menu.
"
Class {
	#name : #MiCallGraphBrowser,
	#superclass : #MiAbstractVisualizationBrowser,
	#category : #'MooseIDE-Security'
}

{ #category : #accessing }
MiCallGraphBrowser class >> mapClass [

	^ MiCallGraphVisualization
]

{ #category : #'world menu' }
MiCallGraphBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiCallGraphBrowser class >> menuItem [

	^ #CallGraph
]

{ #category : #'instance creation' }
MiCallGraphBrowser class >> newModel [

	^ MiCallGraphModel new
]

{ #category : #'instance creation' }
MiCallGraphBrowser class >> open [

	<script>
	super open
]

{ #category : #specs }
MiCallGraphBrowser class >> title [

	^ 'Call Graph'
]

{ #category : #testing }
MiCallGraphBrowser >> canFollowEntity: anObject [

	^ anObject usesFamixTrait: FamixTMethod
]

{ #category : #actions }
MiCallGraphBrowser >> followEntity: anEntity [

	specModel rootMethod: anEntity.

	self updateGraph
]

{ #category : #testing }
MiCallGraphBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiCallGraphBrowser >> initializePresenters [

	mainPresenter := self instantiate: self class mapClass
]

{ #category : #TOREMOVE }
MiCallGraphBrowser >> updateGraph [

	specModel buildGraph.
	mainPresenter run
]
