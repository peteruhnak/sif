filein
fileInPoolItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a declaration for a Pool item that needs to be processed.
	Item attributes:
		firstToken		'Pool'
		name			Name of the pool
	item annotations"


	self declarePool: item name