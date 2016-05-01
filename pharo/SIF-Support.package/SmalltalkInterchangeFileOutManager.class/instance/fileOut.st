fileout
fileOut
	"	^	self
	File out whatever code the user has specified for me to do."

	self nextPutAll: 'Smalltalk interchangeVersion: ';
		nextQuotedPutString: versionString;
		nextChunkPut: '';
		cr;
		cr.
	self fileOutItems;
		close