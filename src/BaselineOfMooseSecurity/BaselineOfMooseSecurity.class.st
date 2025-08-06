Class {
	#name : 'BaselineOfMooseSecurity',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMooseSecurity',
	#package : 'BaselineOfMooseSecurity'
}

{ #category : 'baselines' }
BaselineOfMooseSecurity >> baseline: spec [

	<baseline>
	spec for: #common do: [
			self famixDiff: spec.

			spec
				package: 'Moose-Security' with: [ spec requires: #( 'FamixDiff' ) ];
				package: 'Moose-Security-Tests' with: [ spec requires: #( 'Moose-Security' ) ];
				package: 'Moose-Security-Pattern' with: [ spec requires: #( 'Moose-Security' ) ];
				package: 'Moose-Security-Pattern-Tests' with: [ spec requires: #( 'Moose-Security-Pattern' ) ] ]
]

{ #category : 'dependencies' }
BaselineOfMooseSecurity >> famixDiff: spec [

	spec baseline: 'FamixDiff' with: [ spec repository: 'github://moosetechnology/FamixDiff:master/src' ]
]
