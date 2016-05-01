fileout info
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

	^Dictionary new
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
		at: #poolVarNames put: class sharedPools;
		at: #classInstVarNames put: class class instVarNames;
		at: #annotations put: (Dictionary new
			"at: 'comment' put: '';."
			at: 'package' put: class category asString;
			yourself);
		yourself