adding
addItem: item ofType: type
	"	item	<Object>
		type	<Symbol>
		^	void
	PRIVATE
	Item is either an object of some kind or a collection.  type is one of
	a set which is defined as being valid for me.  My subclasses may add
	more, but for now I can deal generically with all types.  The ones I
	know of now are #classes, #globals, #globals, #packages, #pools.
	If two items of the same type are added to me one after the other, then
	I will combine then into one item."

	addedItems last last = type ifTrue: [
		addedItems last first add: item.
		^self].
	addedItems addLast: (Array with: (OrderedCollection with: item) with: type).