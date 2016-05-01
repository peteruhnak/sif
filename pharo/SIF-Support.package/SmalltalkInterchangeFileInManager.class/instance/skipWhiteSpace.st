streaming
skipWhiteSpace
	"	stream	<ReadStream on: <String>>
		^	void
	Skip any carriage returns, tabs, spaces anything that is a spacing character."

	self managedStream skipSeparators