adding
addPackages: newEntries
	"	newEntries	<Collection withAll: <Dictionary key: <Symbol> value: <Object>
		^		self
	Add newEntries to the collection of packages that have been eplicitly specified for file out.
	See packageItemInfoForPackageNamed: for info on what what each entry should be."

	self addItems: newEntries ofType: #Package.