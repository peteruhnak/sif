Smalltalk Interchange File Facility
by Eric Arseneau eat@huv.com

User Documentation

1.0 Introduction
----------------------
In the ANSI NCITS 319-1998 Standard for Smalltalk, there is the definition of a Smalltalk Interchange File (SIF).  This toolkit supports the reading and writing of such files for many dialects.  A SIF contains ascii text that describes a Smalltalk program in such a way as to be able to read the file and regenerate the original program this file was created from.  Simply put, it's a standard that supports the filing out of code from one Smalltalk dialect, into another.

This implementation adheres to the 1.0 definition of a SIF.  It does however, attempt to add additional features, while still keeping complete backward compatibility to 1.0.  These additional features were added to support the concept of a package to a SIF.  A package represents a different type of element for each dialect.  For Dolphin, a package corresponds to a package.  In Squeak, a package is a System Category.  In Visual Age, a package is an Application.  Packages do support pre & post install, pre & post uninstall, pre-requisites, complete classes, extensions to other classes.  For dialects where some of these elements are not supported, such as Squeak and VSE, these are ignored.  Please note, that the features of packages are supported while maintaining full compatibility to the 1.0 definition of a SIF.

The interface to this SIF facility is programatic.  There are no GUI elements provided to work with SIFs.  This is due to the fact that this facility is provided as the bare bones mechanism to support cross dialect file in and out.  The facility is broken into 2 layers, a support layer, and a dialect specific layer.  The support layer is implemented using the same IDENTICAL code on all platforms and provides most of the abstract support for SIF.  The dialect specific layer, is custom built for each dialect, and is comprised of the concrete services needed by the support layer.  The dialect specific layer is VERY small.  It has taken about 1-2 hours to port the facility to another dialect.

2.0 File Out
----------------
Here is an expression to file out a class using this SIF facility:
	SmalltalkInterchangeFileManager newForFileOut
		fileName: 'test.sif';
		addClass: Object;
		fileOut
This expression creates a new SIF manager, gives it the file name to which the file out is to go to, adds the class Object to the specification of the manager, then tells the manager to actually go ahead and create the file.

The order in which you add the various pieces to be filed out, is strictly kept.  This is to allow you to be able to file out various pieces of code and be able to have it file in and be in the same state as it was on file out.

2.1 File Out Protocol
-----------------------------
fileName: name <String>
Set the file name to create on file out.  If you wish to output to an already existing file or stream, then use the pushStream: protocol.

addClass: item <Class>
Will add the class item to the set of classes to be filed out.

addClasses: items <Collection withAll: <Class>>
Will add the classes in items to the set of classes to be filed out.

addClassesNamed: items <Collection withAll: <String>>
Will add the classes corresponding to the names in items to the set of classes to be filed out.

addClassNamed: item <String>
Will add the class corresponding to the name of item to the set of classes to be filed out.

addComment: item <String>
Add a comment to the file out spec.

addDoIt: item <String>
Add the expression in item as one to be evaled when the file in filed in.

addGlobalNamed: item <String>
Add the definition of the global name item.  Will have a nil value on file in.

addGlobalNamed: item <String> initializer: initializer nil | #default | <String>
Add the definition of the global name item.  If initializer is nil, then value is nil on file in.  If initializer is #default, then use the print string of the value of global item as the initializing expression.  If initializer is a String, then evaluate this expression at file in time to get the globals value.

addGlobalsNamed: items <Collection withAll: <String>>
Add the globals named in items to the list of globals to put out.  Their initializer will be nil.

addMethodNamed: item <Symbol> ofClass: class <Behavior>
Add the method named item of the class class to the the file out.

addPackage: item <Dictionary
	#name			<String>
	#classes			<Class>
	#methods			<Collection withAll: <Array with: <Symbol> with: <Behavior>>>
	#preInstallCode		<String>
	#postInstallCode		<String>
	#preUnInsrallCode		<String>
	#postUninstallCode		<String>>
If you wish to form you own package, then create one and use addPackage to get it into the file out.  This is typically used for dialects where there is limited support for some of the features that are provided by the various types of packages in the different dialects.

addPackageNamed: item <String>
Add the package named item to the file out.  A package corresponds to different things depending on the dialect.  For Squeak, a package is a system category, for Dolphin it's a package, for Visual Age it's an ENVY application.  This will cause all of the parts of a package to be filed out, classes, methods, init code, etc.
For Dolphin we support the filing out of preinstall, postinstall, preuninstall, postuninstall scripts, as well as the pre-requisites.  When these are filed into a dialect that can use these, they are kept, otherwise they are thrown away.  The classes are filed out into their appropriate packages, and methods that are part of a package are also kept that way.
For Squeak not much is kept, other than the system category the class was in.  Filing in a SIF file from other dialects still works, but information is lost.
For VisualAge we support the filing out of loaded, removed, ...  They are mapped to and from the Dolphin environment as well.

