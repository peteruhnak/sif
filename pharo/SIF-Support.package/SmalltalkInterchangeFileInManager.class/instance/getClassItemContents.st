get contents
getClassItemContents

	| keyword |
	self pushStream: headerStream while: [
		#(
			#('named:' #name:)
			#('superclass:' #superclassName:)
			#('indexedInstanceVariables:' #instVarType:)
			#('instanceVariableNames:' #instVarNames:)
			#('classVariableNames:' #classVarNames:)
			#('sharedPools:' #sharedPoolNames:)
			#('classInstanceVariableNames:' #classInstVarNames:)
		) do: [:pair |
			keyword := self nextWord.
			(self uppercaseString: keyword) = (self uppercaseString: (pair at: 1)) ifFalse: [
				self error: 'Expecting ....'].
			currentItem perform: (pair at: 2) with: self nextStringOrSymbolToken]].