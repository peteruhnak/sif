adding
addPoolsNamed: newEntries
	"	newEntries	<Collection withAll: <String>>
		^		self
	Add all newEntries to the collection of pools that have been eplicitly specified for file out."

	newEntries do: [:each |
		self addPoolNamed: each]