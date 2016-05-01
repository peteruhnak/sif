fileout
fileOutInitializer: initializer forName: name
	"	initializer	<String>
		name		<String>
		^		void
	File out the an initializer whose code is initializer for a global or class named name."

	self cr;
		nextPutAll: name;
		nextPutAll: ' initializer';
		nextChunkPut: '';
		cr;
		nextChunkPut: initializer.