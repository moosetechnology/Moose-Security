Class {
	#name : 'SEPatternCategory',
	#superclass : 'Object',
	#instVars : [
		'category'
	],
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'accessing' }
SEPatternCategory class >> categoryName [
	^ self subclassResponsibility
]
