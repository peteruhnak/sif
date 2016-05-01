adding
addGlobalsNamed: newEntries
	"	newEntries	<Collection withAll: <String>>
		^		self
	Add all newEntries to the collection of Globals that have been eplicitly specified for file out."

	newEntries do: [:each |
		self addGlobalNamed: each]