parsing/file in
getContents
	"	^	self
	Initialize my contents to whatever is found in my manager's stream."

	self manager perform: (self info at: 2)