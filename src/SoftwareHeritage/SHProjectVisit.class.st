Class {
	#name : #SHProjectVisit,
	#superclass : #SHObject,
	#category : #SoftwareHeritage
}

{ #category : #accessing }
SHProjectVisit >> snapshotID [

	^ self data at: #snapshot
]