item
itemsDo: do
	"	do	[:item <AnsiInterchangeFileItem> | <void>]
	Assume the first chunk I read is the header chunk.  Then let
	the get its data, then pass on this item to do."

	| item |
	[self atEnd] whileFalse: [
		item := self nextItem.
		item isNil ifTrue: [^self].
		do value: item]