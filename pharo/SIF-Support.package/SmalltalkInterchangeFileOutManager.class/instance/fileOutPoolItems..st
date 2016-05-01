fileout
fileOutPoolItems: items
	"	items		<OrderedCollection withAll: <Array with: name <String> with: initializer <String> | nil>
		^		void
	File out the globals in items."

	items do: [:each | self
		fileOutPoolDefinitionFor: (self poolNamed: each first)
		named: each first
		initializer: each last].