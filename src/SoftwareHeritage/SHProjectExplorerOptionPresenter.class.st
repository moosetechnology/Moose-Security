Class {
	#name : 'SHProjectExplorerOptionPresenter',
	#superclass : 'SpPresenter',
	#category : 'SoftwareHeritage',
	#package : 'SoftwareHeritage'
}

{ #category : 'accessing' }
SHProjectExplorerOptionPresenter class >> allTypes [

	^ (self allSubclasses sort: #priority ascending) collect: [ :class | class new ]
]

{ #category : 'accessing' }
SHProjectExplorerOptionPresenter class >> priority [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
SHProjectExplorerOptionPresenter >> titleForWindow [

	self subclassResponsibility
]
