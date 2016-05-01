initializing
initialize
	"	self
	Initialize myself to be ready to read a file"

	super initialize.
	isSmalltalkItemProcessed := false.
	itemInfoByFirstToken := Dictionary new
		at: 'SMALLTALK' put: #(#smalltalk #getSmalltalkItemContents #fileInSmalltalkItem:);
		yourself.
	itemInfoBySecondToken := Dictionary new
		yourself.