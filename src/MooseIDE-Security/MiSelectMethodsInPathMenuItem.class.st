Class {
	#name : #MiSelectMethodsInPathMenuItem,
	#superclass : #MiCallGraphMenuItem,
	#category : #'MooseIDE-Security'
}

{ #category : #accessing }
MiSelectMethodsInPathMenuItem >> group [

	^ 0
]

{ #category : #accessing }
MiSelectMethodsInPathMenuItem >> iconName [

	^ #hierarchy
]

{ #category : #accessing }
MiSelectMethodsInPathMenuItem >> label [

	^ 'Select methods in path'
]

{ #category : #accessing }
MiSelectMethodsInPathMenuItem >> order [

	^ self defaultOrder + 3
]

{ #category : #accessing }
MiSelectMethodsInPathMenuItem >> selectPathFromRootToShape [

	| shapesToSelect |

	shapesToSelect := (visualization pathFromRootTo: shape) reject:
		                  #isLine.
	visualization container setSelectedShapes:
		(RSGroup withAll: shapesToSelect)
]

{ #category : #accessing }
MiSelectMethodsInPathMenuItem >> selector [

	^ #selectPathFromRootToShape
]
