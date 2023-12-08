Class {
	#name : #SESecurityAnalyser,
	#superclass : #Object,
	#instVars : [
		'model',
		'tags',
		'classes'
	],
	#category : #'Moose-Security'
}

{ #category : #accessing }
SESecurityAnalyser class >> model: aMooseModel [
	^self new model: aMooseModel 
]

{ #category : #adding }
SESecurityAnalyser >> addTag: aTag [
	tags add: aTag
]

{ #category : #query }
SESecurityAnalyser >> classes [ 
	^ self model allModelClasses 
]

{ #category : #accessing }
SESecurityAnalyser >> model [

	^ model
]

{ #category : #accessing }
SESecurityAnalyser >> model: anObject [

	model := anObject
]

{ #category : #query }
SESecurityAnalyser >> nonTestClasses [

	^ self classes reject: #isTestCase
]

{ #category : #query }
SESecurityAnalyser >> queryClassesImplementingClassName: aString [

	^ self nonTestClasses select: [ :c |
		  c directImplementedInterfaces anySatisfy: [ :i | i name = aString  ] ]
]

{ #category : #query }
SESecurityAnalyser >> queryClassesImplementingClassName: aString tagWith: aTag [

	classes := self queryClassesImplementingClassName: aString.
	self tagElements: classes with: aTag
]

{ #category : #query }
SESecurityAnalyser >> queryClassesImplementingClassName: aString tagWithName: aTagName [

	| tag |
	tag := self model allTags
		       detect: [ :t | t name = aTagName ]
		       ifNone: [ self model createTagNamed: aTagName ].
	^ self queryClassesImplementingClassName: aString tagWith: tag
]

{ #category : #query }
SESecurityAnalyser >> queryClassesWithIncludedName: aString [

	^ self nonTestClasses select: [ :c |
		  c name includesSubstring: aString ]
]

{ #category : #query }
SESecurityAnalyser >> queryClassesWithIncludedName: aString tagWith: aTag [

	classes := self queryClassesWithIncludedName: aString.
	self tagElements: classes with: aTag
]

{ #category : #query }
SESecurityAnalyser >> queryClassesWithIncludedName: aString tagWithName: aTagName [

	| tag |
	tag := self model allTags
		       detect: [ :t | t name = aTagName ]
		       ifNone: [ self model createTagNamed: aTagName ].
	^ self queryClassesWithIncludedName: aString tagWith: tag
]

{ #category : #tag }
SESecurityAnalyser >> tagElements: aCollection with: aTag [

	aCollection do: [ :e | e tagWith: aTag ]
]

{ #category : #accessing }
SESecurityAnalyser >> tags [

	^ tags
]

{ #category : #accessing }
SESecurityAnalyser >> tags: anObject [

	tags := anObject
]
