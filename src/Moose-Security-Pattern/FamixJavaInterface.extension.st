Extension { #name : 'FamixJavaInterface' }

{ #category : '*Moose-Security-Pattern' }
FamixJavaInterface >> allRelatedTypeHavingTheMethodNamed: aString [
	"Returns all entities that are related to this type through polymorphism and that implement the given method. 
	If the current entity does not implement the method, a potential parent that does may be returned instead."

	| res |
	res := Set new.
	(self firstParentHavingTheMethodNamed: aString) ifNotNil: [ :a | res add: a ].

	self implementations do: [ :implementation |
		res addAll: (implementation implementingClass allRelatedTypeHavingTheMethodNamed: aString) ].
	self subInheritances do: [ :inheritance |
		res addAll: (inheritance subclass allRelatedTypeHavingTheMethodNamed: aString) ].

	^ res
]

{ #category : '*Moose-Security-Pattern' }
FamixJavaInterface >> firstParentHavingTheMethodNamed: aString [
	"Returns the first parent of this interface having a method named after the given string.
	Note that the first parent can be itself.
	can return nil if no method was found."

	(self hasAnImplemetedMethodNamed: aString) ifTrue: [ ^ self ].

	^ self superclass ifNotNil: [ :superclass | superclass firstParentHavingTheMethodNamed: aString ]
]
