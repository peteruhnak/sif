streaming
collectionOfStringsFrom: string
	"	string		<String>
		^		<OrderedCollection withAll: <String>>
	Return the collection of strings in string that was placed there by nextPutCollectionOfStrings:."

	| result |
	result := OrderedCollection new.
	self pushStream: (ReadStream on: string) while: [
		[self atEnd] whileFalse: [
			result add: self nextChunk]].
	^result