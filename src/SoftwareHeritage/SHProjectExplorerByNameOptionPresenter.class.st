Class {
	#name : #SHProjectExplorerByNameOptionPresenter,
	#superclass : #SHProjectExplorerOptionPresenter,
	#instVars : [
		'textField',
		'searchButton',
		'importButton',
		'targetsTable',
		'projectsList'
	],
	#category : #SoftwareHeritage
}

{ #category : #initialization }
SHProjectExplorerByNameOptionPresenter >> connectPresenters [

	searchButton action: [ self updateListWithSearchPattern ].

	projectsList transmitTo: targetsTable transform: [ :project | project ifNotNil: [ project targets ] ].

	importButton action: [ projectsList selection selectedItem halt ]
]

{ #category : #layout }
SHProjectExplorerByNameOptionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: textField;
				   add: searchButton expand: false)
		  expand: false;
		  add: projectsList;
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

	projectsList := self newList
		                display: [ :project | project url ];
		                whenSelectionChangedDo: [ :selection | importButton enabled: selection isEmpty not ].

	targetsTable := self newTable
		                addColumn: (SpStringTableColumn title: 'Kind' evaluated: #kind);
		                addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
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

	^ projectsList items: (SHProject projectsFromSearchPattern: textField text)
]
