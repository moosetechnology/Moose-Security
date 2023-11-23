Class {
	#name : #MiInspectMethodsInPathMenuItem,
	#superclass : #MiInspectPathMenuItem,
	#category : #'MooseIDE-Security'
}

{ #category : #accessing }
MiInspectMethodsInPathMenuItem >> inspectPathFromRootToShape [

	MiInspectorBrowser inspect:
		((visualization graphModel pathFromRootTo: shape model rawModel)
			 select: #isMethod) asMooseGroup
]

{ #category : #accessing }
MiInspectMethodsInPathMenuItem >> label [

	^ 'Inspect methods in path'
]

{ #category : #accessing }
MiInspectMethodsInPathMenuItem >> order [

	^ self defaultOrder + 2
]
