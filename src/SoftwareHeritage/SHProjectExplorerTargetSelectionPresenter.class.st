Class {
	#name : #SHProjectExplorerTargetSelectionPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'importButton',
		'targetsTable',
		'selectedTargets'
	],
	#category : #SoftwareHeritage
}

{ #category : #initialization }
SHProjectExplorerTargetSelectionPresenter >> connectPresenters [

	importButton action: [ self downloadAllSelected ]
]

{ #category : #layout }
SHProjectExplorerTargetSelectionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Targets' expand: false;
		  add: targetsTable;
		  add: importButton expand: false;
		  yourself
]

{ #category : #actions }
SHProjectExplorerTargetSelectionPresenter >> downloadAllSelected [

	[ :job |
	| revisionsToDownloadMap |
	job title: 'Requesting cooking'.
	WorldMorph doOneCycle.

	revisionsToDownloadMap := (selectedTargets collect: [ :target | target downloadFolderName -> target revisionToDownload ]) asDictionary.

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

{ #category : #accessing }
SHProjectExplorerTargetSelectionPresenter >> forProject: aProject [

	selectedTargets := OrderedCollection new.
	targetsTable
		items: (aProject
				 ifNil: [ #(  ) ]
				 ifNotNil: [ aProject targets ]);
		selectFirst
]

{ #category : #initialization }
SHProjectExplorerTargetSelectionPresenter >> initializePresenters [

	super initializePresenters.

	targetsTable := self newTable
		                addColumn: ((SpCheckBoxTableColumn evaluated: [ :target | selectedTargets includes: target ])
				                 onActivation: [ :target | selectedTargets add: target ];
				                 onDeactivation: [ :target | selectedTargets remove: target ];
				                 width: 20);
		                addColumn: (SpImageTableColumn new
				                 evaluated: [ :project | self iconNamed: project iconName ];
				                 beNotExpandable;
				                 width: 20;
				                 yourself);
		                addColumn: ((SpStringTableColumn title: 'Kind' evaluated: #kind)
				                 width: 80;
				                 yourself);
		                addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		                whenSelectionChangedDo: [ :selection | importButton enabled: selection isEmpty not ];
		                yourself.

	importButton := self newButton
		                label: 'Import';
		                disable;
		                yourself
]
