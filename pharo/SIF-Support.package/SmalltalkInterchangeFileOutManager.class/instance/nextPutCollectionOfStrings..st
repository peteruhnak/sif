streaming
nextPutCollectionOfStrings: strings
	"	strings	<Collection withAll: <String>>
		^		void
	Place a string which when read back can yield a collection of strings."

	self pushStream: (WriteStream on: (String new: 32)).
	strings do: [:each |
		self nextChunkPut: each].
	self nextChunkablePut: self popStream contents printString