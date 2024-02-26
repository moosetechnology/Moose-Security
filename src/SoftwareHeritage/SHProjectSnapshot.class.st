Class {
	#name : 'SHProjectSnapshot',
	#superclass : 'SHObject',
	#instVars : [
		'branches'
	],
	#category : 'SoftwareHeritage',
	#package : 'SoftwareHeritage'
}

{ #category : 'branches' }
SHProjectSnapshot >> branches [

	^ branches ifNil: [ branches := SHProjectTarget allTargetsFrom: (data at: #branches) ]
]
