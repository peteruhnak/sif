filein
fileInClassItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a class item that needs to be processed.
	Item attributes:
		name				<String> 'named:'
		superclassName		<String> 'superclass:'
		instVarType		#none | #byte | #object 'indexedInstanceVariables:'
		instVarNames		<String>'instanceVariableNames:'
		classVarNames		<String> 'classVariableNames:'
		sharedPoolNames	<String> 'sharedPools:'
		classInstVarNames	<String> 'classInstanceVariableNames:'
	item annotations
		package
	"

	self subclassResponsibility