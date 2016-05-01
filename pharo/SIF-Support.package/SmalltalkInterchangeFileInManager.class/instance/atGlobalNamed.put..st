accessing
atGlobalNamed: name put: value
	"	name	<String>
		value	<Object>
		^	void
	Set the value of the global named name to value."

	Smalltalk at: name asSymbol put: value