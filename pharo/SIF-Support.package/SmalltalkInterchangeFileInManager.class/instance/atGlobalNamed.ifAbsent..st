accessing
atGlobalNamed: name ifAbsent: ifAbsent
	"	name	<String>
		ifAbsent	[<Object>]
		^	<Object> | ifAbsent value
	Return the value in global named name.  If its not there return the result of ifAbsent."

	^Smalltalk at: name asSymbol ifAbsent: ifAbsent