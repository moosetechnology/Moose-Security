Class {
	#name : #SESocketTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #'default taggers' }
SESocketTagger class >> connectTagger [
"This method is located in the SocketChannel class.
"
	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
		  tagger methodsNamed: #connect in: model ]
		  with: #connectMethod
]

{ #category : #'default taggers' }
SESocketTagger class >> shutdownInputTagger [
"This method is located in the SocketChannel class.
"
	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
		  tagger methodsNamed: #shutdownInput in: model ]
		  with: #shutdownInputMethod
]

{ #category : #'default taggers' }
SESocketTagger class >> shutdownOutputTagger [
"This method is located in the SocketChannel class.
"
	<cautionTagger>
	^ self
		  tagResultOf: [ :model :tagger |
		  tagger methodsNamed: #shutdownOutput in: model ]
		  with: #shutdownOutputMethod
]
