declaring
declarePoolVariable: variableName in: poolName
	"	variableName	<String>
		poolName		<String>
		^	void
	item is a variable definition for a pool."

	(self atGlobalNamed: poolName ifAbsent: [
		self error: 'The pool dictionary ', poolName printString, ' should have been defined first'.])
			at: variableName
			put: nil