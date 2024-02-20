Class {
	#name : #SHPullRequestTarget,
	#superclass : #SHProjectTarget,
	#category : #SoftwareHeritage
}

{ #category : #testing }
SHPullRequestTarget class >> isValidFor: aReference [

	^ aReference beginsWith: 'refs/pull'
]

{ #category : #testing }
SHPullRequestTarget class >> newWith: aReference [

	^ self new
		  name: ((aReference withoutPrefix: 'refs/pull/') withoutSuffix: '/head');
		  yourself
]

{ #category : #accessing }
SHPullRequestTarget class >> priority [

	^ 10
]

{ #category : #action }
SHPullRequestTarget >> downloadInFolderNamed: aString [

	self revision downloadInFolderNamed: aString
]

{ #category : #accessing }
SHPullRequestTarget >> iconName [

	^ #merge
]

{ #category : #accessing }
SHPullRequestTarget >> kind [

	^ #'Pull request'
]
