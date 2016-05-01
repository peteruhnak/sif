accessing
installedClassNamed: className
	"	className	<String>
		^		<Class> | nil
	Return the class named className."

	^self installedClassNamed: className ifAbsent: [nil]