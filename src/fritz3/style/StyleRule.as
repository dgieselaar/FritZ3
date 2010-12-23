package fritz3.style {
	import fritz3.style.invalidation.StyleRuleInvalidationSignal;
	import fritz3.style.selector.Selector;
	import fritz3.style.selector.SelectorList;
	import fritz3.style.transition.TransitionData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StyleRule {
		
		public var styleSheetID:String;
		
		public var prevNode:StyleRule;
		public var nextNode:StyleRule;
		
		public var firstNode:PropertyData;
		public var lastNode:PropertyData;
		
		public var selectorList:SelectorList;
		public var onChange:StyleRuleInvalidationSignal;
		
		protected var _properties:Object = { };
		
		public function StyleRule ( ) {
			this.onChange = new StyleRuleInvalidationSignal();
			this.onChange.styleRule = this;
		}
		
		public function invalidate ( ):void {
			this.onChange.dispatch();
		}
		
		public function append ( propertyData:PropertyData ):void {
			var duplicate:PropertyData = this.getPropertyData(propertyData.propertyName, propertyData.target);
			var transitionData:TransitionData;
			if (duplicate) {
				transitionData = duplicate.transitionData;
				this.remove(duplicate);
			}
			
			if (!this.firstNode) {
				this.firstNode = propertyData;
			}
			if (this.lastNode) {
				this.lastNode.nextNode = propertyData;
				propertyData.prevNode = this.lastNode;
			}
			if (transitionData) {
				propertyData.transitionData = transitionData;
			}
			this.lastNode = propertyData;
		}
		
		public function remove ( propertyData:PropertyData ):void {
			var prevNode:PropertyData = propertyData.prevNode, nextNode:PropertyData = propertyData.nextNode;
			if (prevNode) {
				prevNode.nextNode = nextNode;
			}
			if (nextNode) {
				nextNode.prevNode = prevNode;
			}
			if (propertyData == this.firstNode) {
				this.firstNode = nextNode;
			}
			if (propertyData == this.lastNode) {
				this.lastNode = prevNode;
			}
			propertyData.prevNode = propertyData.nextNode = null;
		}
		
		protected function getPropertyData ( propertyName:String, target:String = null ):PropertyData {
			return _properties[target] ? _properties[target][propertyName] : null;
		}
		
	}

}