package fritz3.utils.assets {
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class AssetLoader {
		
		protected var _onError:IDispatcher;
		protected var _onComplete:IDispatcher;
		protected var _onProgress:IDispatcher;
		
		protected var _loader:Loader;
		protected var _request:URLRequest;
		protected var _asset:Object;
		
		public function AssetLoader ( ) {
			
		}
		
		public function load ( request:URLRequest ):void {
			_request = request;
			_loader = new Loader();
			_loader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
			
			// TODO: add other listeners
		}
		
		protected function onIOError ( e:IOErrorEvent ):void {
			
		}
		
		protected function onSecurityError ( e:SecurityErrorEvent ):void {
			
		}
		
		public function get onError ( ):ISignal { return ISignal(_onError); }
		public function get onComplete ( ):ISignal { return ISignal(_onComplete); }
		public function get onProgress ( ):ISignal { return ISignal(_onProgress); }
		
		public function get request ( ):URLRequest { return _request; }
		public function get asset ( ):Object { return _asset; }
		
	}

}