accessing
classOfBehavior: class
	"	class		<Behavior>
		^		<Class>
	If class is a Class then return it, if not then class is a metaclass,
	return it's sole instance."
	"
	SmalltalkInterchangePharoFileOutManager new classOfBehavior: Class
	SmalltalkInterchangePharoFileOutManager new classOfBehavior: Class class
	"

	^class isMeta
		ifTrue: [class soleInstance]
		ifFalse: [class]