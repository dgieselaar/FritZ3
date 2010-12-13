package fritz3.utils.assets.image {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import fritz3.utils.assets.AssetLoader;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ImageAssetManager {
		
		protected static var _imagesByURL:Object;
		protected static var _loadersByURL:Object;
		
		{ 
			_imagesByURL = { };
			_loadersByURL = { };
		}
		
		public function ImageAssetManager ( ) {
			
		}
		
		public static function hasImage ( url:String ):Boolean {
			return _imagesByURL[url] != undefined;
		}
		
		public static function getImage ( url:String ):DisplayObject {
			return _imagesByURL[url];
		}
		
		public static function loadImage ( url:String ):ImageAssetLoader {
			var loader:ImageAssetLoader = _loadersByURL[loader];
			if (!loader) {
				_loadersByURL[url] = loader = new ImageAssetLoader();
				loader.onComplete.add(onImageComplete);
				loader.onComplete.add(onImageError);
				loader.load(new URLRequest(url));
			}
			return loader;
		}
		
		protected static function onImageComplete ( loader:AssetLoader ):void {
			_imagesByURL[loader.request.url] = loader.data;
			removeLoader(loader);
		}
		
		protected static function onImageError ( loader:AssetLoader ):void {
			_imagesByURL[loader.request.url] = null;
			removeLoader(loader);
		}
		
		protected static function removeLoader ( loader:AssetLoader ):void {
			loader.onComplete.remove(onImageComplete);
			loader.onComplete.remove(onImageError);
		}
		
	}

}