fileout info
methodItemInfoFor: methodName ofClass: class
	"	methodName	<Symbol>
		class			<Behavior>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on method
		#className	<String>
		#isClassMethod	<Boolean>
		#source		<String>
		#annotations	<Dictionary key: <String> value: <String?
	"

	self subclassResponsibility