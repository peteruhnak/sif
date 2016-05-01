get contents
getInitializerForItemContents

	self pushStream: headerStream while: [
			"Skip initializeFor:"
		self nextWord.
		currentItem name: self nextStringOrSymbolToken].
	currentItem value: self nextChunk.