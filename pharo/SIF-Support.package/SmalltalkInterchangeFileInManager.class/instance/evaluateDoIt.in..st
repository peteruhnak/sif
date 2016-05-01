accessing
evaluateDoIt: doIt in: object
	"	doIt	<String>
		in	<Object>
		^	<Object>
	Return the result of evaluating the code in doIt.
	Evaluate the expression within the context of doIt."

	^Compiler evaluate: doIt for: object logged: true