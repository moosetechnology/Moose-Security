Extension { #name : 'FamixJavaClass' }

{ #category : '*Moose-Security-Pattern' }
FamixJavaClass >> allRelatedTypeHavingTheMethodNamed: aString [
	"Returns all entities that are related to this type through polymorphism and that implement the given method. 
	If the current entity does not implement the method, a potential parent that does may be returned instead."

	| res |
	res := Set new.
	(self firstParentHavingTheMethodNamed: aString) ifNotNil: [ :a | res add: a. ].

	self flag: #todo. "is (self = inheritance subclass ) really usefull ? "
	self subInheritances do: [ :inheritance |
		self = inheritance subclass ifFalse: [ res addAll: (inheritance subclass allRelatedTypeHavingTheMethodNamed: aString) ] ].
	^ res
]

{ #category : '*Moose-Security-Pattern' }
FamixJavaClass >> firstParentHavingTheMethodNamed: aString [

	(self hasAnImplemetedMethodNamed: aString) ifTrue: [ ^ self ].
	"doing this first to make sure the class is studied before interfaces (due to java prioritizing classes implementations of methods)"

	self superclass ifNotNil: [ :superclass |
			self = superclass ifTrue: [ ^ nil ].
			(superclass firstParentHavingTheMethodNamed: aString) ifNotNil: [ :res | ^ res ] ].
	self interfaceImplementations do: [ :implementation |
		(implementation interface firstParentHavingTheMethodNamed: aString) ifNotNil: [ :res | ^ res ] ].
	^ nil
]
