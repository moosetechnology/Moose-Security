Class {
	#name : 'SESecurityVulnerableMethodsExtractor',
	#superclass : 'Object',
	#instVars : [
		'methods',
		'classes'
	],
	#category : 'Moose-Security',
	#package : 'Moose-Security'
}

{ #category : 'accessing' }
SESecurityVulnerableMethodsExtractor >> classes [

	^ classes
]

{ #category : 'accessing' }
SESecurityVulnerableMethodsExtractor >> classes: anObject [

	classes := anObject
]

{ #category : 'accessing' }
SESecurityVulnerableMethodsExtractor >> methods [

	^ methods
]

{ #category : 'accessing' }
SESecurityVulnerableMethodsExtractor >> methods: anObject [

	methods := anObject
]

{ #category : 'query' }
SESecurityVulnerableMethodsExtractor >> vulnerableMethodSelector [
	"this method is intended for looking for methods with given names in the classes of Commons-Collections 3.1"

	^ self methods select: [ :m |
		  #( 'getValue' 'hashCode' 'equals' 'get' 'transform' ) includes:
			  m name ]
]
