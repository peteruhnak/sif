!STB 0 F    Package    6  String   SIF-Dolphinr      SIF-Dolphin.pacr        STBCollectionProxy    N    STBClassProxy    r      Dolphinr      IdentitySet&  Array    STBSymbolProxy    r   *   SmalltalkInterchangeDolphin2FileOutManager:      r   )   SmalltalkInterchangeDolphin2FileInManager:      r   *   SmalltalkInterchangeDolphin3FileOutManager:      r   )   SmalltalkInterchangeDolphin3FileInManager�       �       �   r      Set      �       �   �  �       �        r      SIF-Support�       STBIdentityDictionaryProxy    �       �   r      IdentityDictionary     :      r      postuninstallr       :      r      preuninstall�  :      r      postinstallr       :      r   
   preinstall�  �       �  �          r           � SmalltalkInterchangeFileInManager subclass: #SmalltalkInterchangeDolphin2FileInManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

SmalltalkInterchangeDolphin2FileInManager subclass: #SmalltalkInterchangeDolphin3FileInManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

SmalltalkInterchangeFileOutManager subclass: #SmalltalkInterchangeDolphin2FileOutManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

SmalltalkInterchangeDolphin2FileOutManager subclass: #SmalltalkInterchangeDolphin3FileOutManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''!

'end-class-definition'! X    

SmalltalkInterchangeDolphin2FileInManager class instanceVariableNames: ''!

SmalltalkInterchangeDolphin2FileInManager comment: ''!

SmalltalkInterchangeDolphin2FileInManager guid: (GUID fromString: '{AAE80D04-E13F-11D3-9C31-00A0CC265D13}')!

!SmalltalkInterchangeDolphin2FileInManager categoriesForClass!No category! !

!SmalltalkInterchangeDolphin2FileInManager methodsFor!

addCategories: categories toMethod: method
	"	categories		<Collection withAll: <>>
		method		<CompiledMethod>
		^	void
	There is a subtle difference between how Dolphin Version 2.x and 3.x deal with method categories."

	method addToCategories: categories;
			storeCategories!

declareIfNecessaryPackageNamed: name
	"	name		<String>
		^		<Package>
	If there is already a package by the name of name, then do nothing.
	If it does not exist then create it."

	^PackageManager current at: name ifAbsent: [
		PackageManager current addPackage: (Package name: name)]!

declarePool: name
	"	name		<String>
		^	void
	Declare a Pool named name"

	Smalltalk at: name asSymbol ifAbsentPut: [
		PoolDictionary new].!

declarePoolConstant: constantName in: poolName
	"	constantName	<String>
		poolName		<String>
		^	void
	item is a constant definition for a pool."

	| pool |
	pool := Smalltalk at: poolName asSymbol ifAbsent: [
		self error: 'The pool dictionary ', poolName printString, ' should have been defined first.'].
	(pool isKindOf: PoolConstantsDictionary) ifFalse: [
		pool isEmpty ifFalse: [
			self error: 'Cannot declare the constant ', constantName printString, ' inside the variable pool ', poolName printString].
		Smalltalk at: poolName asSymbol put: PoolConstantsDictionary new].
	pool at: constantName put: nil!

declarePoolVariable: variableName in: poolName
	"	variableName	<String>
		poolName		<String>
		^	void
	item is a variable definition for a pool."

	| pool |
	pool := Smalltalk at: poolName asSymbol ifAbsent: [
		self error: 'The pool dictionary ', poolName printString, ' should have been defined first.'].
	(pool isKindOf: PoolConstantsDictionary) ifTrue: [
		self error: 'Cannot declare the variable ', variableName printString, ' inside the constant pool ', poolName printString].
	pool at: variableName put: nil!

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

	| result package |
	item instVarType == #none ifFalse: [
		item instVarType == #byte ifTrue: [].
		item instVarType == #object ifTrue: [].
		self error: 'Have not added support for variable subclasses yet'].
	result := (Smalltalk at: item superclassName asSymbol)
		subclass: item name asSymbol
		instanceVariableNames: item instVarNames
		classVariableNames: item classVarNames
		poolDictionaries: item sharedPoolNames.
	result class instanceVariableNames: item classInstVarNames.
	(package := item packageAnnotation) isNil ifFalse: [
		package := self declareIfNecessaryPackageNamed: package value.
		PackageManager current addClass: result to: package]!

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

	| method categories package |
	method := class compile: item value.
	method isNil ifTrue: [
		self error: 'Compile error.'].
	item categoriesAnnotation isNil
		ifTrue: [
			item categoryAnnotation isNil ifFalse: [
				categories := Array with: item categoryAnnotation value]]
		ifFalse: [
			categories := self collectionOfStringsFrom: item categoriesAnnotation value].
	categories isNil ifFalse: [
		categories := categories collect: [:each |
			class methodCategoryClass name: each].
		self addCategories: categories toMethod: method].
	(package := item packageAnnotation) isNil ifFalse: [
		package := self declareIfNecessaryPackageNamed: package value.
		PackageManager current addMethod: method to: package]!

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

	| annotation package |
		"No package specified, so do nothing."
	item packageAnnotation isNil ifTrue: [^self].
	package := self declareIfNecessaryPackageNamed: item packageAnnotation value.
	#(
		#('package-preInstallCode' #preinstall)
		#('package-preUnInstallCode' #preuninstall)
		#('package-postInstallCode' #postinstall)
		#('package-postUnInstallCode' #postuninstall)
	) do: [:info |
		annotation := item annotationNamed: info first.
		annotation isNil ifFalse: [
			package script: info last put: annotation value]].!

