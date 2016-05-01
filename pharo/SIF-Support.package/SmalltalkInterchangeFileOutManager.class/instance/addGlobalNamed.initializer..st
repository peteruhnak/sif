adding
addGlobalNamed: newEntry initializer: initializer
	"	newEntry	<String>
		initializer	nil | #default | <String>
		^		self
	Add all newEntry to the collection of Globals that have been eplicitly specified for file out.
	initializer is a chunk of code to build the Global, this code will be evaled at file in time.
	If initializer is nil, then I rill just allocate the global.  #default I will place the printString
	of it's current value.  If it's a string then use this as the init expression.
	NOTE: The order of the Globals is kept."

	self addItem: (Array with: newEntry with: initializer) ofType: #Global.