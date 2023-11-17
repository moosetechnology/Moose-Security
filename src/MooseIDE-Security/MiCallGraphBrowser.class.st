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
	mainPresenter run
]

{ #category : #initialization }
MiCallGraphBrowser >> initializePresenters [

	mainPresenter := self instantiate: self class mapClass
]
