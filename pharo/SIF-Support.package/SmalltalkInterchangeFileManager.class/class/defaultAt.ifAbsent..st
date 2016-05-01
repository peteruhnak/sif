accessing
defaultAt: default ifAbsent: ifAbsent
	"	default		<Symbol>
		ifAbsent		[<Object>]
		^		<Object> | ifAbsent value
	Return the value of the default named default.  If there is not a default named default, then return the result of evaluating ifAbsent."

	^self defaults at: default ifAbsent: ifAbsent