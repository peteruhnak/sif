fileout
fileOutMethodItems: items
	"	items		<OrderedCollection withAll: <Array with: <Symbol> with: <Behavior>>>>
		^		<OrderedCollection withAll: <Array with: <Symbol> with: <Behavior>>>
	File out the classes in items.
	Return a collection of all the classes that had an initialize method I filed out.  This
	collection is sorted in the hierarchichal order of the classes."

	| byClass result methods selector |
	result := OrderedCollection new.
	byClass := Dictionary new.
	items do: [:each |
		(byClass at: each last ifAbsent: [byClass at: each last put: (OrderedCollection new: 16)])
			add: each].
	(self hierarchicallySortClasses: byClass keys) do: [:eachClass |
		methods := byClass at: eachClass.
		(self classOfBehavior: eachClass) ~~ eachClass ifTrue: [
			selector := self initializerSelectorForClass: eachClass.
			selector isNil ifFalse: [
				(methods detect: [:each | each first == selector] ifNone: [nil]) isNil ifFalse: [
					result add: (Array with: selector with: eachClass)]]].
		methods do: [:each |
			self fileOutMethodItem: each]].
	^result