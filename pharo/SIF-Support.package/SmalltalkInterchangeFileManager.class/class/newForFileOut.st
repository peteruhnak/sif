instance creation
newForFileOut
	"	^	<AnsiInterchangeFileOutManager>
	Return an object capable of filing out classes, methods, packages."

	^(self defaultAt: #fileOutManager) new