newStreamOnFileNamed: file
	"	file	<String>
		^	<ReadStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	^FileStream read: file!

nextWord
	"	^			<String> | nil
	Return the next word found on my managed stream.  If I reach the end of the stream before
	finding a word, then return nil.
	I skip any current whitespcae, start collecting, and stop at the first white space."

	^self managedStream skipSeparators; nextWord! !

!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #addCategories:toMethod:!accessing!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #declareIfNecessaryPackageNamed:!declaring!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #declarePool:!declaring!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #declarePoolConstant:in:!declaring!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #declarePoolVariable:in:!declaring!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #fileInClassItem:!filein!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #fileInMethodItem:intoClass:!filein!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #handleAnnotationsOnGlobalInitializerItem:!filein!public! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #newStreamOnFileNamed:!public!streaming! !
!SmalltalkInterchangeDolphin2FileInManager categoriesFor: #nextWord!public!streaming! !

!SmalltalkInterchangeDolphin2FileInManager class methodsFor!

bootstrap
	"
	SmalltalkInterchangeFileManager newForFileIn
		fileName: 'sif-support.sif';
		fileIn

	SmalltalkInterchangeFileManager newForFileIn
		fileName: 'C:\Dev\Dolphin Smalltalk 98\SifTestAll.sif';
		fileIn
	"!

