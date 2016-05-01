accessing
concreteClasses
	"	^	<Collection withAll: <Class>>
	Return a collection containing all of my subclasses that are concrete."
	"AnsiInterchangeFileManager concreteClasses"

	^self allSubclasses reject: [:each | each isAbstract]