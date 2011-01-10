package fritz3.style {
	import fritz3.base.transition.TransitionData;
	import fritz3.style.invalidation.StyleRuleInvalidationSignal;
	import fritz3.style.selector.Selector;
	import fritz3.style.selector.SelectorList;
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
			if (!this.firstNode) {
				this.firstNode = propertyData;
			}
			if (this.lastNode) {
				this.lastNode.nextNode = propertyData;
				propertyData.prevNode = this.lastNode;
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
		
	}

}