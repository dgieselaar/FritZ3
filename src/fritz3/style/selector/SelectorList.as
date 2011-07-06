package fritz3.style.selector {
	import fritz3.base.collection.IItemCollection;
	import fritz3.display.core.IAddable;
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
			
			for (i = 0; i < l; i += 2) {
				selector = match[i];
				relationship = match[i + 1];
				switch(relationship) {
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
			this.lastNode = node;
		}
		
		public function match ( object:Object ):Boolean {
			var node:Selector = this.lastNode;
			var objectToMatch:Object = object;
			
			if (node.prevNode) {
				if (!(objectToMatch is IAddable)) {
					return false;
				}
			} else {
				return node.match(objectToMatch);
			}
			
			var addable:IAddable = IAddable(objectToMatch), currentAddable:IAddable = addable;
			var collection:IItemCollection, objectCache:ObjectCache = ObjectCache.getCache(objectToMatch);
			
			var relationship:String, match:Boolean;
			while (node) {
				switch(node.relationship) {
					default:
					if (!node.match(objectToMatch)) {
						return false;
					}
					break;
					
					case SelectorRelationship.CHILD:
					objectToMatch = currentAddable = currentAddable.parentComponent;
					if (!objectToMatch || !node.match(objectToMatch)) {
						return false;
					}
					break;
					
					case SelectorRelationship.DESCENDANT:
					objectToMatch = currentAddable = currentAddable.parentComponent;
					if (!objectToMatch) {
						return false;
					}
					if (!node.match(objectToMatch)) {
						continue;
					}
					break;
					
					// TODO: implement sibling selectors
					
					case SelectorRelationship.PRECEDING:
					return false;
					break;
					
					case SelectorRelationship.PRECEDING_IMMEDIATELY:
					return false;
					break;
					
					case SelectorRelationship.FOLLOWING:
					return false;
					break;
					
					case SelectorRelationship.FOLLOWING_IMMEDIATELY:
					return false;
					break;
				}
				node = node.prevNode;
			}
			
			return true;
		}
		
		protected function matchSelector ( selector:Selector, object:Object ):void {
			
		}
		
	}

}