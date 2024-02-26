Class {
	#name : 'SHImporter',
	#superclass : 'Object',
	#instVars : [
		'downloadedFolders'
	],
	#classVars : [
		'VerveineJPath'
	],
	#category : 'SoftwareHeritage',
	#package : 'SoftwareHeritage'
}

{ #category : 'accessing' }
SHImporter class >> defaultVerveineJDirectory [

	^ FileSystem workingDirectory / 'VerveineJ'
]

{ #category : 'actions' }
SHImporter class >> downloadAndImport: aListOfTargets [

	^ self new downloadAndImport: aListOfTargets
]

{ #category : 'settings' }
SHImporter class >> importSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #verveineJPath)
		parent: #SoftwareHeritage;
		type: #FilePathEncoder;
		default: self verveineJPath;
		label: 'VerveineJ path';
		description: 'If you wish to use your own version of verveineJ you can specify your own path to it..';
		target: self
]

{ #category : 'accessing' }
SHImporter class >> verveineJPath [

	^ VerveineJPath ifNil: [ VerveineJPath := self defaultVerveineJDirectory ]
]

{ #category : 'accessing' }
SHImporter class >> verveineJPath: anObject [

	VerveineJPath := anObject
]

{ #category : 'actions' }
SHImporter >> download: aListOfTargets [

	[ :job |
	| revisionsToDownloadMap |
	job title: 'Requesting cooking'.
	WorldMorph doOneCycle.

	revisionsToDownloadMap := (aListOfTargets collect: [ :target | target downloadFolderName -> target revisionToDownload ]) asDictionary.

	"We start by requesting the cooking of all revisions."
	revisionsToDownloadMap valuesDo: [ :revision | revision requestCooking ].

	job
		progress: 0.33;
		title: 'Waiting for Software Heritage download availability'.

	WorldMorph doOneCycle.

	"Then we wait until all revisions are ready. We could optimize by starting the download of cooked revisions directly but this will be a further optimization. Not for now."
	[ revisionsToDownloadMap values allSatisfy: [ :revision | revision isAvailableForDownload ] ] whileFalse: [
		10 seconds wait.
		revisionsToDownloadMap valuesDo: [ :revision | revision isAvailableForDownload ifFalse: [ revision checkAvailability ] ] ].
	job
		progress: 0.66;
		title: 'Downloading'.
	WorldMorph doOneCycle.
	revisionsToDownloadMap keysAndValuesDo: [ :folderName :revision |
		revision downloadInFolderNamed: folderName.
		downloadedFolders add: folderName asFileReference ] ] asJob run
]

{ #category : 'actions' }
SHImporter >> downloadAndImport: aListOfTargets [

	self download: aListOfTargets.

	self ensureVerveineJ.
	
	self generateJsonOfProjects.
	
	self importModels
]

{ #category : 'initialization' }
SHImporter >> ensureVerveineJ [

	self verveineJScript ifAbsent: [
		IceGitClone new
			location: self verveineJPath;
			url: 'https://github.com/moosetechnology/VerveineJ.git';
			execute.

		self verveineJScript ifAbsent: [ self error: 'Cannot download verveineJ.' ] ]
]

{ #category : 'actions' }
SHImporter >> generateJsonOfProjects [

	downloadedFolders
		do: [ :folder |
			LibC runCommand: ('{1} -o {2} -format json {3}' format: {
						 self verveineJScript pathString asComment.
						 (self jsonForFolder: folder).
						 folder pathString asComment }) ]
		displayingProgress: [ :folder | folder pathString ]
]

{ #category : 'actions' }
SHImporter >> importModels [

	downloadedFolders
		do: [ :folder |
			| json importer model |
			json := (self jsonForFolder: folder) asFileReference.
			importer := MiAbstractFileImporter importerFor: json.
			
			model := importer findPossibleModelClassIn: MooseModel possibleModelsToImportFromFiles forFile: json.
			1halt.
			 ]
		displayingProgress: [ :folder | folder basename ]
]

{ #category : 'initialization' }
SHImporter >> initialize [

	super initialize.
	downloadedFolders := OrderedCollection new
]

{ #category : 'actions' }
SHImporter >> jsonForFolder: folder [

	^ folder basename , '.json'
]

{ #category : 'accessing' }
SHImporter >> verveineJPath [

	^ self class verveineJPath
]

{ #category : 'accessing' }
SHImporter >> verveineJScript [
	"Manage windows later?"

	^ self verveineJPath / 'verveinej.sh'
]
