"
Is a concrete pattern obtained by applyOn: of a SEPatternBlueprint instance that has been detected on the given model
"
Class {
	#name : 'SEPattern',
	#superclass : 'Object',
	#instVars : [
		'category',
		'patternEntities'
	],
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'accessing' }
SEPattern >> addPatternEntities: aCollection [
	patternEntities addAll: aCollection
]

{ #category : 'accessing' }
SEPattern >> addPatternEntity: anEntity [
	patternEntities add: anEntity
]

{ #category : 'accessing' }
SEPattern >> category [
	^ category
]

{ #category : 'accessing' }
SEPattern >> category: aCategory [
	category := aCategory
]

{ #category : 'initialization' }
SEPattern >> initialize [ 
	super initialize.
	patternEntities := OrderedCollection new.
]

{ #category : 'accessing' }
SEPattern >> patternEntities [
	^ patternEntities
]
