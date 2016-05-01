file in
fileInMethodItem: item intoClass: class
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a smalltalk item that needs to be processed.
	Item attributes:
		firstToken		Class name
		value		Source string
	item annotations
		category
		categories
		package"

	| method |
	method := item categoryAnnotation isNil
		ifTrue: [class compile: item value notifying: nil]
		ifFalse: [class compile: item value classified: item categoryAnnotation value].
	method isNil ifTrue: [
		self error: 'Compile error.'].