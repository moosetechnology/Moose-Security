Class {
	#name : 'SHProjectVisit',
	#superclass : 'SHObject',
	#category : 'SoftwareHeritage',
	#package : 'SoftwareHeritage'
}

{ #category : 'accessing' }
SHProjectVisit >> snapshotID [

	^ self data at: #snapshot
]
