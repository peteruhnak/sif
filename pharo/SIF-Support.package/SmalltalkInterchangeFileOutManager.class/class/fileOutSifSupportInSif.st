fileout
fileOutSifSupportInSif
	"	^	self
	File out the basic SIF support in SIF format."
	"
	SmalltalkInterchangeFileOutManager fileOutSifSupportInSif
	"

	SmalltalkInterchangeFileManager newForFileOut
		fileName: 'sif-support.sif';
		addPackageNamed: 'SIF-Support';
		fileOut;
		close