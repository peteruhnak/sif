'From VisualWorks®, Release 3.0 of February 5, 1998 on April 3, 2000 at 9:55:43 am'!


Object subclass: #SmalltalkInterchangeFileManager
	instanceVariableNames: 'fileName managedStream streamStack '
	classVariableNames: 'Defaults '
	poolDictionaries: ''
	category: 'SIF-Support'!



!SmalltalkInterchangeFileManager methodsFor: 'accessing'!

fileName
	"	^	<String> | nil
	Return the name that the user has specified for the file I will use for read or write.
	If nil, then user has not specified a fileName.  Should have specified  stream then."

	^fileName!

fileName: value
	"	value		<String> | nil
	Use value as the name that the user has specified for the file I will use for read or write.
	If nil, then user has not specified a fileName.  Should have specified  stream then."

	fileName := value!

installedClassNamed: className
	"	className	<String>
		^		<Class> | nil
	Return the class named className."

	^self installedClassNamed: className ifAbsent: [nil]!

installedClassNamed: className ifAbsent: ifAbsent
	"	className	<String>
		ifAbsent		[<Object>]
		^		<Class> | ifAbsent value
	Return the class named className."

	^Smalltalk at: className asSymbol ifAbsent: ifAbsent!

installedMetaclassNamed: className
	"	className	<String>
		^		<Metaclass>
	Return the metaclass named className."

	^(self installedClassNamed: className) class!

newStreamBasedOnFileName

	self subclassResponsibility! !

!SmalltalkInterchangeFileManager methodsFor: 'streaming'!

atEnd

	^self managedStream atEnd!

managedStream
	"	^	<ReadStream on: <String>>
	Retur the stream to use to read or write text from.  If the user has specified the stream then
	return it.  If the user has not specified the stream, then I assume that a filename has been
	specified and I will return a stream open on this file."

	managedStream isNil ifFalse: [
		^managedStream].
	self fileName isNil ifFalse: [
		^self pushStream: (self newStreamOnFileNamed: self fileName)].
	self error: 'Must specify either a stream or a fileName'!

