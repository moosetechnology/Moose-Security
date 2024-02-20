Class {
	#name : #SHProjectExplorerByNameOptionPresenter,
	#superclass : #SHProjectExplorerOptionPresenter,
	#instVars : [
		'textField',
		'searchButton',
		'importButton',
		'targetsTable',
		'projectsTable'
	],
	#category : #SoftwareHeritage
}

{ #category : #initialization }
SHProjectExplorerByNameOptionPresenter >> connectPresenters [

	searchButton action: [ self updateListWithSearchPattern ].

	projectsTable
		transmitTo: targetsTable
		transform: [ :project |
			project
				ifNil: [ #(  ) ]
				ifNotNil: [ project targets ] ]
		postTransmission: [ :destination | destination selectFirst ].

	importButton action: [ projectsTable selection selectedItem halt ]
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
