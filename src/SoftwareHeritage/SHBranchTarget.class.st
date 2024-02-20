Class {
	#name : #SHBranchTarget,
	#superclass : #SHProjectTarget,
	#category : #SoftwareHeritage
}

{ #category : #testing }
SHBranchTarget class >> isValidFor: aReference [

	^ aReference beginsWith: 'refs/heads'
]

{ #category : #testing }
SHBranchTarget class >> newWith: aReference [

	^ self new
		  name: (aReference withoutPrefix: 'refs/heads/');
		  yourself
]

{ #category : #accessing }
SHBranchTarget class >> priority [

	^ 4
]

{ #category : #'as yet unclassified' }
SHBranchTarget >> download [

	self revision download
]

{ #category : #accessing }
SHBranchTarget >> iconName [

	^ #branch
]

{ #category : #accessing }
SHBranchTarget >> kind [

	^ #Branch
]
