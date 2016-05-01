file in
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
			(SystemOrganization categories includes: each) ifFalse: [
				missing add: each]].
		missing isEmpty ifFalse: [
			Transcript cr; show: '### SIF: Missing pre-requisites:'.
			missing asSortedCollection do: [:each |
				Transcript cr; tab; show: each]]]