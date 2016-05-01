accessing
defaults
	"	^	<Dictionary key: <Symbol> value: <Object>>
	Return my mapping of default names to their values.
	NOTE: Being destructive to the result will change the values I keep in defaults."

	Defaults isNil ifFalse: [^Defaults].
	^Defaults := Dictionary new