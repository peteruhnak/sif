filein
fileInMethodItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a method item that needs to be processed.
	NOTE: If item does not have a packahe annotation, I will place the
		method into the same package as the class of item.
	Item attributes:
		firstToken		Class name
		value		Source string
	item annotations
		category
		categories
		package"


	self fileInMethodItem: item intoClass: (self installedClassNamed: item firstToken)