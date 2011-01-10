package fritz3.display.core {
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface Cyclable {
		
		function get cyclePhase ( ):String
		function set cyclePhase ( value:String ):void 
		
		function get cycle ( ):int
		function set cycle ( value:int ):void
	}
	
}