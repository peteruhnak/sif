fileout
fileOutPoolDefinitionFor: pool named: name initializer: initializer
	"	poolName	<Dictionary key: <String> value: <Object>>
		name		<String>
		initializer	nil | #default | <Dictionary key: <String> value: <String>>
		^		void
	File out the definition of the pool poolName.
	See addPool* for info on initializer."

	| initializers infos info |
	self cr;
		nextPutAll: 'Pool named: ';
		nextQuotedPutString: name asString;
		nextChunkPut: ''.
	infos := Dictionary new.
	pool associationsDo: [:assoc |
		info := infos at: assoc key put: (self poolVariableItemInfoFor: assoc key in: pool).
		self cr;
			nextPutAll: name asString;
			space;
			nextPutAll: ((info at: #isConstant) ifTrue: ['constant:'] ifFalse: ['variable:']);
			space;
			nextQuotedPutString: assoc key asString;
			nextChunkPut: ''].
	self cr.
	initializer isNil ifTrue: [
			"The default is for all the values to be nil."
		^self].
	initializer == #default
		ifTrue: [
			initializers := Dictionary new.
			pool associationsDo: [:assoc |
				info := infos at: assoc key.
				(info at: #initializer ifAbsent: ['']) isEmpty ifFalse: [
					initializers at: assoc key put: (info at: #initializer)]]]
		ifFalse: [initializers := initializer].
	initializers associationsDo: [:assoc |
		(pool includesKey: assoc key) ifFalse: [
			self error: 'Trying to init a pool variable that is not within this pool.'].
		self cr;
			nextPutAll: name asString;
			nextPutAll: ' initializerFor: ';
			nextQuotedPutString: assoc key;
			nextChunkPut: '';
			cr;
			nextChunkPut: assoc value].