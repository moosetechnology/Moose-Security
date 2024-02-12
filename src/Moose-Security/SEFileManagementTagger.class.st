Class {
	#name : #SEFileManagementTagger,
	#superclass : #SEVulnerabilityTagger,
	#category : #'Moose-Security'
}

{ #category : #'default taggers' }
SEFileManagementTagger class >> createSourceFileTagger [
	"This method is located in the Filer interface. This interface supports the creation of new files by an annotation processor. Files created in this way will be known to the annotation processing tool implementing this interface, better enabling the tool to manage them. Source and class files so created will be considered for processing by the tool in a subsequent round of processing after the close method has been called on the Writer or OutputStream used to write the contents of the file. Three kinds of files are distinguished: source files, class files, and auxiliary resource files."

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #createSourceFile in: model ]
]

{ #category : #'default taggers' }
SEFileManagementTagger class >> newBufferedReaderWriterTagger [
	"method in the class Files"

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | (tagger methodsNamed: #newBufferedReader in: model) , (tagger methodsNamed: #newBufferedWriter in: model) ]
]

{ #category : #'default taggers' }
SEFileManagementTagger class >> setOwnerTagger [
	"This method is located in the Files class."

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #setOwner in: model ]
]

{ #category : #accessing }
SEFileManagementTagger class >> tagName [

	^ #FileManagement
]

{ #category : #'default taggers' }
SEFileManagementTagger class >> writeStringTagger [

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #writeString in: model ]
]

{ #category : #'default taggers' }
SEFileManagementTagger class >> writeTagger [

	<cautionTagger>
	^ self tagResultOf: [ :model :tagger | tagger methodsNamed: #write in: model ]
]