package fritz3.style.invalidation {
	import fritz3.style.StyleSheet;
	import fritz3.style.StyleSheetNode;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface InvalidatableStyleSheet extends StyleSheet {
		
		function invalidateNode ( styleSheetNode:StyleSheetNode ):void
		
	}

}