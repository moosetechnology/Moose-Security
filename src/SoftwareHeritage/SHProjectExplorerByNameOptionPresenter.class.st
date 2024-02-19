Class {
	#name : #SHProjectExplorerByNameOptionPresenter,
	#superclass : #SHProjectExplorerOptionPresenter,
	#instVars : [
		'textField',
		'searchButton',
		'list',
		'importButton'
	],
	#category : #SoftwareHeritage
}

{ #category : #initialization }
SHProjectExplorerByNameOptionPresenter >> connectPresenters [

	searchButton action: [ self updateListWithSearchPattern ].
	importButton action: [ list selection selectedItem halt]
]

{ #category : #layout }
SHProjectExplorerByNameOptionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: textField;
				   add: searchButton expand: false)
		  expand: false;
		  add: list;
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

	list := self newList
		        display: [ :project | project url ];
		        whenSelectionChangedDo: [ :selection | importButton enabled: selection isEmpty not ].

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

	^ list items: (SHProject projectsFromSearchPattern: textField text)
]
