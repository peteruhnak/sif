declaring
declarePool: name
	"	name		<String>
		^	void
	Declare a Pool named name"

	self atGlobalNamed: name ifAbsent: [
		self atGlobalNamed: name put: Dictionary new]