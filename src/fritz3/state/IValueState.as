package fritz3.state {
	import org.osflash.signals.ISignal;
	
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public interface IValueState extends IState {
		
		function get value ( ):*
		function set value ( value:* ):void
		
		function get onChange ( ):ISignal
		
	}
	
}