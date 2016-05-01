streaming
pushStream: stream
	"	stream		<Stream>
		^		stream
	Push stream onto my stream stack.  This means that any streaming operation
	I use will be done on the item on the top of the stream stack."

	managedStream := streamStack addLast: stream.
	^stream