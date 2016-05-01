item
nextItem
	"	^	<SmalltalkInterchangeFileItem> | nil
	Return the next item, excluding annotations, found on my stream.
	The annotations that should be attached to this item will be part of that
	items annotations."

	| item |
	nextItem isNil
		ifTrue: [self primNextItem]
		ifFalse: [
			currentItem := nextItem.
			nextItem := nil].
	currentItem isNil ifTrue: [^nil].
	self isSmalltalkItemProcessed ifFalse: [
		self checkAndSetupVersion].
	currentItem isAnnotation ifTrue: [
		self error: 'Cannot have an annotation before there is an element to attach annotations to.'].
	item := currentItem.
	[self primNextItem.
	currentItem notNil and: [currentItem isAnnotation]] whileTrue: [
		item addAnnotation: currentItem].
	nextItem := currentItem.
	^currentItem := item