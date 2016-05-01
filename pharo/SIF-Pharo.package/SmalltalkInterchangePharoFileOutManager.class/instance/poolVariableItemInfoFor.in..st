fileout info
poolVariableItemInfoFor: variableName in: pool
	"	variableName	<String>
		pool			<Dictionary key: <String> value: <Object>>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on method
		#isConstant	<Boolean>
		#initializer		<String>
	"

	^Dictionary new
		at: #isConstant put: false;
		at: #initializer put: (pool at: variableName) printString;
		yourself