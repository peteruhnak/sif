annotation
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
	^nil