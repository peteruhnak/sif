fileout
fileOutItems
	"	^	self
	File out whatever code the user has specified for me to do."

	self addedItems do: [:each |
		self perform: (fileOutInfoByType at: each last) with: each first].