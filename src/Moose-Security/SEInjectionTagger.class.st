Class {
	#name : #SEInjectionTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #'default taggers' }
SEInjectionTagger class >> executeQueryTagger [

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #executeQuery in: model ]
]

{ #category : #'default taggers' }
SEInjectionTagger class >> getConnectionTagger [

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #getConnection in: model ]
]

{ #category : #accessing }
SEInjectionTagger class >> tagName [

	^ #Injection
]
