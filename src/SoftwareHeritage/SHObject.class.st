Class {
	#name : #SHObject,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #SoftwareHeritage
}

{ #category : #'instance creation' }
SHObject class >> fromDictionary: aDictionary [

	^ self new
		  data: aDictionary;
		  yourself
]

{ #category : #accessing }
SHObject class >> jsonForQuery: aQuery [

	| aSHObject |
	aSHObject := self new.

	^ STONJSON fromString: (aSHObject query: aQuery)
]

{ #category : #accessing }
SHObject class >> query: aQuery [

	^ ZnClient new get: 'https://archive.softwareheritage.org/api/1/' , aQuery
]

{ #category : #accessing }
SHObject >> data [

	^ data
]

{ #category : #accessing }
SHObject >> data: aDictionary [

	data := aDictionary
]

{ #category : #accessing }
SHObject >> jsonForQuery: aQuery [ 
	^ self class jsonForQuery: aQuery 
]

{ #category : #accessing }
SHObject >> query: aQuery [ 
	^ self class query: aQuery 
]
