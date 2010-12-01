package fritz3.style {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface StyleSheet {
		
		function getStyle ( ):void
		
		function invalidateCollector ( ):void
		function invalidateState ( ):void
		
		function set stylable ( value:Stylable ):void 
	}

}