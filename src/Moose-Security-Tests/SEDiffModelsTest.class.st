Class {
	#name : #SEDiffModelsTest,
	#superclass : #TestCase,
	#instVars : [
		'classFactory'
	],
	#category : #'Moose-Security-Tests'
}

{ #category : #'as yet unclassified' }
SEDiffModelsTest >> generateClassFactoryMaker [


| classMock |
classMock := classFactory newSubclassOf: SEVulnerabilityTagger .

classMock class compile: 'classImplentingInterfaceDTaggerIn: taggers
<cautionTagger>
	taggers add: (self tagResultOf: [ :model :tagger | tagger classesImplementing: #InterfaceD  in: model  ])' classified: 'default taggers'.

classMock class compile: 'methodCTaggerIn: taggers

	<cautionTagger>
	taggers add: (self tagResultOf: [ :model :tagger | tagger methodsNamed: #methodC in: model ])

' classified: 'default taggers'.

classMock class compile: 'tagColor 

	^ (Color r: 0.70 g: 0.69 b: 0.5 alpha: 1.0)
' classified: 'accessing'.

classMock class compile: 'tagName 

	^ #MockVulnerability
' classified: 'accessing'.



]

{ #category : #running }
SEDiffModelsTest >> setUp [
	super setUp.
	
	classFactory:= ClassFactoryForTestCase new.
	
	
]

{ #category : #running }
SEDiffModelsTest >> tearDown [ 

classFactory cleanUp .

 super tearDown 
]

{ #category : #tests }
SEDiffModelsTest >> testIFM1MinusM2GiveTheOppositeOFM2MinusM1 [

| model1 classA methodA model2 classB methodB interfaceD classBImplementsInterfaceD methodC diffM1MinusM2 diffM2MinusM1 |

self generateClassFactoryMaker .

model1 := FamixJavaModel new
                   name: 'Model 1';
                   yourself.

	
classA := model1 newClassNamed: 'ClassA'.
methodA := model1 newMethodNamed: 'methodA'.
classA addMethod: methodA .


classB := model1 newClassNamed: 'ClassB'.
methodB := model1 newMethodNamed: 'methodB'.
methodC := model1 newMethodNamed: 'methodC'.
classB addMethod: methodB .
classB addMethod: methodC .


model2 := FamixJavaModel new
                   name: 'Model 2';
                   yourself.

	
classA := model2 newClassNamed: 'ClassA'.
methodA := model2 newMethodNamed: 'methodA'.
methodC := model2 newMethodNamed: 'methodC'.
classA addMethod: methodA .
classA addMethod: methodC .
	
	
	
classB := model2 newClassNamed: 'ClassB'.
methodB := model2 newMethodNamed: 'methodB'.
classB addMethod: methodB .


interfaceD := model2 newInterface
                        name: 'InterfaceD';
                        yourself.


classBImplementsInterfaceD :=  model2 newImplementation
        implementingClass: classB ;
        interface: interfaceD;
        yourself.


diffM1MinusM2 := SEDiffBetweenTwoModels new. 
diffM1MinusM2 baseModel: model1  targetModel: model2. 

diffM2MinusM1 := SEDiffBetweenTwoModels new. 
diffM2MinusM1 baseModel: model2  targetModel: model1.

self assert: (diffM1MinusM2 addedEntities equalsTo: diffM2MinusM1 removedEntities ).
self assert: (diffM1MinusM2 removedEntities equalsTo: diffM2MinusM1 addedEntities ).


]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassImplentingAVulnerableInrerfaceHasAddedAndDetected [

| model1 classA methodA model2 classB methodB diff interfaceD classBImplementsInterfaceD |

self generateClassFactoryMaker .

model1 := FamixJavaModel new
                   name: 'Model 1';
                   yourself.

	
classA := model1 newClassNamed: 'ClassA'.
methodA := model1 newMethodNamed: 'methodA'.
classA addMethod: methodA .


classB := model1 newClassNamed: 'ClassB'.
methodB := model1 newMethodNamed: 'methodb'.
classB addMethod: methodB .



model2 := FamixJavaModel new
                   name: 'Model 2';
                   yourself.

	
classA := model2 newClassNamed: 'ClassA'.
methodA := model2 newMethodNamed: 'methodA'.
classA addMethod: methodA .
	
	
	
classB := model2 newClassNamed: 'ClassB'.
methodB := model2 newMethodNamed: 'methodB'.
classB addMethod: methodB .


interfaceD := model2 newInterface
                        name: 'InterfaceD';
                        yourself.


classBImplementsInterfaceD :=  model2 newImplementation
        implementingClass: classB ;
        interface: interfaceD;
        yourself.


diff :=  SEDiffBetweenTwoModels new. 
diff baseModel: model1  targetModel: model2.

self assert: (diff addedEntities includes: classBImplementsInterfaceD).



]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassImplentingAVulnerableInrerfaceHasInTwoVersions [
 "This test depends on what categories we want when we make the diff. In particular, this test must have entities that were identical between versions. If we want this test, we should create a new category (new instance like addedEntities) in SEDiffBetweenTwoModels for collecting identical entities. "
	
	"| model1 classA methodA model2 classB methodB diff interfaceD classBImplementsInterfaceD classE methodE identity identityEntities identityEntitiesTagged methodC |

model1 := FamixJavaModel new
                   name: 'Model 1';
                   yourself.

	
classA := model1 newClassNamed: 'ClassA'.
methodA := model1 newMethodNamed: 'methodA'.
classA addMethod: methodA .
	
	
	
classB := model1 newClassNamed: 'ClassB'.
methodB := model1 newMethodNamed: 'methodB'.
classB addMethod: methodB .


interfaceD := model1 newInterface
                        name: 'InterfaceD';
                        yourself.


classBImplementsInterfaceD :=  model1 newImplementation
        implementingClass: classB ;
        interface: interfaceD;
        yourself.




model2 := FamixJavaModel new
                   name: 'Model 2';
                   yourself.

	
classA := model2 newClassNamed: 'ClassA'.
methodA := model2 newMethodNamed: 'methodA'.
classA addMethod: methodA .
	
	
	
classB := model2 newClassNamed: 'ClassB'.
methodB := model2 newMethodNamed: 'methodB'.
classB addMethod: methodB .

classE := model2 newClassNamed: 'ClassE'.
methodE := model2 newMethodNamed: 'methodE'.
classE addMethod: methodE .



interfaceD := model2 newInterface
                        name: 'InterfaceD';
                        yourself.

classBImplementsInterfaceD :=  model2 newImplementation
        implementingClass: classB ;
        interface: interfaceD;
        yourself.

diff := SEDiffModels new. 
diff baseModel: model1  targetModel: model2.

identity:= diff diffModel result select: [:f | f isUnchanged ] .
identityEntities := identity collect: [ :e | e entity ].
identityEntitiesTagged:= identityEntities select: [ :e | e isTagged  ].
self assert: (identityEntitiesTagged includes: classBImplementsInterfaceD).



"

	
]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassImplentingAVulnerableInrerfaceHasRemovedndDetected [

| model1 classA methodA model2 classB methodB diff interfaceD classBImplementsInterfaceD |

self generateClassFactoryMaker .

model1 := FamixJavaModel new
                   name: 'Model 1';
                   yourself.

	
classA := model1 newClassNamed: 'ClassA'.
methodA := model1 newMethodNamed: 'methodA'.
classA addMethod: methodA .
	
	
	
classB := model1 newClassNamed: 'ClassB'.
methodB := model1 newMethodNamed: 'methodB'.
classB addMethod: methodB .


interfaceD := model1 newInterface
                        name: 'InterfaceD';
                        yourself.


classBImplementsInterfaceD :=  model1 newImplementation
        implementingClass: classB ;
        interface: interfaceD;
        yourself.




model2 := FamixJavaModel new
                   name: 'Model 2';
                   yourself.

	
classA := model2 newClassNamed: 'ClassA'.
methodA := model2 newMethodNamed: 'methodA'.
classA addMethod: methodA .
	
	
	
classB := model2 newClassNamed: 'ClassB'.
methodB := model2 newMethodNamed: 'methodB'.
classB addMethod: methodB .


interfaceD := model2 newInterface
                        name: 'InterfaceD';
                        yourself.



diff := SEDiffBetweenTwoModels new. 
diff baseModel: model1  targetModel: model2.

self assert: (diff removedEntities includes: classBImplementsInterfaceD).



]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassInheritAVulnerableClassAndHasAddedAndDetected [
	

	| model1 classA methodA model2 classB methodB classC methodC classAInheritsClassC diff |
	self generateClassFactoryMaker.

	model1 := FamixJavaModel new
		          name: 'Model 1';
		          yourself.


	classA := model1 newClassNamed: 'ClassA'.
	methodA := model1 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model1 newClassNamed: 'ClassB'.
	methodB := model1 newMethodNamed: 'methodB'.
	classB addMethod: methodB.


	model2 := FamixJavaModel new
		          name: 'Model 2';
		          yourself.


	classA := model2 newClassNamed: 'ClassA'.

	methodA := model2 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model2 newClassNamed: 'ClassB'.
	methodB := model2 newMethodNamed: 'methodB'.
	classB addMethod: methodB.

	classC := model2 newClassNamed: 'ClassC'.
	methodC := model2 newMethodNamed: 'methodC'.
	classC addMethod: methodC.


	classAInheritsClassC := model2 newInheritance
		                        subclass: classA;
		                        superclass: classC;
		                        yourself.


	diff := SEDiffBetweenTwoModels new.
	diff baseModel: model1 targetModel: model2.
	self assert: (diff addedEntities includes: methodC).
	self assert: (classA allHierarchyMethods includes: methodC)
]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassInheritAVulnerableClassAndHasRemovedAndDetected [


	| model1 classA methodA model2 classB methodB classC methodC classAInheritsClassC diff |
	self generateClassFactoryMaker.

	model1 := FamixJavaModel new
		          name: 'Model 1';
		          yourself.


	classA := model1 newClassNamed: 'ClassA'.
	methodA := model1 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model1 newClassNamed: 'ClassB'.
	methodB := model1 newMethodNamed: 'methodB'.
	classB addMethod: methodB.


	classC := model1 newClassNamed: 'ClassC'.
	methodC := model1 newMethodNamed: 'methodC'.
	classC addMethod: methodC.


	classAInheritsClassC := model1 newInheritance
		                        subclass: classA;
		                        superclass: classC;
		                        yourself.

	self assert: (classA allHierarchyMethods includes: methodC).

	model2 := FamixJavaModel new
		          name: 'Model 2';
		          yourself.


	classA := model2 newClassNamed: 'ClassA'.

	methodA := model2 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model2 newClassNamed: 'ClassB'.
	methodB := model2 newMethodNamed: 'methodB'.
	classB addMethod: methodB.

	classC := model2 newClassNamed: 'ClassC'.
	methodC := model2 newMethodNamed: 'methodC'.
	classC addMethod: methodC.



	diff := SEDiffBetweenTwoModels new.
	diff baseModel: model1 targetModel: model2.
	self assert: (classA allHierarchyMethods includes: methodC) not
]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassInheritAvulnerableAbstractClassAndHAsAddedAndDetected [

	| model1 classA methodA model2 classB methodB classC methodC classAInheritsClassC diff |
	self generateClassFactoryMaker.

	model1 := FamixJavaModel new
		          name: 'Model 1';
		          yourself.


	classA := model1 newClassNamed: 'ClassA'.
	methodA := model1 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model1 newClassNamed: 'ClassB'.
	methodB := model1 newMethodNamed: 'methodB'.
	classB addMethod: methodB.

	classC := model1 newClassNamed: 'ClassC'.
	methodC := model1 newMethodNamed: 'methodC'.
	classC isAbstract: true.
	classC addMethod: methodC.


	model2 := FamixJavaModel new
		          name: 'Model 2';
		          yourself.


	classA := model2 newClassNamed: 'ClassA'.

	methodA := model2 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model2 newClassNamed: 'ClassB'.
	methodB := model2 newMethodNamed: 'methodB'.
	classB addMethod: methodB.

	classC := model2 newClassNamed: 'ClassC'.
	methodC := model2 newMethodNamed: 'methodC'.
	classC isAbstract: true.
	classC addMethod: methodC.


	classAInheritsClassC := model2 newInheritance
		                        subclass: classA;
		                        superclass: classC;
		                        yourself.


	diff := SEDiffBetweenTwoModels new.
	diff baseModel: model1 targetModel: model2.
	self assert: (classA allHierarchyMethods includes: methodC)
]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassInheritAvulnerableAbstractClassAndHAsRemovedAndDetected [


	| model1 classA methodA model2 classB methodB classC methodC classAInheritsClassC diff |
	self generateClassFactoryMaker.

	model1 := FamixJavaModel new
		          name: 'Model 1';
		          yourself.


	classA := model1 newClassNamed: 'ClassA'.
	methodA := model1 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model1 newClassNamed: 'ClassB'.
	methodB := model1 newMethodNamed: 'methodB'.
	classB addMethod: methodB.


	classC := model1 newClassNamed: 'ClassC'.
	methodC := model1 newMethodNamed: 'methodC'.
	classC isAbstract: true.
	classC addMethod: methodC.


	classAInheritsClassC := model1 newInheritance
		                        subclass: classA;
		                        superclass: classC;
		                        yourself.


	model2 := FamixJavaModel new
		          name: 'Model 2';
		          yourself.


	classA := model2 newClassNamed: 'ClassA'.

	methodA := model2 newMethodNamed: 'methodA'.
	classA addMethod: methodA.

	classB := model2 newClassNamed: 'ClassB'.
	methodB := model2 newMethodNamed: 'methodB'.
	classB addMethod: methodB.

	classC := model2 newClassNamed: 'ClassC'.
	methodC := model2 newMethodNamed: 'methodC'.
	classC addMethod: methodC.



	diff := SEDiffBetweenTwoModels new.
	diff baseModel: model1 targetModel: model2.
	self assert: (classA allHierarchyMethods includes: methodC) not
]

{ #category : #tests }
SEDiffModelsTest >> testWhenOneVulnerabilityHasRemovedAndDetected [

| model1 classA methodA model2 methodC classB methodB diff |

self generateClassFactoryMaker .

model1 := FamixJavaModel new
                   name: 'Model 1';
                   yourself.

	
classA := model1 newClassNamed: 'ClassA'.
   
methodA := model1 newMethodNamed: 'methodA'.
methodC := model1 newMethodNamed: 'methodC'.
classA addMethod: methodA .
classA addMethod: methodC .
	
classB := model1 newClassNamed: 'ClassB'.
   
methodB := model1 newMethodNamed: 'methodB'.
classB addMethod: methodB .


model2 := FamixJavaModel new
                   name: 'Model 2';
                   yourself.

	
classA := model2 newClassNamed: 'ClassA'.
methodA := model2 newMethodNamed: 'methodA'.
classA addMethod: methodA .


diff := SEDiffBetweenTwoModels new. 
diff baseModel: model1  targetModel: model2.

self assert: (diff removedEntities includes: methodC).



]

{ #category : #tests }
SEDiffModelsTest >> testWhenOneVulnerabilityMethodHasAddedAndDetected [

| model1 classA methodA model2 methodC classB methodB diff |

self generateClassFactoryMaker .

model1 := FamixJavaModel new
                   name: 'Model 1';
                   yourself.

	
classA := model1 newClassNamed: 'ClassA'.
methodA := model1 newMethodNamed: 'methodA'.
classA addMethod: methodA .


model2 := FamixJavaModel new
                   name: 'Model 2';
                   yourself.

	
classA := model2 newClassNamed: 'ClassA'.
   
methodA := model2 newMethodNamed: 'methodA'.
methodC := model2 newMethodNamed: 'methodC'.
classA addMethod: methodA .
classA addMethod: methodC .
	
classB := model2 newClassNamed: 'ClassB'.
   
methodB := model2 newMethodNamed: 'methodB'.
classB addMethod: methodB .


diff := SEDiffBetweenTwoModels new. 
diff baseModel: model1  targetModel: model2.
self assert: (diff addedEntities includes: methodC).



]

{ #category : #tests }
SEDiffModelsTest >> testWhenOneVulnerabilityMethodHasInTwoVersion [
	"This test depends on what categories we want when we make the diff. In particular, this test must have entities that were identical between versions. If we want this test, we should create a new category (new instance like addedEntities) in SEDiffBetweenTwoModels for collecting identical entities."

	"| model1 classA methodA model2 methodC classB methodB diff identiy identityEntities identityEntitiesTagged |
model1 := FamixJavaModel new
                   name: 'Model 1';
                   yourself.

	
classA := model1 newClassNamed: 'ClassA'.
methodA := model1 newMethodNamed: 'methodA'.
methodC := model1 newMethodNamed: 'methodC'.
classA addMethod: methodA .
classA addMethod: methodC .


model2 := FamixJavaModel new
                   name: 'Model 2';
                   yourself.

	
classA := model2 newClassNamed: 'ClassA'.
   
methodA := model2 newMethodNamed: 'methodA'.
methodC := model2 newMethodNamed: 'methodC'.
classA addMethod: methodA .
classA addMethod: methodC .
	
classB := model2 newClassNamed: 'ClassB'.
   
methodB := model2 newMethodNamed: 'methodB'.
classB addMethod: methodB .


diff := SEDiffModels new. 
diff baseModel: model1  targetModel: model2.

identiy:= diff diffModel result select: [:f | f isUnchanged ] .
identityEntities := identiy collect: [ :e | e entity ].
identityEntitiesTagged:= identityEntities select: [ :e | e isTagged  ].
self assert: (identityEntitiesTagged includes: methodC).


"

	
]
