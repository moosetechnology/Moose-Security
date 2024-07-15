Class {
	#name : #SEDiffBetweenTwoModels,
	#superclass : #Object,
	#instVars : [
		'diffModel',
		'removedEntities',
		'addedEntities',
		'vulnerableEntities',
		'removedEntitiesTagged',
		'removedEntitiesTaggedAssociation',
		'entitiesTagged',
		'res',
		'addedEntitiesTagged'
	],
	#category : #'Moose-Security'
}

{ #category : #accessing }
SEDiffBetweenTwoModels >> addedEntities [

^ addedEntities.
]

{ #category : #accessing }
SEDiffBetweenTwoModels >> addedEntitiesTagged [

^ addedEntitiesTagged.
]

{ #category : #'instance creation' }
SEDiffBetweenTwoModels >> baseModel: baseModel targetModel: targetModel [
	
	SEVulnerabilityTagger tagAllVulnerabilitiesOf: baseModel .
	SEVulnerabilityTagger tagAllVulnerabilitiesOf: targetModel .
	
	
	diffModel := FXDiff
		             runOnBaseModel: baseModel
		             targetModel: targetModel.

	self entitiesFilter.
]

{ #category : #'as yet unclassified' }
SEDiffBetweenTwoModels >> displayEntities [
	
	 | browser |
	
	removedEntities  value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ Removed vulnerable entities]'.
	

	addedEntities  value miPropagate.
	browser := MiArchitecturalMapBrowser open.
	browser beFrozen.
	browser window title: browser window title , ' [ Added vulnerable entities]'.
]

{ #category : #'as yet unclassified' }
SEDiffBetweenTwoModels >> entitiesFilter [

	removedEntitiesTagged := diffModel result removals select: [ :e|
			e isForAssociation ifTrue: [ e entity source isTagged ]
			ifFalse: [ e entity isTagged ] ].
		
	removedEntities := removedEntitiesTagged collect: [ :e | 
				e entity] .
			
			
	addedEntitiesTagged := diffModel result additions select: [ :e|
			e isForAssociation ifTrue: [ e entity source isTagged ]
			ifFalse: [ e entity isTagged ] ].
		
	addedEntities := addedEntitiesTagged collect: [ :e | 
				e entity ].
	
	self makeCategoriesforEntities: addedEntities .
	self makeCategoriesforEntities: removedEntities .
	
	self displayEntities.


]

{ #category : #'as yet unclassified' }
SEDiffBetweenTwoModels >> makeCategoriesforEntities: entites [

	
	 | methods access references inheritances invocations|
	
	methods :=  entites select: [ :e | e isMethod].
	methods tagEntitiesWithName: #Methods.
 	
	access :=   entites select: [ :e | e isAccess].
	access tagEntitiesWithName: #Access.
	
	references :=  entites select: [ :e | e isReference].
	references tagEntitiesWithName: #Reference.
	
 	inheritances := entites select: [ :e | e isInheritance  ].
	inheritances tagEntitiesWithName: #Inheritance .
	
	
	invocations := entites select: [ :e | e isInvocation  ].
	invocations tagEntitiesWithName: #Invocation .

	
	
]

{ #category : #accessing }
SEDiffBetweenTwoModels >> removedEntities [

^ removedEntities .
]

{ #category : #accessing }
SEDiffBetweenTwoModels >> removedEntitiesTagged [

^ removedEntitiesTagged .
]
