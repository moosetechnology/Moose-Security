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
SHObject >> data [

	^ data
]

{ #category : #accessing }
SHObject >> data: aDictionary [

	data := aDictionary
]
