accessing
installedMetaclassNamed: className
	"	className	<String>
		^		<Metaclass>
	Return the metaclass named className."

	^(self installedClassNamed: className) class