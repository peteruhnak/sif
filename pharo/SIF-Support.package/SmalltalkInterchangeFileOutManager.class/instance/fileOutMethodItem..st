fileout
fileOutMethodItem: item
	"	item		<Array with: <Symbol> with: <Class>>
	"

	| info |
	info := self methodItemInfoFor: item first ofClass: item last.
	self cr;
		nextPutAll: (info at: #className);
		nextPutAll: ((info at: #isClassMethod) ifTrue: [' classMethod'] ifFalse: [' method']);
		nextChunkPut: '';
		cr;
		nextChunkPut: (info at: #source).
	(info at: #annotations ifAbsent: [Dictionary new]) associationsDo: [:assoc |
		self fileOutAnnotationKey: assoc key value: assoc value].
	self cr