class item
classItemInfoAt: i
	"	i	<Integer>
		^	<Object>
	Return whatever is contained in my class item info at item i."

	classItemInfo isNil ifTrue: [
		^nil].
	^classItemInfo at: i