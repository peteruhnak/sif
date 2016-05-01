streaming
newStreamOnFileNamed: file
	"	file	<String>
		^	<WriteStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	^FileStream newFileNamed: file