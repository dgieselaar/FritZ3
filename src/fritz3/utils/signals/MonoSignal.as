package fritz3.utils.signals {
	import org.osflash.signals.IDispatcher;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class MonoSignal implements IDispatcher {
		
		public var listener:Function;
		
		public function MonoSignal ( ) {
			
		}
		
		public function dispatch ( ...rest ):void {
			if (this.listener) {
				this.dispatch(rest);
			}
		}
		
	}

}