accessing
hierarchicallySortClasses: classes
	"	classes	<Collection withAll: <Class>>
		^		<Array withAll: <Class>>
	Return classes sorted in such a way as to have all super classes be listed first,
	and all subclasses come after.
	NOTE: I do not promise to sort them in an in-depth order, in fact its most
		likely to be all classes at one depth followed by the next depth."

	| depths depth superClass |
	depths := Dictionary new.
	classes do: [:each |
		depth := 0.
		superClass := self classOfBehavior: each.
		[superClass := superClass superclass.
		superClass isNil] whileFalse: [
			depth := depth + 1].
		depths at: each put: depth].
	^(classes asSortedCollection: [:a :b | (depths at: a) <= (depths at: b)])
		asArray