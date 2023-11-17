Class {
	#name : #MiCallGraphVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-Security'
}

{ #category : #running }
MiCallGraphVisualization >> run [

	super run.
	builder := MiCallGraphBuilder new
		           graphModel: owner model;
		           container: self canvas;
		           yourself.
	builder build
]
