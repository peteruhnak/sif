item
newItem
	"	^	<SmalltalkInterchangeFileItem>
	Return a fresh new instance of an item."

	^SmalltalkInterchangeFileItem new
		manager: self;
		yourself