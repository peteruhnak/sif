adding
addPoolNamed: newEntry initializer: initializer
	"	newEntry	<String>
		initializer	nil | #default | <Dictionary key: varName <String> value: valueExpression <String>>
		^		self
	Add all newEntry to the collection of Pools that have been eplicitly specified for file out.
	If initializer is nil, then I will put out a default initializer that will create a pool with the
	same keys as found now, and will leave the values nil.
	If initializer is #default then I will do the same as nil, put I will also put something out
	to initialize.
	If initializer is a dictionary, then I will put out the expression for each var define in initializer.
	NOTE: The order of the pools is kept."

	self addItem: (Array with: newEntry with: initializer) ofType: #Pool.