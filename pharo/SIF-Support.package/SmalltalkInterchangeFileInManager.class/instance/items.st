item
items
	"	^	<OrderedCollection withAll: <AnsiInterchangeFileItem>>
	Return a colletion containing all of the items found on my file."

	| result |
	result := OrderedCollection new.
	self itemsDo: [:each |
		result add: each].
	^result