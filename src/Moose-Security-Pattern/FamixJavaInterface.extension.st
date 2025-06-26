Extension { #name : 'FamixJavaInterface' }

{ #category : '*Moose-Security-Pattern' }
FamixJavaInterface >> allRelatedTypeHavingTheMethodNamed: aString [
	"Returns all entities that are related to this type through polymorphism and that implement the given method. 
	If the current entity does not implement the method, a potential parent that does may be returned instead."
	| res |
	res := Set new.
	(self firstParentHavingTheMethodNamed: aString) ifNotNil: [ :a | res add: a].


	self flag: #todo. "are (self = inheritance subclass ) and (self = implementation implementingClass) really usefull ? "
	self implementations do: [ :implementation |
		self = implementation implementingClass ifFalse: [ res addAll: (implementation implementingClass allRelatedTypeHavingTheMethodNamed: aString) ] ].
	self subInheritances do: [ :inheritance |
		self = inheritance subclass ifFalse: [ res addAll: (inheritance subclass allRelatedTypeHavingTheMethodNamed: aString) ] ].

	^ res

]

{ #category : '*Moose-Security-Pattern' }
FamixJavaInterface >> firstParentHavingTheMethodNamed: aString [

	(self hasAnImplemetedMethodNamed: aString) ifTrue: [ ^ self ].

	^ self superclass ifNotNil: [ :superclass |
		  self = superclass ifFalse: [ superclass firstParentHavingTheMethodNamed: aString] ]
]
