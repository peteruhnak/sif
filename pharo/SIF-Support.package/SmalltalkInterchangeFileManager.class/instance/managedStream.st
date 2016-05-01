streaming
managedStream
	"	^	<ReadStream on: <String>>
	Retur the stream to use to read or write text from.  If the user has specified the stream then
	return it.  If the user has not specified the stream, then I assume that a filename has been
	specified and I will return a stream open on this file."

	managedStream isNil ifFalse: [
		^managedStream].
	self fileName isNil ifFalse: [
		^self pushStream: (self newStreamOnFileNamed: self fileName)].
	self error: 'Must specify either a stream or a fileName'