Class {
	#name : #SHProjectExplorerByNameOptionPresenter,
	#superclass : #SHProjectExplorerOptionPresenter,
	#instVars : [
		'textField',
		'searchButton',
		'importButton',
		'targetsTable',
		'projectsTable',
		'selectedTargets'
	],
	#category : #SoftwareHeritage
}

{ #category : #accessing }
SHProjectExplorerByNameOptionPresenter class >> priority [

	^ 1
]

{ #category : #initialization }
SHProjectExplorerByNameOptionPresenter >> connectPresenters [

	searchButton action: [ self updateListWithSearchPattern ].

	projectsTable
		transmitTo: targetsTable
		transform: [ :project |
			selectedTargets := OrderedCollection new.
			project
				ifNil: [ #(  ) ]
				ifNotNil: [ project targets ] ]
		postTransmission: [ :destination | destination selectFirst ].

	importButton action: [ self downloadAllSelected ]
]

{ #category : #layout }
SHProjectExplorerByNameOptionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: textField;
				   add: searchButton expand: false)
		  expand: false;
		  add: 'Projects' expand: false;
		  add: projectsTable;
		  add: 'Targets' expand: false;
		  add: targetsTable;
		  add: importButton expand: false;
		  yourself
]

{ #category : #actions }
SHProjectExplorerByNameOptionPresenter >> downloadAllSelected [

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
		5 seconds wait.
		revisionsToDownloadMap valuesDo: [ :revision | revision isAvailableForDownload ifFalse: [ revision checkAvailability ] ] ].
	job
		progress: 0.66;
		title: 'Downloading'.
	WorldMorph doOneCycle.
	revisionsToDownloadMap keysAndValuesDo: [ :folderName :revision | revision downloadInFolderNamed: folderName ].

	'.' asFileReference openInOSFileBrowser ] asJob run
]

{ #category : #initialization }
SHProjectExplorerByNameOptionPresenter >> initializePresenters [

	super initializePresenters.
	textField := self newTextInput
		             placeholder: 'Search string';
		             whenTextChangedDo: [ :text | searchButton enabled: text isNotEmpty ];
		             whenSubmitDo: [ :text | self updateListWithSearchPattern ];
		             yourself.

	searchButton := self newButton
		                label: 'Search';
		                disable;
		                yourself.

	projectsTable := self newTable
		                 addColumn: ((SpStringTableColumn title: 'Kind' evaluated: #kind)
				                  width: 60;
				                  yourself);
		                 addColumn: (SpStringTableColumn title: 'Origin' evaluated: #url).

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

{ #category : #initialization }
SHProjectExplorerByNameOptionPresenter >> titleForWindow [

	^ 'Search by name'
]

{ #category : #initialization }
SHProjectExplorerByNameOptionPresenter >> updateListWithSearchPattern [

	(SHProject projectsFromSearchPattern: textField text) ifNotEmpty: [ :projects |
		projectsTable
			items: projects;
			selectFirst ]
]
