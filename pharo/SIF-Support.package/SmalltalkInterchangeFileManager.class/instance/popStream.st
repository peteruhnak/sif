streaming
popStream
	"	^	<Stream>
	Pop the top stream on my stream stack and return it.
	See pushStream: for more info."

	| result |
	result := streamStack removeLast.
	managedStream := streamStack isEmpty
		ifTrue: [nil]
		ifFalse: [streamStack last].
	^result