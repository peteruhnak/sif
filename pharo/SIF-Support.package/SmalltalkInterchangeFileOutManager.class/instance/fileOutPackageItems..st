fileout
fileOutPackageItems: items
	"	items		<OrderedCollection withAll: <Array with: name <String> with: initializer <String> | nil>
		^		void
	File out the globals in items."

	items do: [:each |
		self fileOutPackageItem: each].
	self cr.