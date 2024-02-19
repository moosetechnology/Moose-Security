Class {
	#name : #SHProject,
	#superclass : #SHObject,
	#instVars : [
		'latestVisit',
		'latestSnapshot'
	],
	#category : #SoftwareHeritage
}

{ #category : #'instance creation' }
SHProject class >> projectsFromSearchPattern: aString [

	^ (STONJSON fromString: (ZnClient new get: 'https://archive.softwareheritage.org/api/1/origin/search/' , aString , '/?with_visit=true&limit=1000')) collect: [
		  :dictionary | self fromDictionary: dictionary ]
]

{ #category : #accessing }
SHProject >> latestSnapshot [

	^ latestSnapshot ifNil: [
		  latestSnapshot := SHProjectSnapshot fromDictionary:
			                    (STONJSON fromString: (ZnClient new get: 'https://archive.softwareheritage.org/api/1/snapshot/' , self latestVisit snapshotID)) ]
]

{ #category : #accessing }
SHProject >> latestVisit [

	^ latestVisit ifNil: [
		  latestVisit := SHProjectVisit fromDictionary:
			                 (STONJSON fromString: (ZnClient new get: 'https://archive.softwareheritage.org/api/1/origin/' , self url , '/visit/latest/')) ]
]

{ #category : #accessing }
SHProject >> targets [

	^ self latestSnapshot branches
]

{ #category : #accessing }
SHProject >> url [

	^ data at: #url
]
