get contents
getVariableItemContents

	self pushStream: headerStream while: [
			"Skip variable:"
		self nextWord.
		currentItem name: self nextStringOrSymbolToken].