package fritz3.style.invalidation {
	import fritz3.style.StyleRule;
	import org.osflash.signals.IDispatcher;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StyleRuleInvalidationSignal extends InvalidatableStyleSheetCollectorSignal {
		
		public var styleRule:StyleRule;
		
		public function StyleRuleInvalidationSignal ( ) {
			
		}
		
		override public function dispatch ( ...rest ):void  {
			_dispatching = true;
			var node:StyleSheetCollectorNode = _firstNode, nextNode:StyleSheetCollectorNode;
			var rule:StyleRule = this.styleRule;
			while (node) {
				if (node.remove) {
					nextNode = node.nextNode;
					this.remove(node.styleSheetCollector);
					node = nextNode;
				} else {
					node.styleSheetCollector.invalidateRule(rule);
					node = node.nextNode;
				}
			}
			_dispatching = false;
		}
		
	}

}