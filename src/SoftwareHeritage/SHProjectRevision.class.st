Class {
	#name : #SHProjectRevision,
	#superclass : #SHObject,
	#category : #SoftwareHeritage
}

{ #category : #action }
SHProjectRevision >> download [

	| requestResult |
	requestResult := STONJSON fromString: (ZnClient new
			                  url: 'https://archive.softwareheritage.org/api/1/vault/directory/' , (data at: #directory) , '/';
			                  post).

	[ (requestResult at: #status) = #done ] whileFalse: [
		5 seconds wait.
		requestResult := STONJSON fromString: (ZnClient new get: 'https://archive.softwareheritage.org/api/1/vault/directory/' , (data at: #directory) , '/') ].

	'test.tar.gz' asFileReference
		ensureDelete;
		ensureCreateFile;
		binaryWriteStreamDo: [ :s | s nextPutAll: (ZnClient new get: (requestResult at: #fetch_url)) ].

	'test' asFileReference
		ensureDeleteAll;
		ensureCreateDirectory.

	LibC runCommand: 'tar -xzvf test.tar.gz -C test --strip-components=1'.

	'test.tar.gz' asFileReference ensureDelete
]
