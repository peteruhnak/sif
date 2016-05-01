streaming
nextWord
	"	^			<String> | nil
	Return the next word found on my managed stream.  If I reach the end of the stream before
	finding a word, then return nil.
	I skip any current whitespcae, start collecting, and stop at the first white space."

	self subclassResponsibility