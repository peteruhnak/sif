adding
addClassesNamed: items
	"	items	<Collection withAll: <Symbol>>
		^		self
	Add the class corresponding to each name in items to be filed out.."

	items do: [:each | self addClassNamed: each].