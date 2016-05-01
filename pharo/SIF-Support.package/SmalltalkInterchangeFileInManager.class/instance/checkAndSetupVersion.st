item
checkAndSetupVersion
	"	^	self
	Read the first item on the file and make sure that it is a version marker and that I support this version.
	I will also set myself up to be able to read in something of whatever version is identified.
	If any of my checks fail, I will cause an error and not return."

	| read write selector next |
	currentItem isSmalltalkItem ifFalse: [
		self error: 'File MUST start with a Smalltalk version: ''1.0'' type of item.'].
	read := ReadStream on: currentItem value.
	write := WriteStream on: (String new: 32).
	write nextPutAll: 'initializeForVersion'.
	[read atEnd] whileFalse: [
		(next := read next) isAlphaNumeric ifTrue: [
			write nextPut: next]].
	selector := write contents asSymbol.
	(self respondsTo: selector) ifFalse: [
		self error: 'I do not support version ', currentItem value printString].
	self perform: selector.
	isSmalltalkItemProcessed := true