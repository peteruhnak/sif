initializing
initializeForVersion10Extended
	"	self
	Initialize myself to be ready to read a Version 1.0 extended file."

	self initializeForVersion10.
	itemInfoByFirstToken at: 'PACKAGE' put: #(#package #getPackageItemContents #fileInPackageItem:).