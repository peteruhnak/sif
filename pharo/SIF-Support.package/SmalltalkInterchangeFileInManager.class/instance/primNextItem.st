item
primNextItem
	"	void
	Set my currentItem to be the next item, including annotations, I find on my stream.
	I also set my currentItem to be this item."

	| firstToken position secondToken |
	headerStream := self pushStream: (ReadStream on: self nextChunk).
	self skipWhiteSpace.
	(self peekFor: $")
		ifTrue: [
			firstToken := '"']
		ifFalse: [
			firstToken := self nextWord].
	firstToken isNil ifTrue: [
		self popStream.
		^currentItem := nil].
	currentItem := self newItem.
	position := headerStream position.
	secondToken := self nextWord.
	headerStream position: position.
		"We check for the second token, since we could have a global, or class
			by the same name as the special first tokens of the standard."
	secondToken notNil ifTrue: [
		currentItem info: (itemInfoBySecondToken at: (self uppercaseString: secondToken) ifAbsent: [nil])].
	currentItem info isNil ifTrue: [
		currentItem info: (itemInfoByFirstToken at: (self uppercaseString: firstToken) ifAbsent: [nil])].
	currentItem info isNil ifTrue: [
		self error: 'Expecting one of ...'].
	self popStream.
	currentItem firstToken: firstToken;
		getContents