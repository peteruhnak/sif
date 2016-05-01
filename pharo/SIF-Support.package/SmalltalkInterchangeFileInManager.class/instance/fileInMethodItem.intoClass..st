filein
fileInMethodItem: item intoClass: class
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a smalltalk item that needs to be processed.
	Item attributes:
		firstToken		Class name
		value		Source string
	item annotations
		category
		categories
		package"

	self subclassResponsibility