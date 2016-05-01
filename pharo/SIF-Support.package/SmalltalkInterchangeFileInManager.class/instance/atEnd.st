streaming
atEnd
	"	^	<Boolean>
	"

		"If I am the bottom most stream, the original stream being read in,
			then there is a special case for atEnd since we read ahead."
	streamStack size = 1 ifFalse: [
		^self managedStream atEnd].
	^self managedStream atEnd and: [nextItem isNil]