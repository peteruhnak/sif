filein
handleAnnotationsOnGlobalInitializerItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is an initializer item that needs to be processed.  I am called by the generic handler
	in order to handle the annotations on the item.
	Item attributes:
		firstToken		Global name
		value		Code to eval
	item annotations
		package-preInstallCode
		package-preUnInstallCode
		package-postInstallCode
		package-posUntInstallCode
		package-preRequisites"

	self subclassResponsibility