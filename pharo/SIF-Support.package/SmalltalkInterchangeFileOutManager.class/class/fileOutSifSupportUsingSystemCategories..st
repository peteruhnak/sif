fileout
fileOutSifSupportUsingSystemCategories: useSystemCategories
	"	useSystemCategories	<Boolean>
		^	void
	File out to a file named 'sifsupport.st' a simple form of all the classes and methods contained
	to provide the base file-in for the first time port of Smalltalk Interchange File to a platform.
	useSystemCategories is used if I should use the subclass:*category: form of class
	creation.
	Once the the basic groundwork for SIF exists, one can read in a SIF version of this to get
	all of the categories and such to clean up the code."
	"
	For Squeak, VW, use:
		SmalltalkInterchangeFileOutManager fileOutSifSupportUsingSystemCategories: true
	For VA, Dolphin, Digitalk, use:
		SmalltalkInterchangeFileOutManager fileOutSifSupportUsingSystemCategories: false
	"

	| manager package eachClassInfo byClass inits |
	manager := self newForFileOut.
	manager fileName: 'sifsupport.st'.
	package := manager packageItemInfoFor: 'SIF-Support'.
	inits := OrderedCollection new.
	(manager hierarchicallySortClasses: (package at: #classes)) do: [:eachClass |
		eachClassInfo := manager classDefinitionInfoFor: eachClass.
		manager nextPutAll: (eachClassInfo at: #superclassName);
			nextPutAll: ' subclass: #';
			nextPutAll: (eachClassInfo at: #name);
			cr; tab; nextPutAll: 'instanceVariableNames: '''.
		(eachClassInfo at: #instVarNames) do: [:each |
			manager nextPutAll: each; space].
		manager nextPut: $';
			cr; tab; nextPutAll: 'classVariableNames: '''.
		(eachClassInfo at: #classVarNames) do: [:each |
			manager nextPutAll: each; space].
		manager nextPut: $';
			cr; tab; nextPutAll: 'poolDictionaries: '''.
		(eachClassInfo at: #poolVarNames) do: [:each |
			manager nextPutAll: each; space].
		manager nextPut: $'.
		useSystemCategories ifTrue: [
			manager cr; tab; nextPutAll: 'category: ''SIF-Support'''].
		manager nextChunkPut: '';
			cr; cr; nextPut: $!;
			nextPutAll: (eachClassInfo at: #name); nextPutAll: ' class methods';
			nextChunkPut: ''.
		byClass := Dictionary new.
		(manager methodItemsForClass: eachClass) do: [:each |
			(byClass at: each last ifAbsent: [byClass at: each last put: OrderedCollection new])
				add: each first].
		(byClass at: eachClass class ifAbsent: [#()]) do: [:each |
			each == #initialize ifTrue: [
				inits add: eachClass].
			manager cr;
				nextChunkPut: ((manager methodItemInfoFor: each ofClass: eachClass class) at: #source)].
		manager nextChunkPut: ' '.
		manager cr; cr; nextPut: $!;
			nextPutAll: (eachClassInfo at: #name); nextPutAll: ' methods';
			nextChunkPut: ''.
		(byClass at: eachClass ifAbsent: [#()]) do: [:each |
			manager cr;
				nextChunkPut: ((manager methodItemInfoFor: each ofClass: eachClass) at: #source)].
		manager nextChunkPut: ' ';
			cr].
	inits do: [:each |
		manager cr;
			nextPutAll: each name;
			nextPutAll:' initialize';
			nextChunkPut: ''].
	manager close.