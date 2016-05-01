accessing
defaultAt: default
	"	default		<Symbol>
		^		<Object> | nil
	Return the value of the default named default.  If there is not a default named default, then return nil."

	^self defaultAt: default ifAbsent: [nil]