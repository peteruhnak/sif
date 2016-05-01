get contents
getSmalltalkItemContents

	self pushStream: headerStream while: [
			"Skip version:"
		self nextWord.
		currentItem value: self nextStringOrSymbolToken]