streaming
nextWord
	"	^			<String> | nil
	Return the next word found on my managed stream.  If I reach the end of the stream before
	finding a word, then return nil.
	I skip any current whitespcae, start collecting, and stop at the first white space."

	"| s m |
	s := ReadStream on: 'hello world'.
	m := SmalltalkInterchangePharoFileInManager new.
	m nextWordOn: s.
	m nextWordOn: s"

	| result done next |
	self skipWhiteSpace.
	done := false.
	result := WriteStream on: (String new: 32).
	[self atEnd or: [done]] whileFalse: [
		next := self managedStream next.
		next isSeparator
			ifTrue: [
				done := true.
				self managedStream skip: -1]
			ifFalse: [result nextPut: next]].
	result size = 0 ifTrue: [
		^nil].
	^result contents