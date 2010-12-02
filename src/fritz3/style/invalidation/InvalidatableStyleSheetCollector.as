package fritz3.style.invalidation {
	import fritz3.style.StyleRule;
	import fritz3.style.StyleSheetCollector;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface InvalidatableStyleSheetCollector extends StyleSheetCollector {
		
		function invalidateRule ( styleRule:StyleRule ):void
		
	}

}