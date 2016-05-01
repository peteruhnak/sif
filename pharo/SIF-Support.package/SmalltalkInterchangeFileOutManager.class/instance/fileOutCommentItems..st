fileout
fileOutCommentItems: items
	"	items		<OrderedCollection withAll: <String>>
		^		void
	File out the comments in items."

	items do: [:each |
		self cr;
			nextPut: $";
			nextChunkablePut: each;
			nextPut: $";
			nextChunkPut: ''.].