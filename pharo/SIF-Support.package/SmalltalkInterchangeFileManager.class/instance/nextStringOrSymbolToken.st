streaming
nextStringOrSymbolToken
	"	^		<String> | <Symbol>
	"

	| char result |
	self skipWhiteSpace.
	self managedStream atEnd ifTrue: [^''].
	char := self managedStream next.
	char = $# ifTrue: [
		^self nextWord asSymbol].
	char = $' ifFalse: [
		self error: 'Expecting a '' or a #.'].
	result := WriteStream on: (String new: 32).
	[self managedStream atEnd] whileFalse: [
		char := self managedStream next.
		char = $'
			ifTrue: [(self managedStream peekFor: $')
				ifTrue: [result nextPut: $']
				ifFalse: [^result contents]]
			ifFalse: [result nextPut: char]].
	^result contents