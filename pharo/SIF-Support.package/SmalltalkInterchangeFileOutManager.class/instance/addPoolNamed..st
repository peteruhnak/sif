adding
addPoolNamed: newEntry
	"	newEntry	<String>
		^		self
	Add all newEntry to the collection of Pools that have been eplicitly specified for file out.
	I will define each of the keys in new entry with no initializer."

	self addPoolNamed: newEntry initializer: nil