nextStringOrSymbolToken
	"	^		<String> | <Symbol>
	"

	| char result |
	self skipWhiteSpace.
	self managedStream atEnd ifTrue: [^''].
	char := self managedStream next.
	char = $# ifTrue: [
		^self nextWord asSymbol].
	char = $' ifFalse: [
		self error: 'Expecting a '' or a #.'].
	result := WriteStream on: (String new: 32).
	[self managedStream atEnd] whileFalse: [
		char := self managedStream next.
		char = $'
			ifTrue: [(self managedStream peekFor: $')
				ifTrue: [result nextPut: $']
				ifFalse: [^result contents]]
			ifFalse: [result nextPut: char]].
	^result contents!

popStream
	"	^	<Stream>
	Pop the top stream on my stream stack and return it.
	See pushStream: for more info."

	| result |
	result := streamStack removeLast.
	managedStream := streamStack isEmpty
		ifTrue: [nil]
		ifFalse: [streamStack last].
	^result!

pushStream: stream
	"	stream		<Stream>
		^		stream
	Push stream onto my stream stack.  This means that any streaming operation
	I use will be done on the item on the top of the stream stack."

	managedStream := streamStack addLast: stream.
	^stream!

pushStream: stream while: while
	"	stream	<Stream>
		while		[<Object>]
		^		stream
	Push stream onto my stream stack for the duration of the evaluation
	of while.  This means that any streaming operation
	I use will be done on the item on the top of the stream stack."

	self pushStream: stream.
	while value.
	self popStream! !

!SmalltalkInterchangeFileManager methodsFor: 'opening/closing'!

close

	streamStack isEmpty ifFalse: [
		self popStream close].!

newStreamOnFileNamed: file
	"	file	<String>
		^	<ReadStream> | <WriteStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	self subclassResponsibility! !

!SmalltalkInterchangeFileManager methodsFor: 'initializing'!

initialize
	"	^	void
	Initialize myself to be in a consistent state with regards to my defaults."

	streamStack := OrderedCollection new.! !

SmalltalkInterchangeFileManager class
	instanceVariableNames: ''!



!SmalltalkInterchangeFileManager class methodsFor: 'accessing'!

concreteClasses
	"	^	<Collection withAll: <Class>>
	Return a collection containing all of my subclasses that are concrete."
	"AnsiInterchangeFileManager concreteClasses"

	^self allSubclasses reject: [:each | each isAbstract]!

defaultAt: default
	"	default		<Symbol>
		^		<Object> | nil
	Return the value of the default named default.  If there is not a default named default, then return nil."

	^self defaultAt: default ifAbsent: [nil]!

defaultAt: default ifAbsent: ifAbsent
	"	default		<Symbol>
		ifAbsent		[<Object>]
		^		<Object> | ifAbsent value
	Return the value of the default named default.  If there is not a default named default, then return the result of evaluating ifAbsent."

	^self defaults at: default ifAbsent: ifAbsent!

defaultAt: default put: value
	"	default		<Symbol>
		value			<Object>
		^		value
	Set the value of the default named default to value"

	self defaults at: default put: value.
	^value!

defaultName
	"	^	<Symbol>
	Return the name to be used when looking up which manager should be the default for filing in code."

		"Because I get called by the loading of packaged and other such things,
			I must make sure that initialize does not cause any errors."
	^#errorInitializedUsingAnAbstractClass!

defaults
	"	^	<Dictionary key: <Symbol> value: <Object>>
	Return my mapping of default names to their values.
	NOTE: Being destructive to the result will change the values I keep in defaults."

	Defaults isNil ifFalse: [^Defaults].
	^Defaults := Dictionary new!

isAbstract
	"	^	<Boolean>
	Return true if I represent an abstract class.
	See concreteClasses for a list of concrete classes."

	^self == SmalltalkInterchangeFileManager! !

!SmalltalkInterchangeFileManager class methodsFor: 'initializing'!

initialize
	"	^	self
	Cause the defaults for Dolphin to be placed into my defaults."

	self isAbstract ifFalse: [
		self defaultAt: self defaultName put: self].! !

!SmalltalkInterchangeFileManager class methodsFor: 'instance creation'!

new

	^super new initialize!

newForFileIn
	"	^	<AnsiInterchangeFileInManager>
	Return an object capable of filing in an interchange file with classes, methods, packages."

	^(self defaultAt: #fileInManager) new!

newForFileOut
	"	^	<AnsiInterchangeFileOutManager>
	Return an object capable of filing out classes, methods, packages."

	^(self defaultAt: #fileOutManager) new! !

SmalltalkInterchangeFileManager subclass: #SmalltalkInterchangeFileOutManager
	instanceVariableNames: 'versionString fileOutInfoByType addedItems '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SIF-Support'!



!SmalltalkInterchangeFileOutManager methodsFor: 'fileout info'!

classDefinitionInfoFor: class
	"	class		<Behavior>
		^		<Dictionary key: <Symbol> value: <String>>
	Return info on
		#name			<String>
		#superclassName	<String>
		#instVarType		#byte | #object | #none
		#instVarNames		<Array withAll: <String>>
		#classVarNames		<Array withAll: <String>>
		#poolVarNames		<Array withAll: <String>>
		#classInstVarNames	<Array withAll: <String>>
		#annotations		<Dictionary key: <String> value: <String>>
	"

	self subclassResponsibility!

initializerSelectorForClass: class
	"	class		<Behavior>
		^		<Symbol> | nil
	Return the method to invoke in order to initialize class on file in.
	Return nil if there is to be none."

	((self classOfBehavior: class) class includesSelector: #initialize) ifTrue: [
		^#initialize].
	^nil!

methodItemInfoFor: methodName ofClass: class
	"	methodName	<Symbol>
		class			<Behavior>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on method
		#className	<String>
		#isClassMethod	<Boolean>
		#source		<String>
		#annotations	<Dictionary key: <String> value: <String?
	"

	self subclassResponsibility!

methodItemsForClass: class
	"	class		<Behavior>
		^		<Collection withAll: <Array with: <Symbol> with: <Behavior>>>
	"

	| methods |
	methods := OrderedCollection new: 64.
	class selectors do: [:each |
		methods add: (Array with: each with: class)].
	class class selectors do: [:each |
		methods add: (Array with: each with: class class)].
	^methods!

packageItemInfoFor: name
	"	name	<String>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on the package named name.
		#name			<String>
		#classes			<Class>
		#methods			<Collection withAll: <Array with: <Symbol> with: <Behavior>>>
		#preInstallCode		<String>
		#postInstallCode		<String>
		#preUnInsrallCode	<String>
		#postUninstallCode	<String>
		#preRequisiteNames	<Collection withAll: <String>>
	The list of classes are the classes I file out their definition as part of this package.
	methods, includes all methods from the classes in the classes list.  This is to make
	sure that only the methods belonging to the class and package are included.  It can
	contain other methods that are part of the package but not necessarily part of one
	the package's classes."

	self subclassResponsibility!

poolVariableItemInfoFor: variableName in: pool
	"	variableName	<String>
		pool			<Dictionary key: <String> value: <Object>>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on method
		#isConstant	<Boolean>
		#initializer		<String>
	"

	self subclassResponsibility! !

!SmalltalkInterchangeFileOutManager methodsFor: 'streaming'!

cr

	self managedStream cr!

newStreamOnFileNamed: file
	"	file	<String>
		^	<WriteStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	^self subclassResponsibility!

nextChunkablePut: chunk
	"	chunk	<String>
	Add the contents of chunk to my stream to use.
	Make sure that nextChunk functionality is kept, meaning that
	yf there are any embedded !!s, they will doubled up."

	(chunk includes: $!!)
		ifTrue: [
			chunk do: [ :character |
				self managedStream nextPut: character.
				character == $!! ifTrue: [self managedStream nextPut: $!!]]]
		ifFalse: [
			self managedStream nextPutAll: chunk].!

nextChunkPut: chunk
	"	chunk	<String>
	Add the contents of chunk to my stream to use.  Chunking means to end with a single !!.  IF there are any embedded !!s, they will doubled up."

	self nextChunkablePut: chunk;
		nextPut: $!!!

nextPut: char
	self managedStream nextPut: char!

nextPutAll: all

	self managedStream nextPutAll: all!

nextPutCollectionOfStrings: strings
	"	strings	<Collection withAll: <String>>
		^		void
	Place a string which when read back can yield a collection of strings."

	self pushStream: (WriteStream on: (String new: 32)).
	strings do: [:each |
		self nextChunkPut: each].
	self nextChunkablePut: self popStream contents printString!

nextQuotedPutString: string
	"	string		<String>
	"

	self print: string asString!

nextSymbolPutString: string
	"	string		<String>
	"

	self print: string asSymbol!

print: object
	self managedStream print: object!

space
	self managedStream space!

tab
	self managedStream tab! !

!SmalltalkInterchangeFileOutManager methodsFor: 'fileout'!

fileOut
	"	^	self
	File out whatever code the user has specified for me to do."

	self nextPutAll: 'Smalltalk interchangeVersion: ';
		nextQuotedPutString: versionString;
		nextChunkPut: '';
		cr;
		cr.
	self fileOutItems;
		close!

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
	self nextChunkPut: ''!

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
		self cr]!

fileOutClassItems: items
	"	items	<OrderedCollection withAll: <Class>>
		^		void
	File out the classes in items."

	| selector methods |
	self fileOutClassDefinitionsFor: items.
	methods := OrderedCollection new: 64.
	items do: [:each |
		methods addAll: (self methodItemsForClass: each)].
	methods := self fileOutMethodItems: methods.
	methods do: [:each |
		self fileOutInitializer: (self nameForClass: each last), ' ', each first forName: (self nameForClass: each last)].!

fileOutCommentItems: items
	"	items		<OrderedCollection withAll: <String>>
		^		void
	File out the comments in items."

	items do: [:each |
		self cr;
			nextPut: $";
			nextChunkablePut: each;
			nextPut: $";
			nextChunkPut: ''.].!

fileOutDoItItems: items
	"	items		<OrderedCollection withAll: <String>>
		^		void
	File out the doIts in items."

	self cr.
	items do: [:each |
		self fileOutInitializer: each last forName: 'Global'].!

fileOutDummyItems: dummy
	"	dummy	<Array new: 0>
		^		void
	I'm here to handle the dummy item added to the start of my added items list."!

fileOutGlobalItems: items
	"	items		<OrderedCollection withAll: <Array with: name <String> with: initializer <String> | nil>
		^		void
	File out the globals in items."

	| initializer |
	items do: [:each |
		self cr;
			nextPutAll: 'Global variable: ';
			nextQuotedPutString: each first;
			nextChunkPut: ''].
	self cr.
	items do: [:each | each last isNil ifFalse: [
		initializer := each last == #default
			ifTrue: [(self globalNamed: each first) printString]
			ifFalse: [each last].
		self fileOutInitializer: initializer forName: each first]].!

fileOutInitializer: initializer forName: name
	"	initializer	<String>
		name		<String>
		^		void
	File out the an initializer whose code is initializer for a global or class named name."

	self cr;
		nextPutAll: name;
		nextPutAll: ' initializer';
		nextChunkPut: '';
		cr;
		nextChunkPut: initializer.!

fileOutItems
	"	^	self
	File out whatever code the user has specified for me to do."

	self addedItems do: [:each |
		self perform: (fileOutInfoByType at: each last) with: each first].!

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
	self cr!

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
	^result!

fileOutPackageItem: item
	"	item	<Dictionary>	See packageItemInfoForPackageNamed:
		^		void
	File out a declaration and contents of the package named name."

	| inits |
	(item at: #preRequisiteNames ifAbsent: ['']) isEmpty ifFalse: [
		self fileOutInitializer: '' forName: 'Global';
			fileOutAnnotationKey: 'package' value: (item at: #name) asString;
			fileOutAnnotationKey: 'package-preRequisites' value: (item at: #preRequisiteNames);
			cr].
	(item at: #preInstallCode ifAbsent: ['']) isEmpty ifFalse: [
		self fileOutInitializer: (item at: #preInstallCode) forName: 'Global';
			fileOutAnnotationKey: 'package' value: (item at: #name) asString;
			fileOutAnnotationKey: 'package-preInstallCode' value: (item at: #preInstallCode);
			cr].
	(item at: #preUnInstallCode ifAbsent: ['']) isEmpty ifFalse: [
		self fileOutInitializer: '' forName: 'Global';
			fileOutAnnotationKey: 'package' value: (item at: #name) asString;
			fileOutAnnotationKey: 'package-preUnInstallCode' value: (item at: #preUnInstallCode);
			cr].
	(item at: #postUnInstallCode ifAbsent: ['']) isEmpty ifFalse: [
		self fileOutInitializer: '' forName: 'Global';
			fileOutAnnotationKey: 'package' value: (item at: #name) asString;
			fileOutAnnotationKey: 'package-postUnInstallCode' value: (item at: #postUnInstallCode);
			cr].
	self fileOutClassDefinitionsFor: (item at: #classes).
	inits := self fileOutMethodItems: (item at: #methods).
	inits do: [:each |
		self fileOutInitializer: (self nameForClass: each last), ' ', each first forName: (self nameForClass: each last)].
	(item at: #postInstallCode ifAbsent: ['']) isEmpty ifFalse: [
		self fileOutInitializer: (item at: #postInstallCode) forName: 'Global';
			fileOutAnnotationKey: 'package' value: (item at: #name) asString;
			fileOutAnnotationKey: 'package-postInstallCode' value: (item at: #postInstallCode)].!

fileOutPackageItems: items
	"	items		<OrderedCollection withAll: <Array with: name <String> with: initializer <String> | nil>
		^		void
	File out the globals in items."

	items do: [:each |
		self fileOutPackageItem: each].
	self cr.!

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
			nextChunkPut: assoc value].!

fileOutPoolItems: items
	"	items		<OrderedCollection withAll: <Array with: name <String> with: initializer <String> | nil>
		^		void
	File out the globals in items."

	items do: [:each | self
		fileOutPoolDefinitionFor: (self poolNamed: each first)
		named: each first
		initializer: each last].! !

!SmalltalkInterchangeFileOutManager methodsFor: 'adding'!

addClass: item
	"	item	<Behavior>
		^		self
	Add item as a class to be filed out."

	self addItem: item ofType: #Class.!

addClasses: items
	"	items		<Collection withAll: <Behavior>>
		^		self
	Add each of the classes in items as a class to be filed out.
	Keep the order of items."

	self addItems: items ofType: #Class.!

addClassesNamed: items
	"	items	<Collection withAll: <Symbol>>
		^		self
	Add the class corresponding to each name in items to be filed out.."

	items do: [:each | self addClassNamed: each].!

addClassNamed: newEntry
	"	newEntry	<Symbol>
		^		self
	Add all newEntry to the collection of classes that have been eplicitly specified for file out."

	| class |
	class := self installedClassNamed: newEntry.
	class isNil ifTrue: [
		self error: 'There is no such class installed in your image called: ', newEntry printString].
	self addClass: class.!

addComment: item
	"	item	<String>
		^		self
	Add item as a comment to be filed out."

	self addItem: item ofType: #Comment.!

addDoIt: item
	"	item	<String>
		^		self
	Add item as an expression to be evaled on loading."

	self addItem: item ofType: #DoIt.!

addGlobalNamed: newEntry
	"	newEntry	<String>
		^		self
	Add all newEntry to the collection of Globals that have been eplicitly specified for file out."

	self addGlobalNamed: newEntry initializer: nil.!

addGlobalNamed: newEntry initializer: initializer
	"	newEntry	<String>
		initializer	nil | #default | <String>
		^		self
	Add all newEntry to the collection of Globals that have been eplicitly specified for file out.
	initializer is a chunk of code to build the Global, this code will be evaled at file in time.
	If initializer is nil, then I rill just allocate the global.  #default I will place the printString
	of it's current value.  If it's a string then use this as the init expression.
	NOTE: The order of the Globals is kept."

	self addItem: (Array with: newEntry with: initializer) ofType: #Global.!

addGlobalsNamed: newEntries
	"	newEntries	<Collection withAll: <String>>
		^		self
	Add all newEntries to the collection of Globals that have been eplicitly specified for file out."

	newEntries do: [:each |
		self addGlobalNamed: each]!

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
	addedItems addLast: (Array with: (OrderedCollection with: item) with: type).!

addItems: items ofType: type
	"	items		<Collection withAll: <Object>>
		type		<Symbol>
		^	void
	PRIVATE
	Item is either an object of some kind or a collection.  type is one of
	a set which is defined as being valid for me.  My subclasses may add
	more, but for now I can deal generically with all types.  The ones I
	know of now are #classes, #globals, #globals, #packages, #pools.
	If two items of the same type are added to me one after the other, then
	I will combine then into one item."

	addedItems last last = type ifTrue: [
		addedItems last first addAll: items.
		^self].
	addedItems addLast: (Array
		with: (OrderedCollection new addAll: items;
			yourself)
		with: type).!

addMethodNamed: entry ofClass: class
	"	entry		<Symbol>
		class		<Behavior>
		^		self
	Add all newEntries to the collection of methods that have been eplicitly specified for file out."

	self addItem: (Array with: entry with: class) ofType: #Method.!

addPackage: newEntry
	"	newEntry	<Dictionary key: <Symbol> value: <Object>>
	Add newEntry to the collection of packages that have been eplicitly specified for file out.
		#name			<String>
		#classes			<Class>
		#methods			<Collection withAll: <CompiledMethod>>
		#preInstallCode		<String>
		#postInstallCode		<String>
		#preUnInsrallCode	<String>
		#postUninstallCode	<String>
	"

	self addItem: newEntry ofType: #Package.!

addPackageNamed: newEntry
	"	newEntry	<String>
		^		self
	Add newEntry to the collection of packages that have been eplicitly specified for file out."

	self addPackage: (self packageItemInfoFor: newEntry).!

addPackages: newEntries
	"	newEntries	<Collection withAll: <Dictionary key: <Symbol> value: <Object>
		^		self
	Add newEntries to the collection of packages that have been eplicitly specified for file out.
	See packageItemInfoForPackageNamed: for info on what what each entry should be."

	self addItems: newEntries ofType: #Package.!

addPackagesNamed: newEntries
	"	newEntries	<Collection withAll: <String>>
		^		self
	Add all newEntries to the collection of packages that have been eplicitly specified for file out."

	newEntries do: [:each |
		self addPackageNamed: each]!

addPoolNamed: newEntry
	"	newEntry	<String>
		^		self
	Add all newEntry to the collection of Pools that have been eplicitly specified for file out.
	I will define each of the keys in new entry with no initializer."

	self addPoolNamed: newEntry initializer: nil!

addPoolNamed: newEntry initializer: initializer
	"	newEntry	<String>
		initializer	nil | #default | <Dictionary key: varName <String> value: valueExpression <String>>
		^		self
	Add all newEntry to the collection of Pools that have been eplicitly specified for file out.
	If initializer is nil, then I will put out a default initializer that will create a pool with the
	same keys as found now, and will leave the values nil.
	If initializer is #default then I will do the same as nil, put I will also put something out
	to initialize.
	If initializer is a dictionary, then I will put out the expression for each var define in initializer.
	NOTE: The order of the pools is kept."

	self addItem: (Array with: newEntry with: initializer) ofType: #Pool.!

addPoolsNamed: newEntries
	"	newEntries	<Collection withAll: <String>>
		^		self
	Add all newEntries to the collection of pools that have been eplicitly specified for file out."

	newEntries do: [:each |
		self addPoolNamed: each]! !

!SmalltalkInterchangeFileOutManager methodsFor: 'accessing'!

addedItems
	"	^	<OrderedCollection withAll: <???>>
	Return all of the items that were added to me for file out."

	^addedItems!

globalNamed: name
	"	name	<String>
		^		<Dictionary>
	Return the global named name."

	^Smalltalk at: name asSymbol!

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
		asArray!

nameForClass: class
	"	class		<Behavior>
		^		<String>
	Return the name of class."

	^(self classOfBehavior: class) name!

poolNamed: name
	"	name	<String>
		^		<Dictionary>
	Return the pool named name."

	^Smalltalk at: name asSymbol! !

!SmalltalkInterchangeFileOutManager methodsFor: 'initializing'!

initialize
	"	^	self
	Set myself up to be ready to file out under Version 1.0."

	super initialize.
	addedItems := OrderedCollection new: 32.
		"Add at least one item such that I don't have to check for isEmpty on
			my add code."
	addedItems add: #(#() #Dummy).
	self initializeForVersion10!

initializeForVersion10
	"	^	self
	Set myself up to be ready to file out under Version 1.0 Extended.
	NOTE: I work from the assumption that I have already been initialized as a Version 1.0 file out."

	versionString := self version10String.
	fileOutInfoByType := Dictionary new.
	#(#Pool #Package #Method #Global #DoIt #Comment #Class #Dummy) do: [:each |
		fileOutInfoByType at: each put: ('fileOut', each, 'Items:') asSymbol].!

initializeForVersion10Extended
	"	^	self
	Set myself up to be ready to file out under Version 1.0 Extended.
	NOTE: I work from the assumption that I have already been initialized as a Version 1.0 file out."

	versionString := self version10ExtendedString!

version10ExtendedString
	"	^	<String>
	Return the string to use for version 1.0 extended."

	^'1.0 Extended'!

version10String
	"	^	<String>
	Return the string to use for version 1.0"

	^'1.0'! !

!SmalltalkInterchangeFileOutManager methodsFor: 'testing'!

is10
	"	^	<Boolean>
	Return true if I am for version 1.0."

	^versionString == self version10String!

is10Extended
	"	^	<Boolean>
	Return true if I am for version 1.0 extended."

	^versionString == self version10ExtendedString! !

SmalltalkInterchangeFileOutManager class
	instanceVariableNames: ''!



!SmalltalkInterchangeFileOutManager class methodsFor: 'accessing'!

defaultName
	"	^	<Symbol>
	Return the name to be used when looking up which manager should be the default for filing out code."

	^#fileOutManager! !

!SmalltalkInterchangeFileOutManager class methodsFor: 'testing'!

isAbstract
	"	^	<Boolean>
	Return true if I represent an abstract class.
	See concreteClasses for a list of concrete classes."

	^self == SmalltalkInterchangeFileOutManager! !

!SmalltalkInterchangeFileOutManager class methodsFor: 'fileout'!

fileOutSifSupportInSif
	"	^	self
	File out the basic SIF support in SIF format."
	"
	SmalltalkInterchangeFileOutManager fileOutSifSupportInSif
	"

	SmalltalkInterchangeFileManager newForFileOut
		fileName: 'sif-support.sif';
		addPackageNamed: 'SIF-Support';
		fileOut;
		close!

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
			cr; cr; nextPut: $!!;
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
		manager cr; cr; nextPut: $!!;
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
	manager close.! !

SmalltalkInterchangeFileManager subclass: #SmalltalkInterchangeFileInManager
	instanceVariableNames: 'headerStream currentItem nextItem isSmalltalkItemProcessed itemInfoByFirstToken itemInfoBySecondToken classToPackageName '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SIF-Support'!



!SmalltalkInterchangeFileInManager methodsFor: 'declaring'!

declarePool: name
	"	name		<String>
		^	void
	Declare a Pool named name"

	self atGlobalNamed: name ifAbsent: [
		self atGlobalNamed: name put: Dictionary new]!

declarePoolConstant: constantName in: poolName
	"	constantName	<String>
		poolName		<String>
		^	void
	item is a constant definition for a pool."

	(self atGlobalNamed: poolName ifAbsent: [
		self error: 'The pool dictionary ', poolName printString, ' should have been defined first'.])
			at: constantName
			put: nil!

declarePoolVariable: variableName in: poolName
	"	variableName	<String>
		poolName		<String>
		^	void
	item is a variable definition for a pool."

	(self atGlobalNamed: poolName ifAbsent: [
		self error: 'The pool dictionary ', poolName printString, ' should have been defined first'.])
			at: variableName
			put: nil! !

!SmalltalkInterchangeFileInManager methodsFor: 'accessing'!

atGlobalNamed: name ifAbsent: ifAbsent
	"	name	<String>
		ifAbsent	[<Object>]
		^	<Object> | ifAbsent value
	Return the value in global named name.  If its not there return the result of ifAbsent."

	^Smalltalk at: name asSymbol ifAbsent: ifAbsent!

atGlobalNamed: name put: value
	"	name	<String>
		value	<Object>
		^	void
	Set the value of the global named name to value."

	Smalltalk at: name asSymbol put: value!

classNameToPackageName
	"	^	<Dictionary key: <String> to: <String>>
	Return the mapping from class name to package name.
	See fileInClassItem:, fileInMethodItem, fileInClassMethodItem."

	^classToPackageName!

currentItem
	"	^	<AnsiInterchangeFileItem> | nil
	"

	^currentItem!

currentItem: item
	"	item		<AnsiInterchangeFileItem>
		^		self
	"

	currentItem := item!

evaluateDoIt: doIt in: object
	"	doIt	<String>
		in	<Object>
		^	<Object>
	Return the result of evaluating the code in doIt.
	Evaluate the expression within the context of doIt."

	^Compiler evaluate: doIt for: object logged: true!

isSmalltalkItemProcessed
	"	^	<Boolean>
	Return true if the Smalltalk Item has been processed to initialize me for the version identified in it."

	^isSmalltalkItemProcessed!

uppercaseString: string
	"	string		<String>
		^		<String>
	Return string with all of its alphabetic character converted to upper case."

	^string asUppercase! !

!SmalltalkInterchangeFileInManager methodsFor: 'item'!

checkAndSetupVersion
	"	^	self
	Read the first item on the file and make sure that it is a version marker and that I support this version.
	I will also set myself up to be able to read in something of whatever version is identified.
	If any of my checks fail, I will cause an error and not return."

	| read write selector next |
	currentItem isSmalltalkItem ifFalse: [
		self error: 'File MUST start with a Smalltalk version: ''1.0'' type of item.'].
	read := ReadStream on: currentItem value.
	write := WriteStream on: (String new: 32).
	write nextPutAll: 'initializeForVersion'.
	[read atEnd] whileFalse: [
		(next := read next) isAlphaNumeric ifTrue: [
			write nextPut: next]].
	selector := write contents asSymbol.
	(self respondsTo: selector) ifFalse: [
		self error: 'I do not support version ', currentItem value printString].
	self perform: selector.
	isSmalltalkItemProcessed := true!

items
	"	^	<OrderedCollection withAll: <AnsiInterchangeFileItem>>
	Return a colletion containing all of the items found on my file."

	| result |
	result := OrderedCollection new.
	self itemsDo: [:each |
		result add: each].
	^result!

itemsDo: do
	"	do	[:item <AnsiInterchangeFileItem> | <void>]
	Assume the first chunk I read is the header chunk.  Then let
	the get its data, then pass on this item to do."

	| item |
	[self atEnd] whileFalse: [
		item := self nextItem.
		item isNil ifTrue: [^self].
		do value: item]!

newItem
	"	^	<SmalltalkInterchangeFileItem>
	Return a fresh new instance of an item."

	^SmalltalkInterchangeFileItem new
		manager: self;
		yourself!

nextItem
	"	^	<SmalltalkInterchangeFileItem> | nil
	Return the next item, excluding annotations, found on my stream.
	The annotations that should be attached to this item will be part of that
	items annotations."

	| item |
	nextItem isNil
		ifTrue: [self primNextItem]
		ifFalse: [
			currentItem := nextItem.
			nextItem := nil].
	currentItem isNil ifTrue: [^nil].
	self isSmalltalkItemProcessed ifFalse: [
		self checkAndSetupVersion].
	currentItem isAnnotation ifTrue: [
		self error: 'Cannot have an annotation before there is an element to attach annotations to.'].
	item := currentItem.
	[self primNextItem.
	currentItem notNil and: [currentItem isAnnotation]] whileTrue: [
		item addAnnotation: currentItem].
	nextItem := currentItem.
	^currentItem := item!

primNextItem
	"	void
	Set my currentItem to be the next item, including annotations, I find on my stream.
	I also set my currentItem to be this item."

	| firstToken position secondToken |
	headerStream := self pushStream: (ReadStream on: self nextChunk).
	self skipWhiteSpace.
	(self peekFor: $")
		ifTrue: [
			firstToken := '"']
		ifFalse: [
			firstToken := self nextWord].
	firstToken isNil ifTrue: [
		self popStream.
		^currentItem := nil].
	currentItem := self newItem.
	position := headerStream position.
	secondToken := self nextWord.
	headerStream position: position.
		"We check for the second token, since we could have a global, or class
			by the same name as the special first tokens of the standard."
	secondToken notNil ifTrue: [
		currentItem info: (itemInfoBySecondToken at: (self uppercaseString: secondToken) ifAbsent: [nil])].
	currentItem info isNil ifTrue: [
		currentItem info: (itemInfoByFirstToken at: (self uppercaseString: firstToken) ifAbsent: [nil])].
	currentItem info isNil ifTrue: [
		self error: 'Expecting one of ...'].
	self popStream.
	currentItem firstToken: firstToken;
		getContents! !

!SmalltalkInterchangeFileInManager methodsFor: 'get contents'!

getAnnotationItemContents

	| keyword |
	self pushStream: headerStream while: [
		#(
			#('KEY:' #name:)
			#('VALUE:' #value:)
		) do: [:pair |
			keyword := self nextWord.
			(self uppercaseString: keyword) = (pair at: 1) ifFalse: [
				self error: 'Expecting ', (pair at: 1)].
			currentItem perform: (pair at: 2) with: self nextStringOrSymbolToken]].!

getClassInitializerItemContents

	currentItem value: self nextChunk!

getClassItemContents

	| keyword |
	self pushStream: headerStream while: [
		#(
			#('named:' #name:)
			#('superclass:' #superclassName:)
			#('indexedInstanceVariables:' #instVarType:)
			#('instanceVariableNames:' #instVarNames:)
			#('classVariableNames:' #classVarNames:)
			#('sharedPools:' #sharedPoolNames:)
			#('classInstanceVariableNames:' #classInstVarNames:)
		) do: [:pair |
			keyword := self nextWord.
			(self uppercaseString: keyword) = (self uppercaseString: (pair at: 1)) ifFalse: [
				self error: 'Expecting ....'].
			currentItem perform: (pair at: 2) with: self nextStringOrSymbolToken]].!

getClassMethodItemContents

	currentItem value: (self skipWhiteSpace; nextChunk)!

getCommentItemContents

	currentItem value: (headerStream upTo: $")!

getConstantItemContents

	self getVariableItemContents!

getInitializerForItemContents

	self pushStream: headerStream while: [
			"Skip initializeFor:"
		self nextWord.
		currentItem name: self nextStringOrSymbolToken].
	currentItem value: self nextChunk.!

getInitializerItemContents

	currentItem value: (self skipWhiteSpace; nextChunk)!

getMethodItemContents

	currentItem value: self skipWhiteSpace nextChunk!

getPackageItemContents

	self notSupportedYet!

getPoolItemContents

	self pushStream: headerStream while: [
			"Skip named:"
		self nextWord.
		currentItem name: self nextStringOrSymbolToken].!

getSmalltalkItemContents

	self pushStream: headerStream while: [
			"Skip version:"
		self nextWord.
		currentItem value: self nextStringOrSymbolToken]!

getVariableItemContents

	self pushStream: headerStream while: [
			"Skip variable:"
		self nextWord.
		currentItem name: self nextStringOrSymbolToken].! !

!SmalltalkInterchangeFileInManager methodsFor: 'streaming'!

atEnd
	"	^	<Boolean>
	"

		"If I am the bottom most stream, the original stream being read in,
			then there is a special case for atEnd since we read ahead."
	streamStack size = 1 ifFalse: [
		^self managedStream atEnd].
	^self managedStream atEnd and: [nextItem isNil]!

collectionOfStringsFrom: string
	"	string		<String>
		^		<OrderedCollection withAll: <String>>
	Return the collection of strings in string that was placed there by nextPutCollectionOfStrings:."

	| result |
	result := OrderedCollection new.
	self pushStream: (ReadStream on: string) while: [
		[self atEnd] whileFalse: [
			result add: self nextChunk]].
	^result!

nextChunk

	| result |
	result := self upTo: $!!.
	(self peekFor: $!!) ifFalse: [^result].
	result := (WriteStream on: (String new: result size + 128))
		nextPutAll: result;
		nextPut: $!!;
		yourself.
	[self atEnd] whileFalse: [
		result nextPutAll: (self upTo: $!!).
		(self peekFor: $!!) ifFalse: [
			^result contents].
		result nextPut: $!!].
	self skipWhiteSpace.
	^result contents!

nextWord
	"	^			<String> | nil
	Return the next word found on my managed stream.  If I reach the end of the stream before
	finding a word, then return nil.
	I skip any current whitespcae, start collecting, and stop at the first white space."

	self subclassResponsibility!

peekFor: char

	^self managedStream peekFor: char!

skipWhiteSpace
	"	stream	<ReadStream on: <String>>
		^	void
	Skip any carriage returns, tabs, spaces anything that is a spacing character."

	self managedStream skipSeparators!

upTo: char
	"	char		<Character>
		^		<String>
	Return a string containing all characters starting from current position, up to but
	but not including char."

	^self managedStream upTo: char! !

!SmalltalkInterchangeFileInManager methodsFor: 'filein'!

fileIn

	self managedStream.
	self itemsDo: [:each |
		each fileIn].
	self close.!

fileInClassItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a class item that needs to be processed.
	Item attributes:
		name				<String> 'named:'
		superclassName		<String> 'superclass:'
		instVarType		#none | #byte | #object 'indexedInstanceVariables:'
		instVarNames		<String>'instanceVariableNames:'
		classVarNames		<String> 'classVariableNames:'
		sharedPoolNames	<String> 'sharedPools:'
		classInstVarNames	<String> 'classInstanceVariableNames:'
	item annotations
		package
	"

	self subclassResponsibility!

fileInClassMethodItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a classMethod item that needs to be processed.
	NOTE: If item does not have a packahe annotation, I will place the
		method into the same package as the class of item.
	Item attributes:
		firstToken		Class name
		value		Source string
	item annotations
		category
		categories
		package"

	self fileInMethodItem: item intoClass: (self installedMetaclassNamed: item firstToken)!

fileInCommentItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a class item that needs to be processed.
	Item attributes:
		firstToken		Double quote
		value			<String>
	item annotations
	"!

fileInConstantItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a constant definition for a pool.
	If first token is 'Global' then define a global instead of a pool variable.
	Item attributes:
		firstToken		Pool name
		name		Name of variable within pool
	item annotations"

	(self uppercaseString: item firstToken) = 'GLOBAL' ifTrue: [
		self atGlobalNamed: item name ifAbsent: [
			self atGlobalNamed: item name put: nil].
		^self].
	self declarePoolConstant: item name in: item firstToken!

fileInInitializerForItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is an initializer item that needs to be processed.
	Item attributes:
		type		#initializerFor
		firstToken	Name of the pool dictionary
		name		Name of the pool variable
		value		Code to eval the value
	item annotations
		"
	(self atGlobalNamed: item firstToken ifAbsent: [self error: 'No pool has been declared by the name of ', item firstToken printString])
		at: item name
		put: (self evaluateDoIt: item value in: nil)!

fileInInitializerItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is an initializer item that needs to be processed.
	Item attributes:
		firstToken		Global name
		value		Code to eval
	item annotations
		Package-PreInstallCode
		Package-PreUnInstallCode
		Package-PostInstallCode
		Package-PosUntInstallCode"


	(self uppercaseString: item firstToken) = 'GLOBAL' ifTrue: [
		self handleAnnotationsOnGlobalInitializerItem: item.
		^self evaluateDoIt: item value in: nil].
	((self
		atGlobalNamed: item firstToken
		ifAbsent: [self error: 'Encountered initializer for ', item firstToken printString, ' before it was defined.'])
			isKindOf: Behavior) ifTrue: [
				^self evaluateDoIt: item value in: nil].
	self atGlobalNamed: item firstToken put: (self evaluateDoIt: item value in: nil)!

fileInMethodItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a method item that needs to be processed.
	NOTE: If item does not have a packahe annotation, I will place the
		method into the same package as the class of item.
	Item attributes:
		firstToken		Class name
		value		Source string
	item annotations
		category
		categories
		package"


	self fileInMethodItem: item intoClass: (self installedClassNamed: item firstToken)!

fileInMethodItem: item intoClass: class
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a smalltalk item that needs to be processed.
	Item attributes:
		firstToken		Class name
		value		Source string
	item annotations
		category
		categories
		package"

	self subclassResponsibility!

fileInPoolItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a declaration for a Pool item that needs to be processed.
	Item attributes:
		firstToken		'Pool'
		name			Name of the pool
	item annotations"


	self declarePool: item name!

fileInSmalltalkItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a smalltalk item that needs to be processed.
	Item attributes:
		value	Version string."!

fileInVariableItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a variable definition for a pool.
	If first token is 'Global' then define a global instead of a pool variable.
	Item attributes:
		firstToken		Pool name
		name		Name of variable within pool
	item annotations"

	(self uppercaseString: item firstToken) = 'GLOBAL' ifTrue: [
		self atGlobalNamed: item name ifAbsent: [
			self atGlobalNamed: item name put: nil].
		^self].
	self declarePoolVariable: item name in: item firstToken!

handleAnnotationsOnGlobalInitializerItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is an initializer item that needs to be processed.  I am called by the generic handler
	in order to handle the annotations on the item.
	Item attributes:
		firstToken		Global name
		value		Code to eval
	item annotations
		package-preInstallCode
		package-preUnInstallCode
		package-postInstallCode
		package-posUntInstallCode
		package-preRequisites"

	self subclassResponsibility! !

!SmalltalkInterchangeFileInManager methodsFor: 'initializing'!

initialize
	"	self
	Initialize myself to be ready to read a file"

	super initialize.
	isSmalltalkItemProcessed := false.
	itemInfoByFirstToken := Dictionary new
		at: 'SMALLTALK' put: #(#smalltalk #getSmalltalkItemContents #fileInSmalltalkItem:);
		yourself.
	itemInfoBySecondToken := Dictionary new
		yourself.!

initializeForVersion10
	"	self
	Initialize myself to be ready to read a Version 1.0 file"

	itemInfoByFirstToken
		at: '"' put: #(#comment #getCommentItemContents #fileInCommentItem:);
		at: 'ANNOTATION' put: #(#annotation #getAnnotationItemContents #fileInAnnotationItem:);
		at: 'CLASS' put: #(#class #getClassItemContents #fileInClassItem:);
		at: 'POOL' put: #(#pool #getPoolItemContents #fileInPoolItem:).
	itemInfoBySecondToken
		at: 'METHOD' put: #(#method #getMethodItemContents #fileInMethodItem:);
		at: 'CLASSMETHOD' put: #(#classMethod #getClassMethodItemContents #fileInClassMethodItem:);
		at: 'INITIALIZER' put: #(#initializer #getInitializerItemContents #fileInInitializerItem:);
		at: 'INITIALIZERFOR:' put: #(#initializerFor #getInitializerForItemContents #fileInInitializerForItem:);
		at: 'VARIABLE:' put: #(#variable #getVariableItemContents #fileInVariableItem:);
		at: 'CONSTANT:' put: #(#constant #getConstantItemContents #fileInConstantItem:).!

initializeForVersion10Extended
	"	self
	Initialize myself to be ready to read a Version 1.0 extended file."

	self initializeForVersion10.
	itemInfoByFirstToken at: 'PACKAGE' put: #(#package #getPackageItemContents #fileInPackageItem:).! !

SmalltalkInterchangeFileInManager class
	instanceVariableNames: ''!



!SmalltalkInterchangeFileInManager class methodsFor: 'testing'!

isAbstract
	"	^	<Boolean>
	Return true if I represent an abstract class.
	See concreteClasses for a list of concrete classes."

	^self == SmalltalkInterchangeFileInManager! !

!SmalltalkInterchangeFileInManager class methodsFor: 'accessing'!

defaultName
	"	^	<Symbol>
	Return the name to be used when looking up which manager should be the default for filing in code."

	^#fileInManager! !

Object subclass: #SmalltalkInterchangeFileItem
	instanceVariableNames: 'manager info firstToken name classItemInfo value annotations '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SIF-Support'!



!SmalltalkInterchangeFileItem methodsFor: 'class item'!

classInstVarNames
	"	^	<String> | nil
	Return the classInstVarNames for me."

	^self classItemInfoAt: 6!

classInstVarNames: object
	"	object	<String> | nil
		^		self
	Set the classInstVarNames for me."

	self classItemInfoAt: 6 put: object!

classItemInfoAt: i
	"	i	<Integer>
		^	<Object>
	Return whatever is contained in my class item info at item i."

	classItemInfo isNil ifTrue: [
		^nil].
	^classItemInfo at: i!

classItemInfoAt: i put: object
	"	i	<Integer>
		^	<Object>
	Place object in my class item info at item i."

	classItemInfo isNil ifTrue: [
		classItemInfo := Array new: 6].
	classItemInfo at: i put: object.
	^object!

classVarNames
	"	^	<String> | nil
	Return the classVarNames for me."

	^self classItemInfoAt: 4!

classVarNames: object
	"	object	<String> | nil
		^		self
	Set the classVarNames for me."

	self classItemInfoAt: 4 put: object!

instVarNames
	"	^	<String> | nil
	Return the instVarNames for me."

	^self classItemInfoAt: 3!

instVarNames: object
	"	object	<String> | nil
		^		self
	Set the instVarNames for me."

	self classItemInfoAt: 3 put: object!

instVarType
	"	^	<String> | nil
	Return the instVarType for me."

	^self classItemInfoAt: 2!

instVarType: object
	"	object	<String> | nil
		^		self
	Set the instVarType for me."

	self classItemInfoAt: 2 put: object!

sharedPoolNames
	"	^	<String> | nil
	Return the sharedPoolNames for me."

	^self classItemInfoAt: 5!

sharedPoolNames: object
	"	object	<String> | nil
		^		self
	Set the sharedPoolNames for me."

	self classItemInfoAt: 5 put: object!

superclassName
	"	^	<String> | nil
	Return the superclassName for me."

	^self classItemInfoAt: 1!

superclassName: object
	"	object	<String> | nil
		^		self
	Set the superclassName for me."

	self classItemInfoAt: 1 put: object! !

!SmalltalkInterchangeFileItem methodsFor: 'annotation'!

addAnnotation: item
	"	item		<self>
		^		self
	Add item to my list of annotations."

	annotations isNil ifTrue: [
		annotations := OrderedCollection new].
	annotations add: item!

annotationNamed: lookFor
	"	lookFor	<String>
		^		<SmalltalkInterchangeFileItem> | nil
	Return the annotation that has it's name matching lookFor.
	Case does not matter."

	| upper |
	annotations isNil ifTrue: [^nil].
	upper := self manager uppercaseString: lookFor.
	annotations do: [:each |
		(self manager uppercaseString: each name) = upper ifTrue: [
			^each]].
	^nil!

annotations
	"	^	<OrderedCollection withAll: <self>>
	Return all of the annotations that are attached to me."

	^annotations isNil
		ifTrue: [#()]
		ifFalse: [annotations]!

annotationsPrefixedWtih: prefix
	"	prefix	<String>
		^	<Collection withAll: <self>>
	Return all of my anotations that have begin with the prefix prefix.
	Case does not matter."

	| lookFor |
	lookFor := self uppercaseString: prefix.
	^self annotations select: [:each |
		( self uppercaseString: (each name copyFrom: 1 to: lookFor size)) = lookFor]!

categoriesAnnotation
	"	^		<SmalltalkInterchangeFileItem> | nil
	Retur the appropriate annotation."

	^self annotationNamed: 'categories'!

categoryAnnotation
	"	^		<SmalltalkInterchangeFileItem> | nil
	Retur the appropriate annotation."

	^self annotationNamed: 'category'!

commentAnnotation
	"	^		<SmalltalkInterchangeFileItem> | nil
	Retur the appropriate annotation."

	^self annotationNamed: 'comment'!

packageAnnotation
	"	^		<SmalltalkInterchangeFileItem> | nil
	Retur the appropriate annotation."

	^self annotationNamed: 'package'! !

!SmalltalkInterchangeFileItem methodsFor: 'testing'!

isAnnotation
	"	^	<Boolean>
	Return true if I am an annotation item."

	^self type == #annotation!

isSmalltalkItem
	"	^	<Boolean>
	Return true if I am an annotation item."

	^self type == #smalltalk! !

!SmalltalkInterchangeFileItem methodsFor: 'accessing'!

firstToken
	"	^	<String> | nil
	Return the firstToken for me."

	^firstToken!

firstToken: object
	"	object	<String> | nil
		^		self
	Set the firstToken for me."

	firstToken := object!

info
	"	^	<Array withAll: <Symbol>>
	Retur the array that contains the type and selectors to process me."

	^info!

info: object
	"	object	<Array withAll: <Symbol>>
	Set the array that contains the type and selectors to process me."

	info := object!

manager
	"	^	<SmalltalkInterchangeFileManager>
	Return the manager that owns me."

	^manager!

manager: object
	"	object		<SmalltalkInterchangeFileManager>
		^		self
	Set the manager that owns me."

	manager := object!

name
	"	^	<String> | nil
	Return the name for me."

	^name!

name: object
	"	object	<String> | nil
		^		self
	Set the name for me."

	name := object!

type
	"	^	<Symbol>
	Return the type of item I am."

	^self info at: 1!

value
	"	^	<String> | nil
	Return the value for me."

	^value!

value: object
	"	object	<String> | nil
		^		self
	Set the value for me."

	value := object! !

!SmalltalkInterchangeFileItem methodsFor: 'parsing/file in'!

fileIn
	"	^	self
	Install whatever item I represent onto the current system."

	self manager perform: (self info at: 3) with: self!

getContents
	"	^	self
	Initialize my contents to whatever is found in my manager's stream."

	self manager perform: (self info at: 2)! !

!SmalltalkInterchangeFileItem methodsFor: 'printing'!

attributesToPrint
	"	^	<Array withAll: <Symbol>>
	Return the attributes to be printed."

	^#(#type #firstToken #name #superclassName #instVarType #instVarNames #classVarNames #sharedPoolNames #classInstVarNames #value)!

printOn: stream

	super printOn: stream.
	stream nextPutAll: '('.
	self attributesToPrint do: [:each |
		(self perform: each) isNil ifFalse: [
			stream cr; tab; nextPutAll: each; nextPutAll: ': '.
			(self perform: each) printOn: stream]].
	stream nextPut: $)! !

SmalltalkInterchangeFileItem class
	instanceVariableNames: ''!


SmalltalkInterchangeFileManager initialize!


