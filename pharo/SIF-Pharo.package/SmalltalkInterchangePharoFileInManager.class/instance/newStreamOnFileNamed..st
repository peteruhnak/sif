streaming
newStreamOnFileNamed: file
	"	file	<String>
		^	<ReadStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	(FileStream isAFileNamed: self fileName) ifFalse: [
		self error: 'Non-existent file named: ', self fileName printString].
	^FileStream readOnlyFileNamed: self fileName