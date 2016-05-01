annotation
annotationsPrefixedWtih: prefix
	"	prefix	<String>
		^	<Collection withAll: <self>>
	Return all of my anotations that have begin with the prefix prefix.
	Case does not matter."

	| lookFor |
	lookFor := self uppercaseString: prefix.
	^self annotations select: [:each |
		( self uppercaseString: (each name copyFrom: 1 to: lookFor size)) = lookFor]