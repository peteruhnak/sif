get contents
getPoolItemContents

	self pushStream: headerStream while: [
			"Skip named:"
		self nextWord.
		currentItem name: self nextStringOrSymbolToken].