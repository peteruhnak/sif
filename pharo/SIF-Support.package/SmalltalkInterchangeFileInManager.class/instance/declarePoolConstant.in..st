declaring
declarePoolConstant: constantName in: poolName
	"	constantName	<String>
		poolName		<String>
		^	void
	item is a constant definition for a pool."

	(self atGlobalNamed: poolName ifAbsent: [
		self error: 'The pool dictionary ', poolName printString, ' should have been defined first'.])
			at: constantName
			put: nil