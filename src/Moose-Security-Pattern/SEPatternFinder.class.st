"
SEPatternFinder offer a collection of predefined pattern detected on ysoserial attacks, and possibilites to apply these on a given model


# How to use :

- SEPatternFinder applyAllOn: aModel

- SEPatternFinder define[...] applyOn: aModel


"
Class {
	#name : 'SEPatternFinder',
	#superclass : 'Object',
	#category : 'Moose-Security-Pattern',
	#package : 'Moose-Security-Pattern'
}

{ #category : 'pattern' }
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

{ #category : 'pattern' }
SEPatternFinder class >> defineBadAttributeValueExpExceptionPattern [
	"known on JCL-7u21"

	<attackPattern>
	^ (#readObject methodIn: { #BadAttributeValueExpException }) calling: (#toString methodIn: {  })
]

{ #category : 'pattern' }
SEPatternFinder class >> defineHashMapPattern1 [
	"known on JCL-7u21"

	<attackPattern>
	^ (((#readObject methodIn: { #HashMap }) calling: (#putForCreate methodIn: { #HashMap })) calling:
		   (#hash methodIn: { #HashMap })) calling: (#hashCode methodIn: {  })
]

{ #category : 'pattern' }
SEPatternFinder class >> defineLazyMapPattern1 [
	" known on commons-collections4-4.0"

	<attackPattern>
	^ ((#get methodIn: { #LazyMap }) calling: (#transform methodIn: { #ChainedTransformer })) calling:
		  (#transform methodIn: { #InvokerTransformer })
]

{ #category : 'pattern' }
SEPatternFinder class >> defineLazyMapPattern2 [
	" known on commons-collections4-4.0"

	<attackPattern>
	^ ((#get methodIn: { #LazyMap }) calling: (#transform methodIn: { #ChainedTransformer })) calling:
		  (#transform methodIn: { #InstantiateTransformer })
]

{ #category : 'pattern' }
SEPatternFinder class >> definePriorityQueuePattern [
	"#known on JCL-7u21"

	<attackPattern>
	^ ((((#readObject methodIn: { #PriorityQueue }) calling: (#heapify methodIn: { #PriorityQueue }))
		    calling: (#siftDown methodIn: { #PriorityQueue })) calling:
		   (#siftDownUsingComparator methodIn: { #PriorityQueue })) calling:
		  (#compare methodIn: { #Comparator })
]

{ #category : 'pattern' }
SEPatternFinder class >> defineTemplatesImplPattern1 [
	"known on JCL-7u21"

	<attackPattern>
	^ (((((#getOutputProperties methodIn: { #TemplatesImpl }) calling:
		      (#newTransformer methodIn: { #TemplatesImpl })) calling:
		     (#getTransletInstance methodIn: { #TemplatesImpl })) calling:
		    (#newInstance methodIn: { #Class })) calling: (#newInstance0 methodIn: { #Class })) calling:
		  (#newInstance methodIn: { #Constructor })
]

{ #category : 'pattern' }
SEPatternFinder class >> defineTemplatesImplPattern2 [
	"known on JCL-7u21"

	<attackPattern>
	^ ((((#newTransformer methodIn: { #TemplatesImpl }) calling:
		     (#getTransletInstance methodIn: { #TemplatesImpl })) calling:
		    (#newInstance methodIn: { #Class })) calling: (#newInstance0 methodIn: { #Class })) calling:
		  (#newInstance methodIn: { #Constructor })
]

{ #category : 'pattern' }
SEPatternFinder class >> defineTransformingComparatorPattern [
	"known on commons-collections-3.1"

	<attackPattern>
	^ ((#compare methodIn: { #TransformingComparator }) calling:
		   (#transform methodIn: { #ChainedTransformer })) calling:
		  (#transform methodIn: { #InstantiateTransformer })
]
