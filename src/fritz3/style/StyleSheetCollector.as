package fritz3.style {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface StyleSheetCollector {
		
		function getStyle ( ):void
		
		function invalidateCollector ( ):void
		function invalidateState ( ):void
		
		function set stylable ( value:Stylable ):void 
	}

}