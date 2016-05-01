fileout
fileOutClassItems: items
	"	items	<OrderedCollection withAll: <Class>>
		^		void
	File out the classes in items."

	| selector methods |
	self fileOutClassDefinitionsFor: items.
	methods := OrderedCollection new: 64.
	items do: [:each |
		methods addAll: (self methodItemsForClass: each)].
	methods := self fileOutMethodItems: methods.
	methods do: [:each |
		self fileOutInitializer: (self nameForClass: each last), ' ', each first forName: (self nameForClass: each last)].