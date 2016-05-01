annotation
annotations
	"	^	<OrderedCollection withAll: <self>>
	Return all of the annotations that are attached to me."

	^annotations isNil
		ifTrue: [#()]
		ifFalse: [annotations]