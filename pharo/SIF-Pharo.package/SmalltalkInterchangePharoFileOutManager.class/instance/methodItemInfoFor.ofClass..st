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

	| result |
	result := Dictionary new.
	result at: #className put: (self nameForClass: class);
		at: #isClassMethod put: class isMeta.
	(result at: #source put: (class compiledMethodAt: methodName) getSourceFromFile) isNil ifTrue: [
		self error: 'There is no source for this method'].
	result at: #source put: (result at: #source) asString.
	result at: #annotations put: (Dictionary new
		at: 'category' put: (class whichCategoryIncludesSelector: methodName) asString;
		yourself).
	^result