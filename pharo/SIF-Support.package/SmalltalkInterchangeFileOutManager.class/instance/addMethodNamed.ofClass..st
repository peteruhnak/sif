adding
addMethodNamed: entry ofClass: class
	"	entry		<Symbol>
		class		<Behavior>
		^		self
	Add all newEntries to the collection of methods that have been eplicitly specified for file out."

	self addItem: (Array with: entry with: class) ofType: #Method.