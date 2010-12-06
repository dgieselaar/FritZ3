package fritz3.utils.signals {
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class MonoSignal implements SignalDispatcher {
		
		public var listener:Function;
		
		public function MonoSignal ( ) {
			
		}
		
		public function add ( listener:Function ):Function {
			return (this.listener = listener);
		}
		
		public function remove ( listener:Function ):Function {
			this.listener = null;
			return listener;
		}
		
		public function dispatch ( ...rest ):void {
			if (Boolean(this.listener)) {
				this.dispatch(rest);
			}
		}
		
		public function get valueClasses ( ):Array { return null; }
		public function set valueClasses ( value:Array ):void { }
		
		public function get numListeners ( ):uint { return 1; }
		
		public function addOnce ( listener:Function ):Function {
			return null;
		}
		
	}

}