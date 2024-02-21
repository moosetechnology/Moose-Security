Class {
	#name : #SHObject,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#classVars : [
		'BearerAuthentificationToken'
	],
	#category : #SoftwareHeritage
}

{ #category : #accessing }
SHObject class >> bearerAuthentificationToken [

	^ BearerAuthentificationToken
]

{ #category : #accessing }
SHObject class >> bearerAuthentificationToken: aString [

	BearerAuthentificationToken := aString
]

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
SHObject class >> newClient [

	| client |
	client := ZnClient new.

	self bearerAuthentificationToken ifNotNil: [ :token | client setBearerAuthentication: token ].

	^ client
]

{ #category : #accessing }
SHObject class >> query: aQuery [

	^ self newClient get: 'https://archive.softwareheritage.org/api/1/' , aQuery
]

{ #category : #settings }
SHObject class >> softwareHeritageSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder group: #SoftwareHEritage)
		label: 'SoftwareHeritage';
		with: [
			(aBuilder setting: #bearerAuthentificationToken)
				type: #Password;
				label: 'Bearer authentification token';
				description: 'Software heritage bearer authentification token to authentificate request and increase API limit rate.' ]
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
SHObject >> newClient [

	^ self class newClient
]

{ #category : #accessing }
SHObject >> query: aQuery [ 
	^ self class query: aQuery 
]
