streaming
nextChunk

	| result |
	result := self upTo: $!.
	(self peekFor: $!) ifFalse: [^result].
	result := (WriteStream on: (String new: result size + 128))
		nextPutAll: result;
		nextPut: $!;
		yourself.
	[self atEnd] whileFalse: [
		result nextPutAll: (self upTo: $!).
		(self peekFor: $!) ifFalse: [
			^result contents].
		result nextPut: $!].
	self skipWhiteSpace.
	^result contents