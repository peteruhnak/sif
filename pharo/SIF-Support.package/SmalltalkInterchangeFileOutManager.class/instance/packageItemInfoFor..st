fileout info
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

	self subclassResponsibility