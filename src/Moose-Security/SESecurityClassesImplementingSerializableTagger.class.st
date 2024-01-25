Class {
	#name : #SESecurityClassesImplementingSerializableTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SESecurityClassesImplementingSerializableTagger class >> tagName [

	^ #SerializableClass
]

{ #category : #accessing }
SESecurityClassesImplementingSerializableTagger >> queryEntitiesToTag [

	^ self nonTestClasses select: [ :class |
		  class directImplementedInterfaces anySatisfy: [ :interface |
			  interface name = #Serializable ] ]
]
