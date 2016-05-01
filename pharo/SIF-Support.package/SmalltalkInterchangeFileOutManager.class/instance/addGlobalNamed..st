adding
addGlobalNamed: newEntry
	"	newEntry	<String>
		^		self
	Add all newEntry to the collection of Globals that have been eplicitly specified for file out."

	self addGlobalNamed: newEntry initializer: nil.
