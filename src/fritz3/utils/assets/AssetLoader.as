package fritz3.utils.assets {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class AssetLoader {
		
		protected var _onError:IDispatcher = new Signal();
		protected var _onComplete:IDispatcher = new Signal();
		protected var _onProgress:IDispatcher = new Signal();
		
		protected var _request:URLRequest;
		protected var _data:Object;
		
		public function AssetLoader ( ) {
			
		}
		
		public function load ( request:URLRequest ):void {
			_request = request;
		}
		
		
		protected function dispatchComplete ( ):void {
			_onComplete.dispatch(this);
		}
		
		protected function dispatchError ( ):void {
			_onError.dispatch(this);
		}
		
		protected function dispatchProgress ( ):void {
			_onProgress.dispatch(this);
		}
		
		public function get onError ( ):ISignal { return ISignal(_onError); }
		public function get onComplete ( ):ISignal { return ISignal(_onComplete); }
		public function get onProgress ( ):ISignal { return ISignal(_onProgress); }
		
		public function get request ( ):URLRequest { return _request; }
		public function get data ( ):Object { return _data; }
		
	}

}