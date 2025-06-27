"
SEPatternCategory offer the possibility to categorize an attack pattern for the type of attacks it define
"
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
