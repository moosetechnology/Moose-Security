Class {
	#name : #SHReleaseTarget,
	#superclass : #SHProjectTarget,
	#category : #SoftwareHeritage
}

{ #category : #testing }
SHReleaseTarget class >> isValidFor: aReference [

	^ aReference beginsWith: 'releases/'
]

{ #category : #testing }
SHReleaseTarget class >> newWith: aReference [

	^ self new
		  name: (aReference withoutPrefix: 'releases/');
		  yourself
]

{ #category : #accessing }
SHReleaseTarget class >> priority [

	^ 2
]

{ #category : #accessing }
SHReleaseTarget >> iconName [

	^ #glamorousBookmark
]

{ #category : #accessing }
SHReleaseTarget >> kind [
	^ #Release
]