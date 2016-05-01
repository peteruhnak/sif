fileout info
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

	| methods eachClass |
	methods := OrderedCollection new: 64.
	(SystemOrganization listAtCategoryNamed: name asSymbol) do: [:eachClassName |
		eachClass := Smalltalk at: eachClassName.
		eachClass selectors do: [:each |
			methods add: (Array with: each with: eachClass)]].
	^Dictionary new
		at: #name put: name;
		at: #classes put: ((SystemOrganization listAtCategoryNamed: name asSymbol)
			collect: [:each | Smalltalk at: each]);
		at: #methods put: methods;
		at: #preInstallCode put: '';
		at: #postInstallCode put: '';
		at: #preUnInstallCode put: '';
		at: #postUnInstallCode put: '';
		yourself