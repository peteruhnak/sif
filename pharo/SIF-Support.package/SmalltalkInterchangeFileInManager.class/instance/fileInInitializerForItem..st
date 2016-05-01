filein
fileInInitializerForItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is an initializer item that needs to be processed.
	Item attributes:
		type		#initializerFor
		firstToken	Name of the pool dictionary
		name		Name of the pool variable
		value		Code to eval the value
	item annotations
		"
	(self atGlobalNamed: item firstToken ifAbsent: [self error: 'No pool has been declared by the name of ', item firstToken printString])
		at: item name
		put: (self evaluateDoIt: item value in: nil)