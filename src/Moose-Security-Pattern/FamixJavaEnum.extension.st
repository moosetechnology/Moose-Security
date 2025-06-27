Extension { #name : 'FamixJavaEnum' }

{ #category : '*Moose-Security-Pattern' }
FamixJavaEnum >> allRelatedTypeHavingTheMethodNamed: aString [
	"Returns all entities that are related to this type through polymorphism and that implement the given method. 
	If the current entity does not implement the method, a potential parent that does may be returned instead."

	^ self subclassResponsibility
]
