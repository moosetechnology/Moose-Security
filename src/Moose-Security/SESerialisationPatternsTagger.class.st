Class {
	#name : 'SESerialisationPatternsTagger',
	#superclass : 'SEVulnerabilityTagger',
	#category : 'Moose-Security',
	#package : 'Moose-Security'
}

{ #category : 'adding' }
SESerialisationPatternsTagger class >> addMethodNameTaggersTo: taggers [

	"<cautionTagger>
	#( #''org::apache::commons::collections::map::LazyMap.get(Object)'' #getOutputProperties #getTransletInstance
	   #newOutputStream #newTransformer #readAllBytes #readExternal
	   #readLine #readObject #transform ) do: [ :methodName |
		taggers add: (self tagResultOf: [ :model :tagger |
				 tagger methodsNamed: methodName in: model ]) ]"
]

{ #category : 'querry' }
SESerialisationPatternsTagger class >> detectPattern: aCollection onModel: model [
	| resultPatterns |
	resultPatterns := (model allModelMethods select: [ :method | method name = (aCollection at:1)]) asOrderedCollection  collect: [ :a | { a } asOrderedCollection ].
	
	2 to: aCollection size do: [ :index | 
		resultPatterns do: [ :col | col add:(self getOutgoingInvocationOf: (aCollection at:index) for: col last) ].
		resultPatterns := resultPatterns reject: [ :col | col last isEmpty.]. 
		resultPatterns := resultPatterns flatCollect: [ :col | col last collect: [ :next | col allButLast copyWith: next ] ].
		 ].
	
	^ resultPatterns collect: [ :collected | (SEPattern new category: SESerialisationCategory ) entities: collected ].
]

{ #category : 'Blueprint' }
SESerialisationPatternsTagger class >> detectPatternBlueprint: aPatternBlueprint onModel: aModel [

	| resultPatterns |
	resultPatterns := (self
		                   getFirstPatternMethods: aPatternBlueprint
		                   onModel: aModel) collect: [ :a |
		                  { a } asOrderedCollection ].
	
	aPatternBlueprint methodBlueprints allButFirst do: [ :blueprint |
		resultPatterns := resultPatterns collect: [ :collection |
			collection add:
				(blueprint getMethodsAfter: collection last);yourself] thenReject: [ :col | col last isEmpty ].
		resultPatterns := resultPatterns flatCollect: [ :col |
			                  col last collect: [ :next |
				                  col allButLast copyWith: next ] ] ].
	
	^ resultPatterns collect: [ :collected |
		  (SEPattern new category: SESerialisationCategory)
			  addPatternEntities: collected ]
]

{ #category : 'MoTion' }
SESerialisationPatternsTagger class >> detectPatternMoTion: aCollection onModel: aModel [

	| res col |
	col := { (#name <=> aCollection first) } asOrderedCollection. 

	aCollection allButFirst ifNotEmpty: [
		col add:
			(self getOutgoingInvocationOfMoTion: aCollection allButFirst) ].

	res := (FamixJavaModel % { 
			#'allModelMethods>entities' <=> FamixJavaMethod % col as: 'result' 
		} match: aModel
		) bindingsFor: 'result'.
		
	^ res collect: [ :collected | (SEPattern new category: SESerialisationCategory ) addPatternEntity: collected ].
]

{ #category : 'Blueprint' }
SESerialisationPatternsTagger class >> getAllSpecializedMethodsForClass: aClass forBlueprint: methodBlueprint [

	| res toAdd|
	res := Set new.
	toAdd := methodBlueprint methodParentTypes isEmpty or: [(methodBlueprint methodParentTypes includes: aClass name )].
	
	toAdd ifTrue:[ res add: (aClass getMethod: methodBlueprint modelMethodName )].
	
	aClass subInheritances do: [ :entity |
		res addAll: (self
				 getAllSpecializedMethodsForClass: entity subclass
				 forBlueprint: methodBlueprint) ].
	^ res
]

{ #category : 'Blueprint' }
SESerialisationPatternsTagger class >> getAllSpecializedMethodsForInterface: anInterface forBlueprint: methodBlueprint [

	| res implementingClass toAdd|
	res := Set new.
	toAdd := methodBlueprint methodParentTypes isEmpty or: [(methodBlueprint methodParentTypes includes: anInterface name )].
	
	toAdd ifTrue:[ res add: (anInterface getMethod: methodBlueprint modelMethodName )].

	anInterface implementations do: [ :entity | 
		implementingClass := entity implementingClass.
		implementingClass isInterface ifTrue: [
			res addAll: (self
					 getAllSpecializedMethodsForInterface: implementingClass
					 forBlueprint: methodBlueprint) ].
		implementingClass isClass ifTrue: [
			res addAll:
				(self
					 getAllSpecializedMethodsForClass: implementingClass
					 forBlueprint: methodBlueprint) ] ].
	^ res
]

{ #category : 'Blueprint' }
SESerialisationPatternsTagger class >> getFirstPatternMethods: aPatternBlueprint onModel: aModel [

	| methodSet methodBlueprint |
	methodBlueprint := aPatternBlueprint methodBlueprints first.
	methodSet := aModel allMethodsNamed: methodBlueprint modelMethodName.
	^ methodSet select:[:method | methodBlueprint methodParentTypes includes: method parentType name]
]

{ #category : 'Blueprint' }
SESerialisationPatternsTagger class >> getMethodsAfter: aMethod forBlueprint: aMethodBlueprint [

	| methodSet |
	methodSet := ((aMethod query outgoing objects dependenciesOfType:
		               FamixTInvocation) select: [ :method |
		              method name = aMethodBlueprint modelMethodName ])
		             asSet.
	^ self
		  getNextStepOfPattern:  methodSet
		  forBlueprint: aMethodBlueprint
]

{ #category : 'Blueprint' }
SESerialisationPatternsTagger class >> getNextStepOfPattern: methodCollection forBlueprint: methodBlueprint [

	| res parent |
	res := Set new.

	methodCollection do: [ :method |
		parent := method parentType.
		parent isInterface ifTrue: [
			res addAll:
				(self
					 getAllSpecializedMethodsForInterface: parent
					 forBlueprint: methodBlueprint) ].
		parent isClass ifTrue: [
			res addAll:
				(self getAllSpecializedMethodsForClass: parent forBlueprint: methodBlueprint) ].
		(methodBlueprint methodParentTypes includes: parent name) ifTrue: [
			res add: method ] ].
	^ res
]

{ #category : 'querry' }
SESerialisationPatternsTagger class >> getOutgoingInvocationOf: aString for: aMethod [
	| res |
	res := (aMethod query outgoing objects dependenciesOfType: FamixTInvocation ) select: [ :method | method name = aString ]. 
	^ res asSet
]

{ #category : 'MoTion' }
SESerialisationPatternsTagger class >> getOutgoingInvocationOfMoTion: aCollection [
	| result |
	result := { #name <=> (aCollection first) } asOrderedCollection .
	
	aCollection allButFirst ifNotEmpty: [ result add: (self getOutgoingInvocationOfMoTion: aCollection allButFirst)  ].
	
	^ #'outgoingInvocations>candidates' <=> FamixJavaMethod % result
]
