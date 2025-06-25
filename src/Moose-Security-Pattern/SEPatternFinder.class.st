"
# How to use :

- SEPatternFinder applyOn: aModel
"
Class {
	#name : 'SEPatternFinder',
	#superclass : 'Object',
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'as yet unclassified' }
SEPatternFinder class >> allKnownPatterns [

	^ self class methods
		  select: [ :method | method pragmas anySatisfy: [ :pragma | pragma selector = #attackPattern ] ]
		  thenCollect: [ :method | self perform: method selector ]
]

{ #category : 'detection' }
SEPatternFinder class >> applyAllOn: aModel [

	| result |
	result := Dictionary new.
	
	self allKnownPatterns do:[:pattern | result at: pattern put: ( pattern applyOn: aModel)].
	
	^ result 
]

{ #category : 'as yet unclassified' }
SEPatternFinder class >> badAttributeValueExpExceptionPattern [
	"known on JCL-7u21"

	<attackPattern>
	^ (#readObject methodIn: { #BadAttributeValueExpException }) calling: (#toString methodIn: {  })
]

{ #category : 'as yet unclassified' }
SEPatternFinder class >> hashMapPattern1 [
	"known on JCL-7u21"

	<attackPattern>
	^ (((#readObject methodIn: { #HashMap }) calling: (#putForCreate methodIn: { #HashMap })) calling:
		   (#hash methodIn: { #HashMap })) calling: (#hashCode methodIn: {  })
]

{ #category : 'as yet unclassified' }
SEPatternFinder class >> lazyMapPattern [
	" known on commons-collections4-4.0"

	<attackPattern>
	^ ((#get methodIn: { #LazyMap }) calling: (#transform methodIn: { #ChainedTransformer })) calling:
		  (#transform methodIn: { #InvokerTransformer. #InstantiateTransformer })
]

{ #category : 'as yet unclassified' }
SEPatternFinder class >> priorityQueuePattern [
	"#known on JCL-7u21"

	<attackPattern>
	^ ((((#readObject methodIn: { #PriorityQueue }) calling: (#heapify methodIn: { #PriorityQueue }))
		    calling: (#siftDown methodIn: { #PriorityQueue })) calling:
		   (#siftDownUsingComparator methodIn: { #PriorityQueue })) calling:
		  (#compare methodIn: { #Comparator })
]

{ #category : 'as yet unclassified' }
SEPatternFinder class >> templatesImplPattern1 [
	"known on JCL-7u21"

	<attackPattern>
	^ (((((#getOutputProperties methodIn: { #TemplatesImpl }) calling:
		      (#newTransformer methodIn: { #TemplatesImpl })) calling:
		     (#getTransletInstance methodIn: { #TemplatesImpl })) calling:
		    (#newInstance methodIn: { #Class })) calling: (#newInstance0 methodIn: { #Class })) calling:
		  (#newInstance methodIn: { #Constructor })
]

{ #category : 'as yet unclassified' }
SEPatternFinder class >> templatesImplPattern2 [
	"known on JCL-7u21"

	<attackPattern>
	^ ((((#newTransformer methodIn: { #TemplatesImpl }) calling:
		     (#getTransletInstance methodIn: { #TemplatesImpl })) calling:
		    (#newInstance methodIn: { #Class })) calling: (#newInstance0 methodIn: { #Class })) calling:
		  (#newInstance methodIn: { #Constructor })
]

{ #category : 'as yet unclassified' }
SEPatternFinder class >> transformingComparatorPattern [
	"known on commons-collections-3.1"

	<attackPattern>
	^ ((#compare methodIn: { #TransformingComparator }) calling:
		   (#transform methodIn: { #ChainedTransformer })) calling:
		  (#transform methodIn: { #InstantiateTransformer })
]
