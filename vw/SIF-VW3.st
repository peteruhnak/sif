'From VisualWorks®, Release 3.0 of February 5, 1998 on April 3, 2000 at 9:55:52 am'!


SmalltalkInterchangeFileOutManager subclass: #SmalltalkInterchangeVW3FileOutManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SIF-VW3'!



!SmalltalkInterchangeVW3FileOutManager methodsFor: 'opening/closing'!

newStreamOnFileNamed: file
	"	file	<String>
		^	<ReadStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	^file asFilename writeStream! !

!SmalltalkInterchangeVW3FileOutManager methodsFor: 'fileout info'!

classDefinitionInfoFor: class
	"	class	<Behavior>
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

	| annotations |
	annotations := Dictionary new
		at: 'package' put: class category asString;
		yourself.
	class comment notNil ifTrue: [
		annotations at: 'comment' put: class comment ].
	^Dictionary new
		at: #name put: class name asString;
		at: #superclassName put: (class superclass isNil
			ifTrue: ['']
			ifFalse: [class superclass name asString]);
		at: #instVarType put: (class isVariable
			ifTrue: [ class isBits 
				ifTrue: [#byte]
				ifFalse: [#object] ]
			ifFalse: [#none]);
		at: #instVarNames put: class instVarNames;
		at: #classVarNames put: class classVarNames;
		at: #poolVarNames put: class sharedPools;
		at: #classInstVarNames put: class class instVarNames;
		at: #annotations put: annotations;
		yourself!

classOfBehavior: class
	"	class		<Behavior>
		^		<Class>
	If class is a Class then return it, if not then class is a metaclass,
	return it's sole instance."
	"
	SmalltalkInterchangeDolphinFileOutManager new classOfBehavior: Class
	SmalltalkInterchangeDolphinFileOutManager new classOfBehavior: Class class
	"

	^class isMeta
		ifTrue: [class soleInstance]
		ifFalse: [class]!

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

	| result |
	result := Dictionary new.
	result at: #className put: (self nameForClass: class);
		at: #isClassMethod put: class isMeta.
	(result at: #source put: (class sourceCodeAt: methodName)) isNil ifTrue: [
		self error: 'There is no source for this method'].
	result at: #source put: (result at: #source) asString.
	result at: #annotations put: (Dictionary new
		at: 'category' put: (class whichCategoryIncludesSelector: methodName) asString;
		yourself).
	^result!

packageItemInfoFor: name
	"	name	<String>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on the package named name
		#name			<String>
		#classes			<Class>
		#methods			<Collection withAll: <CompiledMethod>>
		#preInstallCode		<String>
		#postInstallCode		<String>
		#preUnInsrallCode	<String>
		#postUninstallCode	<String>
	"

	| methods |
	methods := OrderedCollection new: 64.
	(Smalltalk organization listAtCategoryNamed: name asSymbol) do: [:eachClassName |
		| eachClass eachMetaClass |
		eachClass := Smalltalk at: eachClassName.
		eachMetaClass := eachClass class.
		eachClass selectors do: [:each |
			methods add: (Array with: each with: eachClass)].
		eachMetaClass selectors do: [:each |
			methods add: (Array with: each with: eachMetaClass)]].
	^Dictionary new
		at: #name put: name;
		at: #classes put: ((Smalltalk organization listAtCategoryNamed: name asSymbol)
			collect: [:each | Smalltalk at: each]);
		at: #methods put: methods;
		at: #preInstallCode put: '';
		at: #postInstallCode put: '';
		at: #preUnInstallCode put: '';
		at: #postUnInstallCode put: '';
		yourself!

poolVariableItemInfoFor: variableName in: pool
	"	variableName	<String>
		pool			<Dictionary key: <String> value: <Object>>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on method
		#isConstant	<Boolean>
		#initializer		<String>
	"

	^Dictionary new
		at: #isConstant put: false;
		at: #initializer put: (pool at: variableName) printString;
		yourself! !

SmalltalkInterchangeVW3FileOutManager class
	instanceVariableNames: ''!



!SmalltalkInterchangeVW3FileOutManager class methodsFor: 'initialization'!

initialize
	"	^	self
	Initialize everything that is needed for my being used by the Dolphin dialect."
	"
	SmalltalkInterchangeVW3FileOutManager initialize
	"

		"This is here only to allow the file in of the code to put the
			do it to init me."
	super initialize.! !

SmalltalkInterchangeFileInManager subclass: #SmalltalkInterchangeVW3FileInManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SIF-VW3'!



!SmalltalkInterchangeVW3FileInManager methodsFor: 'opening/closing'!

newStreamOnFileNamed: file
	"	file	<String>
		^	<ReadStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	| filename |
	filename := file asFilename.
	filename exists ifFalse: [
		self error: 'Non-existent file named: ', file printString].
	^filename readStream! !

!SmalltalkInterchangeVW3FileInManager methodsFor: 'streaming'!

nextWord
	"	^			<String> | nil
	Return the next word found on my managed stream.  If I reach the end of the stream before
	finding a word, then return nil.
	I skip any current whitespcae, start collecting, and stop at the first white space."

	"| s m |
	s := ReadStream on: 'hello world'.
	m := SmalltalkInterchangeSqueakFileInManager new.
	m nextWordOn: s.
	m nextWordOn: s"

	| result done next |
	self skipWhiteSpace.
	done := false.
	result := WriteStream on: (String new: 32).
	[self atEnd or: [done]] whileFalse: [
		next := self managedStream next.
		next isSeparator
			ifTrue: [
				done := true.
				self managedStream skip: -1]
			ifFalse: [result nextPut: next]].
	result size = 0 ifTrue: [
		^nil].
	^result contents! !

!SmalltalkInterchangeVW3FileInManager methodsFor: 'filein'!

fileInClassItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is a class item that needs to be processed.
	Item attributes:
	Item attributes:
		name				<String> 'named:'
		superclassName		<String> 'superclass:'
		instVarType			#none | #byte | #object 'indexedInstanceVariables:'
		instVarNames		<String>'instanceVariableNames:'
		classVarNames		<String> 'classVariableNames:'
		sharedPoolNames	<String> 'sharedPools:'
		classInstVarNames	<String> 'classInstanceVariableNames:'
	item annotations
		package
		comment
	"

	| result package comment selector superclass |
	selector := 'ubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'.
	selector := (item instVarType == #none
		ifTrue: [ 's', selector ]
		ifFalse: [ item instVarType == #object
			ifTrue: [ 'variableS', selector ]
			ifFalse: [ item instVarType == #byte
				ifTrue: [ 'variableByteS', selector ]
				ifFalse: [ self error: 'Unsuported class format ', item instVarType ]]]) asSymbol.
	package := (package := item packageAnnotation) isNil
		ifTrue: ['None Specified-SIF']
		ifFalse: [package value].
	superclass := item superclassName isEmpty
		ifTrue: [ nil ] "these are nil subclasses"
		ifFalse: [ Smalltalk at: item superclassName asSymbol ].
	result := superclass
		perform: selector
		withArguments: ((Array new: 5)
			at: 1 put: item name asSymbol;
			at: 2 put: item instVarNames;
			at: 3 put: item classVarNames;
			at: 4 put: item sharedPoolNames;
			at: 5 put: package;
			yourself).
	result class instanceVariableNames: item classInstVarNames.
	(comment := item commentAnnotation) notNil ifTrue: [
		result comment: comment ].!

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

	| method |
	method := item categoryAnnotation isNil
		ifTrue: [class compile: item value]
		ifFalse: [class compile: item value classified: item categoryAnnotation value].
	method isNil ifTrue: [
		self error: 'Compile error.'].!

handleAnnotationsOnGlobalInitializerItem: item
	"	item	<SmalltalkInterchangeFileItem>
		^	void
	item is an initializer item that needs to be processed.  I am called by the generic handler
	in order to handle the annotations on the item.
	Item attributes:
		firstToken		Global name
		value		Code to eval
	item annotations
		Package-PreInstallCode
		Package-PreUnInstallCode
		Package-PostInstallCode
		Package-PosUntInstallCode"

	| annotation missing |
	annotation := item annotationNamed: 'package-preRequisites'.
	annotation isNil ifFalse: [
		missing := Set new.
		(self collectionOfStringsFrom: annotation value) do: [:each |
			(Smalltalk organization categories includes: each) ifFalse: [
				missing add: each]].
		missing isEmpty ifFalse: [
			Transcript cr; show: '### SIF: Missing pre-requisites:'.
			missing asSortedCollection do: [:each |
				Transcript cr; tab; show: each]]]! !

SmalltalkInterchangeVW3FileInManager class
	instanceVariableNames: ''!



!SmalltalkInterchangeVW3FileInManager class methodsFor: 'initializing'!

initialize
	"	^	self
	Initialize everything that is needed for my being used by the Dolphin dialect."
	"
	SmalltalkInterchangeVW3FileInManager initialize
	"

		"This is here only to allow the file in of the code to put the
			do it to init me."
	super initialize.! !

!SmalltalkInterchangeVW3FileInManager class methodsFor: 'bootstrap'!

bootstrap
	"SmalltalkInterchangeFileManager newForFileIn
		fileName: '../sif/sif-support.sif';
		fileIn

	SmalltalkInterchangeFileManager newForFileIn
		fileName: '../sif/SifTestAll.sif';
		fileIn"! !

SmalltalkInterchangeVW3FileOutManager initialize!

SmalltalkInterchangeVW3FileInManager initialize!


