instance creation
newForFileIn
	"	^	<AnsiInterchangeFileInManager>
	Return an object capable of filing in an interchange file with classes, methods, packages."

	^(self defaultAt: #fileInManager) new