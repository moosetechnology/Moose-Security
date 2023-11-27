Class {
	#name : #MiCallGraphSettingsPresenter,
	#superclass : #MiSettingsPresenter,
	#category : #'MooseIDE-Security'
}

{ #category : #initialization }
MiCallGraphSettingsPresenter >> initialize [

	super initialize.

	self
		addItem: (MiCheckboxSettingItem new
				 setValue: true;
				 label: 'Include stubs';
				 help: 'Set if the call graph should include stub methods';
				 yourself)
		named: #includeStubs
]
