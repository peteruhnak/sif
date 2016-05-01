adding
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

	self addItem: newEntry ofType: #Package.