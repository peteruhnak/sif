initializing
initialize
	"	^	self
	Set myself up to be ready to file out under Version 1.0."

	super initialize.
	addedItems := OrderedCollection new: 32.
		"Add at least one item such that I don't have to check for isEmpty on
			my add code."
	addedItems add: #(#() #Dummy).
	self initializeForVersion10