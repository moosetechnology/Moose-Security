Class {
	#name : #SHProjectRevision,
	#superclass : #SHObject,
	#category : #SoftwareHeritage
}

{ #category : #action }
SHProjectRevision >> downloadInFolderNamed: aString [

	[ :surroundingJob |
	surroundingJob title: 'Downloading of ' , aString.
	[ :job |
	| requestResult archiveName |
	job title: 'Requesting download ' , aString.

	requestResult := STONJSON fromString: (ZnClient new
			                  url: 'https://archive.softwareheritage.org/api/1/vault/directory/' , (data at: #directory) , '/';
			                  post).

	[ (requestResult at: #status) = #done ] whileFalse: [
		job
			title: 'Waiting for Software Heritage availability for ' , aString;
			progress: 0.25.
		5 seconds wait.
		requestResult := STONJSON fromString: (ZnClient new get: 'https://archive.softwareheritage.org/api/1/vault/directory/' , (data at: #directory) , '/') ].
	job
		title: 'Downloading ' , aString;
		progress: 0.5.
	(archiveName := 'temporary_archive_from_software_heritage.tar.gz') asFileReference
		ensureDelete;
		ensureCreateFile;
		binaryWriteStreamDo: [ :s | s nextPutAll: (ZnClient new get: (requestResult at: #fetch_url)) ].

	job
		title: 'Unizipping ' , aString;
		progress: 0.75.
	aString asFileReference
		ensureDeleteAll;
		ensureCreateDirectory.

	LibC runCommand: 'tar -xzvf ' , archiveName , ' -C "' , aString , '" --strip-components=1'.

	archiveName asFileReference ensureDelete ] asJob run ] asJob run
]

{ #category : #accessing }
SHProjectRevision >> revision [
	"I don't know why but in some cases to have all the info we need to ask the revision of the revision. This model is weird."

	^ self class fromDictionary: (STONJSON fromString: (ZnClient new get: (data at: #target_url)))
]
