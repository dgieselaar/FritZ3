package fritz3.style.selector {
	import fritz3.base.collection.ItemCollection;
	import fritz3.display.core.Addable;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class SelectorList {
		
		public var where:String;
		
		public var firstNode:Selector;
		public var lastNode:Selector;
		
		public var numSelectors:int;
		
		public function SelectorList ( where:String ) {
			this.where = where;
			var match:Array = where.match(/((.*?)\s+)|((.*?)(\s+[>+~]))|([^\s]+$)/g);
			if (!match) {
				throw new Error("Invalid Selector supplied in style rule: " + where);
			}
			
			var node:Selector, prevNode:Selector, relationship:String = null, relationshipIndicator:String;
			var selector:String, afterIndex:Array;
			for (var i:int, l:int = match.length; i < l; i++) {
				selector = match[i];
				match[i] = selector = selector.replace(/$\s+/, "").replace(/\s+$/, "");
				if (i & 1) {
					if (!selector.match(/^[>+~]$/)) {
						afterIndex = match.splice(i);
						match[i] = " ";
						match = match.concat(afterIndex);
						l++;
					}
				}
			}
			
			for (i = 0; i < l; ++i) {
				selector = match[i];
				if(i & 1) {
					switch(selector) {
						case ">":
						relationship = SelectorRelationship.CHILD;
						break;
						
						case " ":
						relationship = SelectorRelationship.DESCENDANT;
						break;
						
						case "+":
						relationship = SelectorRelationship.FOLLOWING;
						break;
						
						case "~":
						relationship = SelectorRelationship.FOLLOWING_IMMEDIATELY;
						break;
						
						default:
						relationship = null;
						break;
					}
				} else {
					node = new Selector(selector);
					if (prevNode) {
						node.prevNode = prevNode;
						prevNode.nextNode = node;
					} else {
						this.firstNode = node;
					}
					node.relationship = relationship;
					this.numSelectors++;
					prevNode = node;
				}
			}
			this.lastNode = node;
		}
		
		public function match ( object:Object ):Boolean {
			var node:Selector = this.lastNode;
			var objectToMatch:Object = object;
			
			if (node.prevNode) {
				if (!(objectToMatch is Addable)) {
					return false;
				}
			} else {
				return node.match(objectToMatch);
			}
			
			var addable:Addable = Addable(objectToMatch), currentAddable:Addable = addable;
			var collection:ItemCollection, objectCache:ObjectCache = ObjectCache.getCache(objectToMatch);
			
			var relationship:String, match:Boolean;
			while (node) {
				if (!objectToMatch) {
					return false;
				}
				match = node.match(objectToMatch);
				switch(node.relationship) {
					default:
					return match;
					break;
					
					case SelectorRelationship.CHILD:
					if (!match) {
						return false;
					} else {
						node = node.prevNode;
						objectToMatch = currentAddable = currentAddable.parentComponent;
					}
					break;
					
					case SelectorRelationship.DESCENDANT:
					if (!match) {
						objectToMatch = currentAddable = currentAddable.parentComponent;
					} else {
						node = node.prevNode;
					}
					break;
					
					case SelectorRelationship.PRECEDING:
					if (!objectCache.cachedAllSiblings) {
						objectCache.cacheAllSiblings();
					}
					break;
					
					case SelectorRelationship.PRECEDING_IMMEDIATELY:
					if (!objectCache.cachedDirectSiblings) {
						objectCache.cacheDirectSiblings();
					}
					break;
					
					case SelectorRelationship.FOLLOWING:
					if (!objectCache.cachedAllSiblings) {
						objectCache.cacheAllSiblings();
					}
					break;
					
					case SelectorRelationship.FOLLOWING_IMMEDIATELY:
					if (!objectCache.cachedDirectSiblings) {
						objectCache.cacheDirectSiblings();
					}
					break;
				}
			}
			
			return true;
		}
		
		protected function matchSelector ( selector:Selector, object:Object ):void {
			
		}
		
	}

}