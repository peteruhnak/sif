streaming
pushStream: stream while: while
	"	stream	<Stream>
		while		[<Object>]
		^		stream
	Push stream onto my stream stack for the duration of the evaluation
	of while.  This means that any streaming operation
	I use will be done on the item on the top of the stream stack."

	self pushStream: stream.
	while value.
	self popStream