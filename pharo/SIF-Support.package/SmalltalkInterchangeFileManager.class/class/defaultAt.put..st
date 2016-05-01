accessing
defaultAt: default put: value
	"	default		<Symbol>
		value			<Object>
		^		value
	Set the value of the default named default to value"

	self defaults at: default put: value.
	^value