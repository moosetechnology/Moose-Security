Class {
	#name : #SHProjectTarget,
	#superclass : #SHObject,
	#instVars : [
		'kind',
		'name'
	],
	#category : #SoftwareHeritage
}

{ #category : #'instance creation' }
SHProjectTarget class >> allTargetsFrom: aDictionary [
	"I don't really know what are the remotes references so for now I'm excluding them..."

	^ (aDictionary associations
		   select: [ :asso | (asso key beginsWith: 'refs/remotes/') not ]
		   thenCollect: [ :asso |
			   (self from: asso key)
				   data: asso value;
				   yourself ]) sort: #priority ascending , #name ascending
]

{ #category : #'instance creation' }
SHProjectTarget class >> from: aReference [

	^ self allSubclasses
		  detect: [ :class | class isValidFor: aReference ]
		  ifFound: [ :class | class newWith: aReference ]
		  ifNone: [ self error: 'Reference kind not supported yet.' ]
]

{ #category : #testing }
SHProjectTarget class >> isValidFor: aReference [

	^ self subclassResponsibility
]

{ #category : #testing }
SHProjectTarget class >> newWith: aReference [

	^ self subclassResponsibility
]

{ #category : #accessing }
SHProjectTarget class >> priority [

	^ self subclassResponsibility
]

{ #category : #accessing }
SHProjectTarget >> iconName [

	^ self subclassResponsibility
]

{ #category : #accessing }
SHProjectTarget >> kind [
	^ self subclassResponsibility
]

{ #category : #accessing }
SHProjectTarget >> name [
	^ name
]

{ #category : #accessing }
SHProjectTarget >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SHProjectTarget >> priority [

	^ self class priority
]