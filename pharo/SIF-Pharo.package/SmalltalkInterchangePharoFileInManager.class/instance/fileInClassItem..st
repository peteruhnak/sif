file in
fileInClassItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a class item that needs to be processed.
	Item attributes:
	Item attributes:
		name				<String> 'named:'
		superclassName		<String> 'superclass:'
		instVarType			#none | #byte | #object 'indexedInstanceVariables:'
		instVarNames		<String>'instanceVariableNames:'
		classVarNames		<String> 'classVariableNames:'
		sharedPoolNames	<String> 'sharedPools:'
		classInstVarNames	<String> 'classInstanceVariableNames:'
	item annotations
		package
	"

	| result package |
	item instVarType == #none ifFalse: [
		item instVarType == #byte ifTrue: [].
		item instVarType == #object ifTrue: [].
		self error: 'Have not added support for variable subclasses yet'].
	package := (package := item packageAnnotation) isNil
		ifTrue: ['None Specified-SIF']
		ifFalse: [package value].
	result := (Smalltalk at: item superclassName asSymbol)
		subclass: item name asSymbol
		instanceVariableNames: item instVarNames
		classVariableNames: item classVarNames
		poolDictionaries: item sharedPoolNames
		category: package.
	result class instanceVariableNames: item classInstVarNames.
