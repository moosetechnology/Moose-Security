Class {
	#name : 'SESerialisationPatternsTagger',
	#superclass : 'SEVulnerabilityTagger',
	#category : 'Moose-Security',
	#package : 'Moose-Security'
}

{ #category : 'adding' }
SESerialisationPatternsTagger class >> addMethodNameTaggersTo: taggers [

	"<cautionTagger>
	#( #''org::apache::commons::collections::map::LazyMap.get(Object)'' #getOutputProperties #getTransletInstance
	   #newOutputStream #newTransformer #readAllBytes #readExternal
	   #readLine #readObject #transform ) do: [ :methodName |
		taggers add: (self tagResultOf: [ :model :tagger |
				 tagger methodsNamed: methodName in: model ]) ]"
]
