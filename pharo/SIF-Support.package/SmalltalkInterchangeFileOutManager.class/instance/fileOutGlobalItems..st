fileout
fileOutGlobalItems: items
	"	items		<OrderedCollection withAll: <Array with: name <String> with: initializer <String> | nil>
		^		void
	File out the globals in items."

	| initializer |
	items do: [:each |
		self cr;
			nextPutAll: 'Global variable: ';
			nextQuotedPutString: each first;
			nextChunkPut: ''].
	self cr.
	items do: [:each | each last isNil ifFalse: [
		initializer := each last == #default
			ifTrue: [(self globalNamed: each first) printString]
			ifFalse: [each last].
		self fileOutInitializer: initializer forName: each first]].