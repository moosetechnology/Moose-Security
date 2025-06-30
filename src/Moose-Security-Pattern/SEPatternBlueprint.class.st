"
SEPatternBlueprint define a pattern of a chained method invocations to the apply on a model and find all possibly existing concretizations of it in the model.


# Example of use:

((#method1 methodIn: { #class1 }) calling: #method2 methodInAll ) applyOn: aModel.

## Explanation :
- ""methodIn:"" indicates that ""method1"" must be in the context of the type ""class1""
- ""methodInAll"" indicates that the method can be in any class.
- ""calling:"" allows you to define what the next method of the pattern will be
- ""applyOn:"" will apply the research of patterns in the given model and return every pattern detected.

## Replace :
- ""aModel"" by the model needed.
- ""method1"" and ""method2"" by the names of the methods searched.
- ""class1"" by the name of the class where method1 is.

# For more example : 
See the protocol pattern from SEPatternFinder.

# For an easy use : 
SEPatternFinder applyAllOn: aModel
This command will try to detect a bunch of pattern appearing in ysoserial callstacks




"
Class {
	#name : 'SEPatternBlueprint',
	#superclass : 'Object',
	#instVars : [
		'methodBlueprints'
	],
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'adding' }
SEPatternBlueprint >> addMethodBlueprint: aMethodBlueprint [

	methodBlueprints add: aMethodBlueprint.
]

{ #category : 'detection' }
SEPatternBlueprint >> applyOn: aModel [
	"Apply itself on a model, and returns all possibles concretizations of itself in it"

	| resultPatterns |
	methodBlueprints do: [ :blueprint | blueprint model: aModel ].
	resultPatterns := methodBlueprints first selectMethodsAsStartingOfPattern asOrderedCollection collect: [ :a |
		                  { a } asOrderedCollection ].

	methodBlueprints allButFirst do: [ :methodBlueprint |
			resultPatterns := resultPatterns
				                  collect: [ :collection |
						                  collection
							                  add: (methodBlueprint selectOutgoingInvocationOf: collection last);
							                  yourself ]
				                  thenReject: [ :col | col last isEmpty ].
			resultPatterns := resultPatterns flatCollect: [ :col | col last collect: [ :next | col allButLast copyWith: next ] ] ].

	^ resultPatterns collect: [ :collected |
			  SEPattern new
				  category: SESerialisationCategory;
				  addPatternEntities: collected ]
]

{ #category : 'actions' }
SEPatternBlueprint >> calling: aSEMethodBlueprint [
	"add a new SEMethodBlueprint for the next method invocation in the pattern"

	^ self
		  addMethodBlueprint: aSEMethodBlueprint;
		  yourself
]

{ #category : 'initialization' }
SEPatternBlueprint >> initialize [ 
	super initialize.
	methodBlueprints := OrderedCollection new.
]

{ #category : 'printing' }
SEPatternBlueprint >> printOn: aStream [

	super printOn: aStream.

	aStream << ' ('.

	methodBlueprints do: [ :blueprint | blueprint printBlueprintOn: aStream ] separatedBy: [ aStream << ' -> ' ].

	aStream << ')'
]
