package fritz3.style {
	import fritz3.style.transition.TransitionData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class PropertyData {
		
		public var prevNode:PropertyData;
		public var nextNode:PropertyData;
		
		public var propertyName:String;
		public var value:*
		public var target:String;
		
		public var transitionData:TransitionData;
		
		public function PropertyData ( ) {
			
		}
		
	}

}