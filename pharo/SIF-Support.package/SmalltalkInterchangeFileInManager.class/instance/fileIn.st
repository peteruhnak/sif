filein
fileIn

	self managedStream.
	self itemsDo: [:each |
		each fileIn].
	self close.