fileout
fileOutAnnotationKey: key value: value
	"	key	<String>
		value	<String> | <Collection withAll: <String>>
	Put out an annotation to my managed stream that has its key beign key and value being value.
	If value is a collection of strings, then put something in that can then be broken out into a
	collection of strings by collectionOfStringsFrom:"

	self cr;
		nextPutAll: 'Annotation key: ';
		nextQuotedPutString: key;
		nextPutAll: ' value: '.
	(value isKindOf: String)
		ifTrue: [self nextQuotedPutString: value]
		ifFalse: [self nextPutCollectionOfStrings: value].
	self nextChunkPut: ''