addPackages: items <Collection withAll: <Dictionary>>
A plural version of addPackage:.

addPackagesNamed: items <Collection withAll: <String>>
A plural version of addPackageNamed:.

addPoolNamed: item <String>
Add the definition of the pool named item, and all of it's variables.  Each variable will be init with nil.

addPoolNamed: item <String> initializer: initializer nil | #default | <Dictionary key: <String> value: <String>>
Add the definition of the pool named item, and all of it's variables.  Each variable will be init depending on what initializer is.  If initializer is nil, then the variables are defined with a nil value.  If initializer is #default, then the variables will be initialized with the expression formed by the print string of the variables value at file out.  If initializer is a Dictionary, then each key has a value which corresponds to the expression to be used to initialize the variables value at file in time.

addPoolsNamed: items <Collection withAll: <String>>
The plural version of addPoolNamed:.

fileOut
Once you are done specifying the elements to be included in the file out, use this to cause the appropriate text to be put onto the stream you specified.  If you specified a fileName, then a new file is created, the text placed into it, then the file automatically closed.  If you did a pushStream: to use a stream that you already had, then the text will be placed, but the stream will not be closed.

pushStream: stream <WriteStream on: <String>>
This is not a good name, but tough.  Basically, if a SIF manager has a stream stack that it uses to handle various things in as platform independent way as it can.  If you do not push a stream, then the manager will create one and push it when it needs to.  Please only push when you first create the manager, or just before you fileOut, and not after, things could get quite weird if you do.

3.0 File In
-------------
Here is an expression to file in a file created using this SIF facility:
	SmalltalkInterchangeFileManager newForFileIn
		fileName: 'test.sif';
		fileIn
This expression creates a new SIF manager, gives it the file name from which to read from, then tells the manager to actually go ahead and file in the contents of the file.

The error handling on file in is somewhat primitive, but you should be able to get by.

3.1 File In Protocol
--------------------------
fileName: name <String>
Set the file name to read from.  If you wish to read from an already existing file or stream, then use the pushStream: protocol.

fileIn
Causes all of the entries on my stream to be file in and processed.

pushStream: stream <WriteStream on: <String>>
This is not a good name, but tough.  Basically, if a SIF manager has a stream stack that it uses to handle various things in as platform independent way as it can.  If you do not push a stream, then the manager will create one and push it when it needs to.  Please only push when you first create the manager, or just before you fileIn, and not after, things could get quite weird if you do.

4.0 Design
--------------
Classes:
	SmalltalkInterchangeFileItem
	SmalltalkInterchangeFileManager
		SmalltalkInterchangeFileInManager
			SmalltalkInterchangeDialectSpecificFileInManager
		SmalltalkInterchangeFileOutManager
			SmalltalkInterchangeDialectSpecificFileOutManager

4.1 SmalltalkInterchangeFileItem
-------------------------------------------
Each element in a SIF file is read in by creating an instance of me and filling in the appropriate values.  An item can have annotations, which are themselves items.  The annotation to an item are parsed and attached to the item before the item is processed.

4.2 SmalltalkInterchangeFileManager
-------------------------------------------------
The top level interface and abstract class to the managers supporting SIF files.  Keeps track of a registry of which concrete classes to use for file in and file out.

4.3 SmalltalkInterchangeFileInManager
---------------------------------------------------
Provides the high level abstraction of filing in code.  Parses the items in the file and processes them.  Provides the streaming protocol to read in the contents of the stream speficied for the manager.

Why the initializeForVersion10, and the instance variables itemInfoByFirstToken and itemInfoBySecondToken? These are there in order to allow you to be able to do your own custom version of the file out and to use a different version identifier to do this.  It is also to allow me room to adjust if a new standard comes out.

4.4 SmalltalkInterchangeDialectSpecificFileInManager
-----------------------------------------------------------------------
Implements some of the platform specific aspects of filing in code: defining a new class, compiling methods and so on.

4.5 SmalltalkInterchangeFileOutManager
------------------------------------------------------
Provides the high level abstraction of filing out code.  Gathers all of the added items, and then processes them to generate the appropriate text.  Provides the streaming protocol to write to the stream speficied for the manager.

You might ask, why the hell have you first add the elements to file out, then force you to do a fileOut.  Well, it's simple actually.  The original idea was to be able to store these specifications of file outs in some form.  In order to do that I needed something I could store easily.  Well, the spec is stored as a collection of instructions, which is easy to store.

4.6 SmalltalkInterchangeDialectSpecificFileOutManager
--------------------------------------------------------------------------
Implements some of the platform specific aspects of filing out code: getting the necessary information on classes, providing the contents of a package..

5.0 Contact
----------------
http://www.PocketSmalltalk.com/sif
mailto:eat@huv.com
