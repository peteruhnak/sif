fileout info
initializerSelectorForClass: class
	"	class		<Behavior>
		^		<Symbol> | nil
	Return the method to invoke in order to initialize class on file in.
	Return nil if there is to be none."

	((self classOfBehavior: class) class includesSelector: #initialize) ifTrue: [
		^#initialize].
	^nil