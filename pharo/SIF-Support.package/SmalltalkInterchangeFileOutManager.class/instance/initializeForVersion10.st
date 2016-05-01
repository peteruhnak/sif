initializing
initializeForVersion10
	"	^	self
	Set myself up to be ready to file out under Version 1.0 Extended.
	NOTE: I work from the assumption that I have already been initialized as a Version 1.0 file out."

	versionString := self version10String.
	fileOutInfoByType := Dictionary new.
	#(#Pool #Package #Method #Global #DoIt #Comment #Class #Dummy) do: [:each |
		fileOutInfoByType at: each put: ('fileOut', each, 'Items:') asSymbol].