Class {
	#name : #BaselineOfMooseSecurity,
	#superclass : #BaselineOf,
	#category : #BaselineOfMooseSecurity
}

{ #category : #baselines }
BaselineOfMooseSecurity >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'Moose-Security';
			package: 'MooseIDE-Security';
			package: 'SoftwareHeritage' ]
]
