Class {
	#name : #SHProjectSnapshot,
	#superclass : #SHObject,
	#instVars : [
		'branches'
	],
	#category : #SoftwareHeritage
}

{ #category : #branches }
SHProjectSnapshot >> branches [

	^ branches ifNil: [
		  branches := (data at: #branches) associations collect: [ :asso |
			              (SHProjectTarget fromDictionary: asso value)
				              reference: asso key;
				              yourself ] ]
]
