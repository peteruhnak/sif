filein
fileInVariableItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a variable definition for a pool.
	If first token is 'Global' then define a global instead of a pool variable.
	Item attributes:
		firstToken		Pool name
		name		Name of variable within pool
	item annotations"

	(self uppercaseString: item firstToken) = 'GLOBAL' ifTrue: [
		self atGlobalNamed: item name ifAbsent: [
			self atGlobalNamed: item name put: nil].
		^self].
	self declarePoolVariable: item name in: item firstToken