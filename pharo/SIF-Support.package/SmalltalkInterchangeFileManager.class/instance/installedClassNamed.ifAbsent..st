accessing
installedClassNamed: className ifAbsent: ifAbsent
	"	className	<String>
		ifAbsent		[<Object>]
		^		<Class> | ifAbsent value
	Return the class named className."

	^Smalltalk at: className asSymbol ifAbsent: ifAbsent