package fritz3.display.button {
	import org.osflash.signals.ISignal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IButton {
		
		function get highlighted ( ):Boolean
		function set highlighted ( value:Boolean ):void 
		
		function get selected ( ):Boolean
		function set selected ( value:Boolean ):void 
		
		function get pressed ( ):Boolean
		function set pressed ( value:Boolean ):void 
		
		function get disabled ( ):Boolean
		function set disabled ( value:Boolean ):void
		
	}

}