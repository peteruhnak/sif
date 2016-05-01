fileout
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
			fileOutAnnotationKey: 'package-postInstallCode' value: (item at: #postInstallCode)].