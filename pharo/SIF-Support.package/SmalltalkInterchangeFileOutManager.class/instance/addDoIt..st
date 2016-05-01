adding
addDoIt: item
	"	item	<String>
		^		self
	Add item as an expression to be evaled on loading."

	self addItem: item ofType: #DoIt.