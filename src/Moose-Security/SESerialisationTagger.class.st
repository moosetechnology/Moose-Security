Class {
	#name : #SESerialisationTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #'default taggers' }
SESerialisationTagger class >> getOutputPropertiesTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
			  tagger methodsNamed: #getOutputProperties in: model ]
		  with: #getOutputPropertiesMethod
]

{ #category : #'default taggers' }
SESerialisationTagger class >> getTransletInstanceTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
			  tagger methodsNamed: #getTransletInstance in: model ]
		  with: #getTransletInstanceMethod
]

{ #category : #'default taggers' }
SESerialisationTagger class >> mapClassTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger | tagger classesImplementing: #Map in: model ]
		  with: #MapClass
]

{ #category : #'default taggers' }
SESerialisationTagger class >> newTransformerTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
		  tagger methodsNamed: #newTransformer in: model ]
		  with: '#[Serialization]newTransformerMethod'
]

{ #category : #'default taggers' }
SESerialisationTagger class >> readObjectTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
		  tagger methodsNamed: #readObject in: model ]
		  with: #readObjectMethod
]

{ #category : #'default taggers' }
SESerialisationTagger class >> serializableClassTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger | tagger classesImplementing: #Serializable in: model ]
		  with: #SerializableClass
]

{ #category : #'default taggers' }
SESerialisationTagger class >> transformTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
		  tagger methodsNamed: #transform in: model ]
		  with: #transformMethod
]

{ #category : #'default taggers' }
SESerialisationTagger class >> transformerClassTagger [

	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger | tagger classesImplementing: #Transformer in: model ]
		  with: #TransformerClass
]
