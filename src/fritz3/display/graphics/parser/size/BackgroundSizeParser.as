package fritz3.display.graphics.parser.size  {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.BackgroundImageScaleMode;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.display.graphics.parser.size
	 * 
	 * [Description]
	*/
	
	public class BackgroundSizeParser implements IPropertyParser {
		
		protected static var _parser:BackgroundSizeParser;
		protected static var _cachedData:Object;
		
		{
			_parser = new BackgroundSizeParser();
			_cachedData = { };
		}
		
		public function BackgroundSizeParser (  )  {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getSizeData(value);
		}
		
		protected function getSizeData ( value:String ):BackgroundSizeData {
			var data:BackgroundSizeData = new BackgroundSizeData();
			var match:Array = value.match(/(((\d+)(px|%)?|auto)\s*((\d+)(px|%)?|auto)?)|^(cover)$|^(contain)$/);
			var width:Number = 0, height:Number = 0;
			var widthValueType:String = DisplayValueType.AUTO, heightValueType:String = DisplayValueType.AUTO;
			var scaleMode:String = BackgroundImageScaleMode.NONE;
			if (match) {
				if (match[8] || match[9]) {
					scaleMode = match[8] || match[9];
				} else {
					if (match[2] != "auto") {
						width = match[3];
						if (match[4]) {
							widthValueType = match[4];
						}
					}
					if (match[5]) {
						if(match[5] != "auto") {
							height = match[6];
							if (match[7]) { 
								heightValueType = match[7];
							} else {
								heightValueType = DisplayValueType.PIXEL;
							}
						}
					} else {
						height = width;
						heightValueType = widthValueType;
					}
				}
			}
			
			data.backgroundImageScaleMode = scaleMode;
			if (scaleMode == BackgroundImageScaleMode.NONE) {
				data.backgroundImageWidth = new DisplayValue(width, widthValueType);
				data.backgroundImageHeight = new DisplayValue(height, heightValueType);
			}
			return data;
		}
		
		public static function get parser ( ):BackgroundSizeParser { return _parser; }
		
	}

}