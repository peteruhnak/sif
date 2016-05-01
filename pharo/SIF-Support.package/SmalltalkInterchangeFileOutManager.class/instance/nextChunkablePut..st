streaming
nextChunkablePut: chunk
	"	chunk	<String>
	Add the contents of chunk to my stream to use.
	Make sure that nextChunk functionality is kept, meaning that
	yf there are any embedded !s, they will doubled up."

	(chunk includes: $!)
		ifTrue: [
			chunk do: [ :character |
				self managedStream nextPut: character.
				character == $! ifTrue: [self managedStream nextPut: $!]]]
		ifFalse: [
			self managedStream nextPutAll: chunk].