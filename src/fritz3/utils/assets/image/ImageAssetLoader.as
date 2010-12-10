package fritz3.utils.assets.image {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import fritz3.utils.assets.AssetLoader;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ImageAssetLoader extends AssetLoader {
		
		protected var _loader:Loader;
		
		public function ImageAssetLoader() {
			
		}
		
		override public function load(request:URLRequest):void {
			super.load(request);
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onEventComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onProgressEvent);
			_loader.load(request);
		}
		
		protected function removeLoader ( ):void {
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
			_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onEventComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onProgressEvent);
			_loader = null;
		}
		
		protected function onIOError ( e:IOErrorEvent ):void {
			this.dispatchError();
		}
		
		protected function onSecurityError ( e:SecurityErrorEvent ):void {
			this.dispatchError();
		}
		
		protected function onHTTPStatus ( e:HTTPStatusEvent ):void {
			if (e.status >= 400) {
				this.dispatchError();
			}
		}
		
		protected function onEventComplete ( e:Event ):void {
			this.dispatchComplete();
		}
		
		protected function onProgressEvent ( e:Event ):void {
			this.dispatchProgress();
		}
		
		override protected function dispatchComplete ( ):void {
			_data = _loader.content;
			this.removeLoader();
			super.dispatchComplete();
		}
		
		override protected function dispatchError ( ):void {
			this.removeLoader();
			super.dispatchError();
		}
		
		override protected function dispatchProgress ( ):void {
			super.dispatchProgress();
		}
		
	}

}