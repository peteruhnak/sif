fileout info
poolVariableItemInfoFor: variableName in: pool
	"	variableName	<String>
		pool			<Dictionary key: <String> value: <Object>>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on method
		#isConstant	<Boolean>
		#initializer		<String>
	"

	self subclassResponsibility