initialize
	"	^	self
	Initialize everything that is needed for my being used by the Dolphin dialect."
	"
	SmalltalkInterchangeDolphin2FileInManager initialize
	"

	| defaults |
	defaults := (Class respondsTo: #categoriesOf:)
		ifTrue: [Array with: SmalltalkInterchangeDolphin2FileInManager with: SmalltalkInterchangeDolphin2FileOutManager]
		ifFalse: [Array with: SmalltalkInterchangeDolphin3FileInManager with: SmalltalkInterchangeDolphin3FileOutManager].
	SmalltalkInterchangeFileManager
		defaultAt: SmalltalkInterchangeFileInManager defaultName put: (defaults at: 1);
		defaultAt: SmalltalkInterchangeFileOutManager defaultName put: (defaults at: 2).! !

!SmalltalkInterchangeDolphin2FileInManager class categoriesFor: #bootstrap!filein!public! !
!SmalltalkInterchangeDolphin2FileInManager class categoriesFor: #initialize!initializing!public! !



SmalltalkInterchangeDolphin3FileInManager class instanceVariableNames: ''!

SmalltalkInterchangeDolphin3FileInManager comment: ''!

SmalltalkInterchangeDolphin3FileInManager guid: (GUID fromString: '{AAE80D12-E13F-11D3-9C31-00A0CC265D13}')!

!SmalltalkInterchangeDolphin3FileInManager categoriesForClass!Unclassified! !

!SmalltalkInterchangeDolphin3FileInManager methodsFor!

addCategories: categories toMethod: method
	"	categories		<Collection withAll: <>>
		method		<CompiledMethod>
		^	void
	There is a subtle difference between how Dolphin Version 2.x and 3.x deal with method categories."

	method categories: (method categories copy asSet addAll: categories; yourself);
		storeCategories! !

!SmalltalkInterchangeDolphin3FileInManager categoriesFor: #addCategories:toMethod:!accessing!public! !



SmalltalkInterchangeDolphin2FileOutManager class instanceVariableNames: ''!

SmalltalkInterchangeDolphin2FileOutManager comment: ''!

SmalltalkInterchangeDolphin2FileOutManager guid: (GUID fromString: '{AAE80D05-E13F-11D3-9C31-00A0CC265D13}')!

!SmalltalkInterchangeDolphin2FileOutManager categoriesForClass!No category! !

!SmalltalkInterchangeDolphin2FileOutManager methodsFor!

categoriesOfMethod: method
	"	method	<CompiledMethod>
		^		<Collection withAll: <>>
	Return the categories of method.
	There is a slight difference between Dolphin Verison 2.x and 3.x."

	^method methodClass categoriesOf: method selector!

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

	| result annotations package |
	result := Dictionary new.
	result
		at: #name put: class name asString;
		at: #superclassName put: (class superclass isNil ifTrue: [''] ifFalse: [class superclass name asString]);
		at: #instVarType put: (class isVariable
			ifTrue: [ 
				class isBytes 
					ifTrue: [#byte]
					ifFalse: [#object] ]
			ifFalse: [#none]);
		at: #instVarNames put: class instVarNames;
		at: #classVarNames put: class classVarNames;
		at: #poolVarNames put: class sharedPoolNames;
		at: #classInstVarNames put: class class instVarNames.
	annotations := Dictionary new.
	"result at: 'comment' put: '';."
	package := PackageManager current packageOfClass: class.
	package isNil ifFalse: [
		annotations at: 'package' put: package name].
	result at: #annotations put: annotations.
	^result!

classOfBehavior: class
	"	class		<Behavior>
		^		<Class>
	If class is a Class then return it, if not then class is a metaclass,
	return it's sole instance."
	"
	SmalltalkInterchangeDolphinFileOutManager new classOfBehavior: Class
	SmalltalkInterchangeDolphinFileOutManager new classOfBehavior: Class class
	"

	^(class isKindOf: Metaclass)
		ifTrue: [class instanceClass]
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

	| result method package categories stream annotations |
	method := class compiledMethodAt: methodName.
	result := Dictionary new.
	result at: #className put: (self nameForClass: class);
		at: #isClassMethod put: (self classOfBehavior: class) ~~ class;
		at: #source put: method getSource.
	annotations := Dictionary new.
	categories := (self categoriesOfMethod: method) collect: [:each |
		each name].
	categories remove: 'no category' ifAbsent: [].
	package := PackageManager current packageOfMethod: method.
	package isNil ifFalse: [
		annotations at: 'package' put: package name].
	categories isEmpty ifFalse: [
		annotations at: 'category' put: categories asSortedCollection first.
		categories size > 1 ifTrue: [
			annotations at: 'categories' put: categories]].
	result at: #annotations put: annotations.
	^result!

newStreamOnFileNamed: file
	"	file	<String>
		^	<WriteStream>
	Return a stream that is opened on the file named file.
	If I am meant to write them return a write stream, read then a read strea."

	^FileStream write: file!

packageItemInfoFor: name
	"	name	<String>
		^		<Dictionary key: <Symbol> value: <Object>>
	Return info on the package named name
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

	| package result |
	package := PackageManager current at: name ifAbsent: [
		self error: 'No package was found named: ', name printString].
	^Dictionary new
		at: #name put: name;
		at: #classes put: package classes;
		at: #methods put: (package allMethods asArray collect: [:each | Array with: each selector with: each methodClass]);
		at: #preInstallCode put: (package script: #preinstall);
		at: #postInstallCode put: (package script: #postinstall);
		at: #preUnInstallCode put: (package script: #preuninstall);
		at: #postUnInstallCode put: (package script: #postuninstall);
		at: #preRequisiteNames put: package prerequisiteNames;
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
		at: #isConstant put: (pool isKindOf: PoolConstantsDictionary);
		at: #initializer put: (pool at: variableName) printString;
		yourself! !

!SmalltalkInterchangeDolphin2FileOutManager categoriesFor: #categoriesOfMethod:!accessing!public! !
!SmalltalkInterchangeDolphin2FileOutManager categoriesFor: #classDefinitionInfoFor:!fileout info!public! !
!SmalltalkInterchangeDolphin2FileOutManager categoriesFor: #classOfBehavior:!accessing!public! !
!SmalltalkInterchangeDolphin2FileOutManager categoriesFor: #methodItemInfoFor:ofClass:!fileout info!public! !
!SmalltalkInterchangeDolphin2FileOutManager categoriesFor: #newStreamOnFileNamed:!public!streaming! !
!SmalltalkInterchangeDolphin2FileOutManager categoriesFor: #packageItemInfoFor:!fileout info!public! !
!SmalltalkInterchangeDolphin2FileOutManager categoriesFor: #poolVariableItemInfoFor:in:!fileout info!public! !



SmalltalkInterchangeDolphin3FileOutManager class instanceVariableNames: ''!

SmalltalkInterchangeDolphin3FileOutManager comment: ''!

SmalltalkInterchangeDolphin3FileOutManager guid: (GUID fromString: '{AAE80D13-E13F-11D3-9C31-00A0CC265D13}')!

!SmalltalkInterchangeDolphin3FileOutManager categoriesForClass!Unclassified! !

!SmalltalkInterchangeDolphin3FileOutManager methodsFor!

categoriesOfMethod: method
	"	method	<CompiledMethod>
		^		<Collection withAll: <>>
	Return the categories of method.
	There is a slight difference between Dolphin Verison 2.x and 3.x."

	^method methodClass categoriesOfMethod: method! !

!SmalltalkInterchangeDolphin3FileOutManager categoriesFor: #categoriesOfMethod:!accessing!public! !

 