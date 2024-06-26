Class {
	#name : #SEDiffModelsTest,
	#superclass : #TestCase,
	#category : #'Moose-Security-Tests'
}

{ #category : #tests }
SEDiffModelsTest >> testIFM1MinusM2GiveTheOppositeOFM2MinusM1 [

| model1 classA methodA model2 classB methodB interfaceD classBImplementsInterfaceD methodC diffM1MinusM2 diffM2MinusM1 |

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


diffM1MinusM2 := SEDiffModels new. 
diffM1MinusM2 baseModel: model1  targetModel: model2.

diffM2MinusM1 := SEDiffModels new. 
diffM2MinusM1 baseModel: model2  targetModel: model1.

self assert: (diffM1MinusM2 addedEntitesTagged equalsTo: diffM2MinusM1 removedEntitesTagged ).
self assert: (diffM1MinusM2 removedEntitesTagged equalsTo: diffM2MinusM1 addedEntitesTagged ).


]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassImplentingAVulnerableInrerfaceHasAddedAndDetected [

| model1 classA methodA model2 classB methodB diff interfaceD classBImplementsInterfaceD |

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


diff := SEDiffModels new. 
diff baseModel: model1  targetModel: model2.

self assert: (diff addedEntitesTagged includes: classBImplementsInterfaceD).



]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassImplentingAVulnerableInrerfaceHasInTwoVersions [

| model1 classA methodA model2 classB methodB diff interfaceD classBImplementsInterfaceD classE methodE identity identityEntities identityEntitiesTagged methodC |

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




]

{ #category : #tests }
SEDiffModelsTest >> testWhenAClassImplentingAVulnerableInrerfaceHasRemovedndDetected [

| model1 classA methodA model2 classB methodB diff interfaceD classBImplementsInterfaceD |

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



diff := SEDiffModels new. 
diff baseModel: model1  targetModel: model2.

self assert: (diff removedEntitesTagged includes: classBImplementsInterfaceD).



]

{ #category : #tests }
SEDiffModelsTest >> testWhenOneVulnerabilityHasInTwoVersion [
"verifier si l on veut detecter aussi les vulnerabilites qui sont presentent dans les deux versions et non corrigées "
| model1 classA methodA model2 methodC classB methodB diff identiy identityEntities identityEntitiesTagged |
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



]

{ #category : #tests }
SEDiffModelsTest >> testWhenOneVulnerabilityHasRemovedAndDetected [

| model1 classA methodA model2 methodC classB methodB diff |

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


diff := SEDiffModels new. 
diff baseModel: model1  targetModel: model2.

self assert: (diff removedEntitesTagged includes: methodC).



]

{ #category : #tests }
SEDiffModelsTest >> testWhenOneVulnerabilityMethodHasAddedAndDetected [

| model1 classA methodA model2 methodC classB methodB diff |

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


diff := SEDiffModels new. 
diff baseModel: model1  targetModel: model2.
self assert: (diff addedEntitesTagged includes: methodC).



]
