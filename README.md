# SIF - Smalltalk Interchange File format

SIF Smalltalk Interchange File is a dialect-neutral format for file-out exchange between various dialects.

**NOTE:** *this repository exists primarily to provide an easily accessible place to load the project into Pharo and make the docs available, however it is not being actively developed*


## About

In the ANSI NCITS 319-1998 Standard for Smalltalk, there is the definition of a Smalltalk Interchange File (SIF). This toolkit supports the reading and writing of such files for many dialects. A SIF contains ascii text that describes a Smalltalk program in such a way as to be able to read the file and regenerate the original program this file was created from. Simply put, it's a standard that supports the filing out of code from one Smalltalk dialect, into another.


## Dialects

The following dialects should be supported:

* Pharo
* Squeak
* VW3+
* VA4
* Dolphin

However loading instructions are TODO.

You can find more info [here](http://www.samadhiweb.com/blog/2016.01.06.sif.html) and [here](http://www.pocketsmalltalk.com/sif/).

Until now the package was only available as a zip which isn't particularly helpful for dependencies.

## Loading

### Pharo

```st
Metacello new
	baseline: 'SIF';
	repository: 'github://peteruhnak/sif/pharo';
	load.
```

### Squeak

TODO

### VW

TODO

### Dolphin

TODO

### VA4

TODO

## Docs

see [docs.md](docs.md)

## License

This code is released under MIT with the permission of its original authors Eric Arseneau (SIF) and Martin Kobetic (VW port).
