streaming
upTo: char
	"	char		<Character>
		^		<String>
	Return a string containing all characters starting from current position, up to but
	but not including char."

	^self managedStream upTo: char