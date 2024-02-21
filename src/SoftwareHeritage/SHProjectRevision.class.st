Class {
	#name : #SHProjectRevision,
	#superclass : #SHObject,
	#instVars : [
		'isAvailableForDownload'
	],
	#category : #SoftwareHeritage
}

{ #category : #action }
SHProjectRevision >> checkAvailability [
	"When we want to download a revision we need to request it's cooking first because it is possible it is not yet ready to download. This method allows to check if the revision is ready to be downloaded."

	| requestResult |
	isAvailableForDownload ifTrue: [ ^ self ]. "It is already available."
	requestResult := STONJSON fromString: (ZnClient new get: 'https://archive.softwareheritage.org/api/1/vault/directory/' , (data at: #directory) , '/').

	isAvailableForDownload := (requestResult at: #status) = #done
]

{ #category : #action }
SHProjectRevision >> downloadArchive [

	| requestResult |
	requestResult := STONJSON fromString: (ZnClient new get: 'https://archive.softwareheritage.org/api/1/vault/directory/' , (data at: #directory) , '/').

	self temporaryArchiveName asFileReference
		ensureDelete;
		ensureCreateFile;
		binaryWriteStreamDo: [ :s | s nextPutAll: (ZnClient new get: (requestResult at: #fetch_url)) ]
]

{ #category : #action }
SHProjectRevision >> downloadInFolderNamed: aString [

	aString asFileReference
		ensureDeleteAll;
		ensureCreateDirectory.

	self downloadArchive.

	LibC runCommand: 'tar -xzvf ' , self temporaryArchiveName , ' -C "' , aString , '" --strip-components=1'.

	self temporaryArchiveName asFileReference ensureDelete
]

{ #category : #initialization }
SHProjectRevision >> initialize [

	super initialize.
	isAvailableForDownload := false
]

{ #category : #accessing }
SHProjectRevision >> isAvailableForDownload [

	^ isAvailableForDownload
]

{ #category : #accessing }
SHProjectRevision >> isAvailableForDownload: aBoolean [

	isAvailableForDownload := aBoolean
]

{ #category : #action }
SHProjectRevision >> requestCooking [
	"When we want to download a revision we need to request it's cooking first because it is possible it is not yet ready to download."

	| requestResult |
	requestResult := STONJSON fromString: (ZnClient new
			                  url: 'https://archive.softwareheritage.org/api/1/vault/directory/' , (data at: #directory) , '/';
			                  post).

	isAvailableForDownload := (requestResult at: #status) = #done
]

{ #category : #accessing }
SHProjectRevision >> revision [
	"I don't know why but in some cases to have all the info we need to ask the revision of the revision. This model is weird."

	^ self class fromDictionary: (STONJSON fromString: (ZnClient new get: (data at: #target_url)))
]

{ #category : #action }
SHProjectRevision >> temporaryArchiveName [

	^ 'temporary_archive_from_software_heritage.tar.gz'
]
