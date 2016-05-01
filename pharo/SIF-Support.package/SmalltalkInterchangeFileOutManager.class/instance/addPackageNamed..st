adding
addPackageNamed: newEntry
	"	newEntry	<String>
		^		self
	Add newEntry to the collection of packages that have been eplicitly specified for file out."

	self addPackage: (self packageItemInfoFor: newEntry).