accessing
nameForClass: class
	"	class		<Behavior>
		^		<String>
	Return the name of class."

	^(self classOfBehavior: class) name