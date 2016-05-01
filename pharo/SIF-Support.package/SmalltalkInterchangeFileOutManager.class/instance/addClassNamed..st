adding
addClassNamed: newEntry
	"	newEntry	<Symbol>
		^		self
	Add all newEntry to the collection of classes that have been eplicitly specified for file out."

	| class |
	class := self installedClassNamed: newEntry.
	class isNil ifTrue: [
		self error: 'There is no such class installed in your image called: ', newEntry printString].
	self addClass: class.