Class {
	#name : #SHQueryException,
	#superclass : #Exception,
	#instVars : [
		'data'
	],
	#category : #SoftwareHeritage
}

{ #category : #signalling }
SHQueryException class >> signalForData: aCollection [

	^ self new
		  data: aCollection;
		  signal
]

{ #category : #accessing }
SHQueryException >> data: anObject [
	data := anObject
]

{ #category : #accessing }
SHQueryException >> messageText [

	^ 'An exception happened during the query. Response: ' , data printString
]
