package fritz3.display.layout  {
	import org.osflash.signals.ISignal;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.display.layout
	 * 
	 * [Description]
	*/
	
	public interface InvalidatablePositionable extends Positionable {
		
		function invalidateDisplay ( ):void
		
		function get onDisplayInvalidation ( ):ISignal
		
	}

}