Class {
	#name : 'SEKnownPattern',
	#superclass : 'SEPattern',
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'as yet unclassified' }
SEKnownPattern class >> allKnownPatterns [

	| result |
	result := Set new.

	"#1, known on commons-collections-3.1"
	result add: (((#compare methodIn: { #TransformingComparator }) calling:
			  (#transform methodIn: { #ChainedTransformer })) calling:
			 (#transform methodIn: { #InstantiateTransformer })).

	"#2, known on commons-collections4-4.0"
	result add:
		(((#get methodIn: { #LazyMap }) calling: (#transform methodIn: { #ChainedTransformer })) calling:
			 (#transform methodIn: { #InvokerTransformer. #InstantiateTransformer })).

	"#3, known on JCL-7u21"
	result add:
		(((((#readObject methodIn: { #PriorityQueue }) calling: (#heapify methodIn: { #PriorityQueue }))
			   calling: (#siftDown methodIn: { #PriorityQueue })) calling:
			  (#siftDownUsingComparator methodIn: { #PriorityQueue })) calling:
			 (#compare methodIn: { #Comparator })).

	"#4, known on JCL-7u21"
	result add: ((((((#getOutputProperties methodIn: { #TemplatesImpl }) calling:
			     (#newTransformer methodIn: { #TemplatesImpl })) calling:
			    (#getTransletInstance methodIn: { #TemplatesImpl })) calling:
			   (#newInstance methodIn: { #Class })) calling: (#newInstance0 methodIn: { #Class })) calling:
			 (#newInstance methodIn: { #Constructor })).

	"#5, known on JCL-7u21"
	result add: (((((#newTransformer methodIn: { #TemplatesImpl }) calling:
			    (#getTransletInstance methodIn: { #TemplatesImpl })) calling:
			   (#newInstance methodIn: { #Class })) calling: (#newInstance0 methodIn: { #Class })) calling:
			 (#newInstance methodIn: { #Constructor })).

	"#6, known on JCL-7u21"
	result add:
		((#readObject methodIn: { #BadAttributeValueException }) calling: (#toString methodIn: {  })).

	"#7, known on JCL-7u21"
	result add:
		((((#readObject methodIn: { #HashMap }) calling: (#putForCreate methodIn: { #HashMap })) calling:
			  (#hash methodIn: { #HashMap })) calling: #hashCode methodInAll).



	^ result
]

{ #category : 'instance creation' }
SEKnownPattern class >> applyOn: aModel [
	^ self allKnownPatterns flatCollect:[:pattern | pattern applyOn: aModel].
]
