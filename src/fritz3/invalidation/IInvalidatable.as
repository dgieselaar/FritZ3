package fritz3.invalidation {
	import org.osflash.signals.ISignal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IInvalidatable {
		
		function executeInvalidatedMethods ( ):void
		
		function get priority ( ):int
		function set priority ( value:int ):void
		
	}

}