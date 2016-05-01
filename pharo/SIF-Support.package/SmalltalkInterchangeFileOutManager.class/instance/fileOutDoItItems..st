fileout
fileOutDoItItems: items
	"	items		<OrderedCollection withAll: <String>>
		^		void
	File out the doIts in items."

	self cr.
	items do: [:each |
		self fileOutInitializer: each last forName: 'Global'].