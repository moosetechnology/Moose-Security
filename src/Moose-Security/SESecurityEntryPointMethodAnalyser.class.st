Class {
	#name : 'SESecurityEntryPointMethodAnalyser',
	#superclass : 'Object',
	#instVars : [
		'method',
		'tags',
		'model',
		'entryPoints'
	],
	#category : 'Moose-Security',
	#package : 'Moose-Security'
}

{ #category : 'construction' }
SESecurityEntryPointMethodAnalyser class >> buildCallGraphAtEntryPoint: aMethod [

	|cg|
	
	cg := JavaCallGraphModel chaFromMethod: aMethod.
	
	^ cg 
]

{ #category : 'construction' }
SESecurityEntryPointMethodAnalyser class >> buildCallGraphsOfAllEntitiesOf: aCollection [
	" for each method of the collection in input in parameter, we build the corresponding call graph"

	| methodsVigilancePoints callgraphs |
	methodsVigilancePoints := aCollection flatCollectAsSet: [ :entity |
		                          entity query descendants ofType:
			                          FamixTMethod "this givves the methods contained in this entity (if it is already a method, it will give the method itself" ]. "flatCollectAsSet sends the set of methods wihtout doublons"
	callgraphs := Dictionary new.

	methodsVigilancePoints
		do: [ :method |
			callgraphs
				at: method
				put: (self buildCallGraphAtEntryPoint: method) ]
		displayingProgress: [ :method | method mooseName ].

	^ callgraphs
]

{ #category : 'collection' }
SESecurityEntryPointMethodAnalyser class >> collectAllClassesOf: anArchitecturalMap [
	
		^ anArchitecturalMap allClassNames . 
]

{ #category : 'query' }
SESecurityEntryPointMethodAnalyser >> callGraphFor: aMethod [ 
	^self callGraphFor: aMethod in: Set new.
]

{ #category : 'query' }
SESecurityEntryPointMethodAnalyser >> callGraphFor: aMethod in: graph [

	| calledMethod |
	graph add: aMethod.
	calledMethod := (aMethod queryOutgoing: FamixTInvocation) 
		                flatCollectAsSet: #candidates.
	calledMethod do: [ :m | 
		(graph includes: m) ifFalse: [ self callGraphFor: m in: graph ] ].
	^ graph

	"ajouter la profondeur dans le graphe + utiliser disctionnaire pour cela + association (mais faire attention"
]

{ #category : 'query' }
SESecurityEntryPointMethodAnalyser >> entryPointsNamed: aMethodName [

	entryPoints := model allModelMethods select: [ :m | 
		               m name = aMethodName ]
]

{ #category : 'accessing' }
SESecurityEntryPointMethodAnalyser >> tags [

	^ tags
]

{ #category : 'accessing' }
SESecurityEntryPointMethodAnalyser >> tags: anObject [

	tags := anObject
]
