adding
addClasses: items
	"	items		<Collection withAll: <Behavior>>
		^		self
	Add each of the classes in items as a class to be filed out.
	Keep the order of items."

	self addItems: items ofType: #Class.