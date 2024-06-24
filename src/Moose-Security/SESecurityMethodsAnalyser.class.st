Class {
	#name : #SESecurityMethodsAnalyser,
	#superclass : #Object,
	#instVars : [
		'model',
		'tags',
		'methods'
	],
	#category : 'Moose-Security'
}

{ #category : #accessing }
SESecurityMethodsAnalyser >> methods [

	^ methods
]

{ #category : #accessing }
SESecurityMethodsAnalyser >> methods: anObject [

	methods := anObject
]

{ #category : #accessing }
SESecurityMethodsAnalyser >> model [

	^ model
]

{ #category : #accessing }
SESecurityMethodsAnalyser >> model: anObject [

	model := anObject
]

{ #category : #query }
SESecurityMethodsAnalyser >> queryMethodsWithIncludedName: aString [
	^ self methods select: [ :m | m name includesSubstring: aString ]
]

{ #category : #query }
SESecurityMethodsAnalyser >> queryMethodsWithIncludedName: aString InClass: aClassName tagWithName: aTagName [
	| tag |
	
	tag := self model allTags detect: [ :t | t name = aTagName ] ifNone: [ self model createTagNamed: aTagName  ].
	^ self queryMethodsWithIncludedName: aString tagWith: tag.
]

{ #category : #query }
SESecurityMethodsAnalyser >> queryMethodsWithIncludedName: aString tagWith: aTag [
	methods := self queryMethodsWithIncludedName: aString.
	self tagMethods: methods with: aTag
]

{ #category : #query }
SESecurityMethodsAnalyser >> queryMethodsWithIncludedName: aString tagWithName: aTagName [
	| tag |
	tag := self model allTags detect: [ :t | t name = aTagName ] ifNone: [ self model createTagNamed: aTagName  ].
	^ self queryMethodsWithIncludedName: aString tagWith: tag.
]

{ #category : #tag }
SESecurityMethodsAnalyser >> tagMethods: aCollection with: aTag [
	aCollection do: [ :e | e tagWith: aTag ]
]

{ #category : #accessing }
SESecurityMethodsAnalyser >> tags [

	^ tags
]

{ #category : #accessing }
SESecurityMethodsAnalyser >> tags: anObject [

	tags := anObject
]
