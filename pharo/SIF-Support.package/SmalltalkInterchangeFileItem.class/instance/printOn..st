printing
printOn: stream

	super printOn: stream.
	stream nextPutAll: '('.
	self attributesToPrint do: [:each |
		(self perform: each) isNil ifFalse: [
			stream cr; tab; nextPutAll: each; nextPutAll: ': '.
			(self perform: each) printOn: stream]].
	stream nextPut: $)