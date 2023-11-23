Class {
	#name : #MiInspectPathMenuItem,
	#superclass : #MiCallGraphMenuItem,
	#category : #'MooseIDE-Security'
}

{ #category : #testing }
MiInspectPathMenuItem >> canBeExecuted [

	^ shape isShape
]

{ #category : #accessing }
MiInspectPathMenuItem >> iconName [

	^ #smallInspectIt
]

{ #category : #accessing }
MiInspectPathMenuItem >> inspectPathFromRootToShape [

	MiInspectorBrowser inspect:
		(visualization graphModel pathFromRootTo: shape model rawModel)
			asMooseGroup
]

{ #category : #accessing }
MiInspectPathMenuItem >> label [

	^ 'Inspect path'
]

{ #category : #accessing }
MiInspectPathMenuItem >> order [

	^ self defaultOrder + 1
]

{ #category : #accessing }
MiInspectPathMenuItem >> selector [

	^ #inspectPathFromRootToShape
]
