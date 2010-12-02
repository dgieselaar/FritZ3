package fritz3.style.invalidation  {
	import fritz3.style.Stylable;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.style.invalidation
	 * 
	 * [Description]
	*/
	
	public class StyleSheetCollectorNode {
		
		public var styleSheetCollector:InvalidatableStyleSheetCollector;
		public var prevNode:StyleSheetCollectorNode;
		public var nextNode:StyleSheetCollectorNode;
		public var remove:Boolean;
		
		public function StyleSheetCollectorNode (  )  {
			
		}
		
	}

}