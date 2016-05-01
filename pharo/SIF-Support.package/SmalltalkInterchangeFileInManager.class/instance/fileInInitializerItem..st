filein
fileInInitializerItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is an initializer item that needs to be processed.
	Item attributes:
		firstToken		Global name
		value		Code to eval
	item annotations
		Package-PreInstallCode
		Package-PreUnInstallCode
		Package-PostInstallCode
		Package-PosUntInstallCode"


	(self uppercaseString: item firstToken) = 'GLOBAL' ifTrue: [
		self handleAnnotationsOnGlobalInitializerItem: item.
		^self evaluateDoIt: item value in: nil].
	((self
		atGlobalNamed: item firstToken
		ifAbsent: [self error: 'Encountered initializer for ', item firstToken printString, ' before it was defined.'])
			isKindOf: Behavior) ifTrue: [
				^self evaluateDoIt: item value in: nil].
	self atGlobalNamed: item firstToken put: (self evaluateDoIt: item value in: nil)