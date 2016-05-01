get contents
getAnnotationItemContents

	| keyword |
	self pushStream: headerStream while: [
		#(
			#('KEY:' #name:)
			#('VALUE:' #value:)
		) do: [:pair |
			keyword := self nextWord.
			(self uppercaseString: keyword) = (pair at: 1) ifFalse: [
				self error: 'Expecting ', (pair at: 1)].
			currentItem perform: (pair at: 2) with: self nextStringOrSymbolToken]].