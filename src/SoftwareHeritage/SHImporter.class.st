Class {
	#name : #SHImporter,
	#superclass : #Object,
	#classVars : [
		'VerveineJPath'
	],
	#category : #SoftwareHeritage
}

{ #category : #actions }
SHImporter class >> downloadAndImport: aListOfTargets [

	^ self new downloadAndImport: aListOfTargets
]

{ #category : #settings }
SHImporter class >> softwareHeritageSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #verveineJPath)
		target: self;
		parent: #SoftwareHeritage;
		type: #FilePathEncoder;
		label: 'VerveineJ path';
		description: 'If you wish to use your own version of verveineJ you can specify your own path to it..'
]

{ #category : #accessing }
SHImporter class >> verveineJPath [

	^ VerveineJPath
]

{ #category : #accessing }
SHImporter class >> verveineJPath: anObject [

	VerveineJPath := anObject
]

{ #category : #actions }
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
	revisionsToDownloadMap keysAndValuesDo: [ :folderName :revision | revision downloadInFolderNamed: folderName ].

	'.' asFileReference openInOSFileBrowser ] asJob run
]

{ #category : #actions }
SHImporter >> downloadAndImport: aListOfTargets [

	self download: aListOfTargets.

	self ensureVerveineJ
]

{ #category : #initialization }
SHImporter >> ensureVerveineJ [
	
]
