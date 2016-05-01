class item
classItemInfoAt: i put: object
	"	i	<Integer>
		^	<Object>
	Place object in my class item info at item i."

	classItemInfo isNil ifTrue: [
		classItemInfo := Array new: 6].
	classItemInfo at: i put: object.
	^object