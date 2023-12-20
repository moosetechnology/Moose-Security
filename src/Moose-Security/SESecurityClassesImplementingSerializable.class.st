Class {
	#name : #SESecurityClassesImplementingSerializable,
	#superclass : #SEAbstractVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #accessing }
SESecurityClassesImplementingSerializable class >> tagName [

	^ #SerializableClass
]

{ #category : #accessing }
SESecurityClassesImplementingSerializable >> queryEntitiesToTag [

	^ self nonTestClasses select: [ :class |
		  class directImplementedInterfaces anySatisfy: [ :interface |
			  interface name = #Serializable ] ]
]
