initializing
initialize
	"	^	self
	Cause the defaults for Dolphin to be placed into my defaults."

	self isAbstract ifFalse: [
		self defaultAt: self defaultName put: self].