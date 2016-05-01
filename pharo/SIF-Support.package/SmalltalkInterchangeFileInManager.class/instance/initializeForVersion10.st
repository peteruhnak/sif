initializing
initializeForVersion10
	"	self
	Initialize myself to be ready to read a Version 1.0 file"

	itemInfoByFirstToken
		at: '"' put: #(#comment #getCommentItemContents #fileInCommentItem:);
		at: 'ANNOTATION' put: #(#annotation #getAnnotationItemContents #fileInAnnotationItem:);
		at: 'CLASS' put: #(#class #getClassItemContents #fileInClassItem:);
		at: 'POOL' put: #(#pool #getPoolItemContents #fileInPoolItem:).
	itemInfoBySecondToken
		at: 'METHOD' put: #(#method #getMethodItemContents #fileInMethodItem:);
		at: 'CLASSMETHOD' put: #(#classMethod #getClassMethodItemContents #fileInClassMethodItem:);
		at: 'INITIALIZER' put: #(#initializer #getInitializerItemContents #fileInInitializerItem:);
		at: 'INITIALIZERFOR:' put: #(#initializerFor #getInitializerForItemContents #fileInInitializerForItem:);
		at: 'VARIABLE:' put: #(#variable #getVariableItemContents #fileInVariableItem:);
		at: 'CONSTANT:' put: #(#constant #getConstantItemContents #fileInConstantItem:).