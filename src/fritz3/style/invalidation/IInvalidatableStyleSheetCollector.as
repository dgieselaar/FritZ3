package fritz3.style.invalidation {
	import fritz3.style.StyleRule;
	import fritz3.style.IStyleSheetCollector;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IInvalidatableStyleSheetCollector extends IStyleSheetCollector {
		
		function invalidateRule ( styleRule:StyleRule ):void
		function invalidateCollector ( ):void
		function invalidateState ( ):void
	}

}