Class {
	#name : #SHProjectTarget,
	#superclass : #SHObject,
	#instVars : [
		'kind',
		'name'
	],
	#category : #SoftwareHeritage
}

{ #category : #accessing }
SHProjectTarget >> kind [
	^ kind
]

{ #category : #accessing }
SHProjectTarget >> kind: anObject [
	kind := anObject
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
SHProjectTarget >> reference: aString [
	"Some info are present only in the reference of a branch so we parse it to extract the maximum ammount of info. This will be a little ugly and maybe I can iterate on it later."

	aString = 'HEAD' ifTrue: [
		self kind: 'HEAD'.
		self name: 'Default branch'.
		^ self ].

	(aString beginsWith: 'refs/') ifTrue: [
		| reference |
		reference := aString allButFirst: 5.

		(reference beginsWith: 'pull') ifTrue: [
			self kind: 'Pull request'.
			self name: ((reference withoutPrefix: 'pull/') withoutSuffix: '/head').
			^ self ].
		(reference beginsWith: 'tags') ifTrue: [
			self kind: 'Tag'.
			self name: (reference withoutPrefix: 'tags/').
			^ self ].
		(reference beginsWith: 'heads') ifTrue: [
			self kind: 'Branch'.
			self name: (reference withoutPrefix: 'heads/').
			^ self ] ].

	self error: 'Reference kind not managed.'
]
