adding
addPackagesNamed: newEntries
	"	newEntries	<Collection withAll: <String>>
		^		self
	Add all newEntries to the collection of packages that have been eplicitly specified for file out."

	newEntries do: [:each |
		self addPackageNamed: each]