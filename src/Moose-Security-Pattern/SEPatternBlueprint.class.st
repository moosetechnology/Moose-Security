"
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
See allKnownPatterns from SEPatternFinder.

# For an easy use : 
SEKnownPattern applyOn: aModel
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

	| resultPatterns |
	methodBlueprints do: [ :blueprint | blueprint model: aModel ].
	resultPatterns := methodBlueprints first getFirstPatternMethods asOrderedCollection collect: [ :a |
		                  { a } asOrderedCollection ].

	methodBlueprints allButFirst do: [ :methodBlueprint |
			resultPatterns := resultPatterns
				                  collect: [ :collection |
						                  collection
							                  add: (methodBlueprint getMethodsAfter: collection last);
							                  yourself ]
				                  thenReject: [ :col | col last isEmpty ].
			resultPatterns := resultPatterns flatCollect: [ :col |
				                  col last collect: [ :next | col allButLast copyWith: next ] ] ].

	^ resultPatterns collect: [ :collected |
			  SEPattern new
				  category: SESerialisationCategory;
				  addPatternEntities: collected ]
]

{ #category : 'actions' }
SEPatternBlueprint >> calling: aSEMethodBlueprint [

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
