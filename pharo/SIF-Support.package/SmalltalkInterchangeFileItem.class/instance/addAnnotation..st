annotation
addAnnotation: item
	"	item		<self>
		^		self
	Add item to my list of annotations."

	annotations isNil ifTrue: [
		annotations := OrderedCollection new].
	annotations add: item