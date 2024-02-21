Class {
	#name : #SHProjectExplorerByOriginOptionPresenter,
	#superclass : #SHProjectExplorerOptionPresenter,
	#category : #SoftwareHeritage
}

{ #category : #accessing }
SHProjectExplorerByOriginOptionPresenter class >> priority [

	^ 5
]

{ #category : #layout }
SHProjectExplorerByOriginOptionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  "add: (SpBoxLayout newLeftToRight
				   add: textField;
				   add: searchButton expand: false)
		  expand: false;
		  add: 'Projects' expand: false;
		  add: projectsTable;
		  add: 'Targets' expand: false;
		  add: targetsTable;
		  add: importButton expand: false;"
		  yourself
]

{ #category : #initialization }
SHProjectExplorerByOriginOptionPresenter >> titleForWindow [

	^ 'Search by origin'
]
