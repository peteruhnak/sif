accessing
defaultName
	"	^	<Symbol>
	Return the name to be used when looking up which manager should be the default for filing in code."

		"Because I get called by the loading of packaged and other such things,
			I must make sure that initialize does not cause any errors."
	^#errorInitializedUsingAnAbstractClass