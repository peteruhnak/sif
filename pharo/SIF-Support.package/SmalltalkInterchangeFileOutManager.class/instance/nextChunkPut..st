streaming
nextChunkPut: chunk
	"	chunk	<String>
	Add the contents of chunk to my stream to use.  Chunking means to end with a single !.  IF there are any embedded !s, they will doubled up."

	self nextChunkablePut: chunk;
		nextPut: $!