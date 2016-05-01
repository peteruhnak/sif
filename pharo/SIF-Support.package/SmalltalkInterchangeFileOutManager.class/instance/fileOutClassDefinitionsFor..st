fileout
fileOutClassDefinitionsFor: items
	"	items		<OrderedCollection withAll: <Class>>
		^		void
	File out the definitions for the classes in items."

	| info |
	(self hierarchicallySortClasses: items) do: [:eachClass |
		info := self classDefinitionInfoFor: eachClass.
		self nextPutAll: 'Class named: ';
			nextQuotedPutString: (info at: #name);
			cr; tab;
			nextPutAll: 'superclass: ';
			nextQuotedPutString: (info at: #superclassName);
			cr; tab;
			nextPutAll: 'indexedInstanceVariables: ';
			nextSymbolPutString: (info at: #instVarType);
			cr; tab;
			nextPutAll: 'instanceVariableNames: '''.
		(info at: #instVarNames) do: [:each |
			self nextPutAll: each;
				space].
		self nextPut: $';
			cr; tab;
			nextPutAll: 'classVariableNames: '''.
		(info at: #classVarNames) do: [:each |
			self nextPutAll: each;
				space].
		self nextPut: $';
			cr; tab;
			nextPutAll: 'sharedPools: '''.
		(info at: #poolVarNames) do: [:each |
			self nextPutAll: each;
				space].
		self nextPut: $';
			cr; tab;
			nextPutAll: 'classInstanceVariableNames: '''.
		(info at: #classInstVarNames) do: [:each |
			self nextPutAll: each;
				space].
		self nextPut: $';
			nextChunkPut: ''.
		(info at: #annotations ifAbsent: [Dictionary new]) associationsDo: [:assoc |
			self fileOutAnnotationKey: assoc key value: assoc value].
		self cr]