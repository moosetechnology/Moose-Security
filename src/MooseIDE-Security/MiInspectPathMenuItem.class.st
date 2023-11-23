Class {
	#name : #MiInspectPathMenuItem,
	#superclass : #HNodeMenuItem,
	#category : #'MooseIDE-Security'
}

{ #category : #testing }
MiInspectPathMenuItem >> canBeExecuted [

	^ shape isShape
]

{ #category : #accessing }
MiInspectPathMenuItem >> group [

	^ 100
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

	^ 101
]

{ #category : #accessing }
MiInspectPathMenuItem >> selector [

	^ #inspectPathFromRootToShape
]
