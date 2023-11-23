Class {
	#name : #MiCallGraphMenuItemStrategy,
	#superclass : #HDefaultMenuItemStrategy,
	#category : #'MooseIDE-Security'
}

{ #category : #public }
MiCallGraphMenuItemStrategy >> menuItemClassesFor: aShape [

	^ (super menuItemClassesFor: aShape)
	  , { MiInspectMethodsInPathMenuItem }
]
