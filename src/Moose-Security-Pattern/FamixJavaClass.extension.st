Extension { #name : 'FamixJavaClass' }

{ #category : '*Moose-Security-Pattern' }
FamixJavaClass >> allRelatedTypeHavingTheMethodNamed: aString [
	"Returns all entities that are related to this type through polymorphism and that implement the given method. 
	If the current entity does not implement the method, a potential parent that does may be returned instead."

	| res |
	res := Set new.
	(self firstParentHavingTheMethodNamed: aString) ifNotNil: [ :a | res add: a ].


	self subInheritances do: [ :inheritance | "The check of (self = inheritance subclass ) exists because in a java jdk, Object is a subclass of Object.
	Meaning that without this check a never ending loop could happen "
		self = inheritance subclass ifFalse: [ res addAll: (inheritance subclass allRelatedTypeHavingTheMethodNamed: aString) ] ].
	^ res
]

{ #category : '*Moose-Security-Pattern' }
FamixJavaClass >> firstParentHavingTheMethodNamed: aString [
	"Returns the first parent of this class having a method named after the given string.
	Note that the first parent can be itself.
	Returns nil if no method was found."

	(self hasAnImplemetedMethodNamed: aString) ifTrue: [ ^ self ].
	"doing this first to make sure the class is studied before interfaces (due to java prioritizing classes implementations of methods)"

	self superclass ifNotNil: [ :superclass | "The check of (self = superclass) exists because in a java jdk, Object is the superclass of Object.
	Meaning that without this check a never ending loop could happen "
			self = superclass ifTrue: [ ^ nil ].
			(superclass firstParentHavingTheMethodNamed: aString) ifNotNil: [ :res | ^ res ] ].
	self interfaceImplementations do: [ :implementation |
		(implementation interface firstParentHavingTheMethodNamed: aString) ifNotNil: [ :res | ^ res ] ].
	^ nil
]
