fileout info
methodItemsForClass: class
	"	class		<Behavior>
		^		<Collection withAll: <Array with: <Symbol> with: <Behavior>>>
	"

	| methods |
	methods := OrderedCollection new: 64.
	class selectors do: [:each |
		methods add: (Array with: each with: class)].
	class class selectors do: [:each |
		methods add: (Array with: each with: class class)].
	^methods
