Class {
	#name : #SESocketTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #'default taggers' }
SESocketTagger class >> connectTagger [
	"This method is located in the SocketChannel class."

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #connect in: model ]
]

{ #category : #'default taggers' }
SESocketTagger class >> openTagger [
	"This method is located in the SocketChannel class."

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #open in: model ]
]

{ #category : #'default taggers' }
SESocketTagger class >> shutdownInputTagger [
	"This method is located in the SocketChannel class."

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #shutdownInput in: model ]
]

{ #category : #'default taggers' }
SESocketTagger class >> shutdownOutputTagger [
	"This method is located in the SocketChannel class."

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #shutdownOutput in: model ]
]

{ #category : #accessing }
SESocketTagger class >> tagName [

	^ #Socket
]
