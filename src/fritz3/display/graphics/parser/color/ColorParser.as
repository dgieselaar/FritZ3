package fritz3.display.graphics.parser.color {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.utils.color.ColorUtil;
	import fritz3.utils.math.MathUtil;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ColorParser implements IPropertyParser {
		
		protected static const COLOR_KEYWORDS:Object = {
			"black": 0x000000, "silver": 0xC0C0C0, "gray": 0x808080,
			"white": 0xFFFFFF, "maroon": 0x800000, "red": 0xFF0000,
			"purple": 0x800080, "fuchsia": 0xFF00FF, "green": 0x008000,
			"lime": 0x00FF00, "olive": 0x808000, "yellow": 0xFFFF00,
			"navy": 0x000080, "blue": 0x0000FF, "teal": 0x008080,
			"aqua": 0x00FFFF
		}
		
		protected static const KEYWORD_REGEXP:RegExp = /^(aqua|teal|blue|navy|yellow|olive|lime|green|fuchsia|purple|red|maroon|white|gray|silver|black)$/i;
		protected static const HEX_REGEXP:RegExp = /^(?:#(?:(?:([a-f0-9]{6})([a-f0-9]{2})?)|([a-f0-9]{3})))$/i;
		protected static const RGB_REGEXP:RegExp = /^rgb\(\s*(-?\d{1,3})(%)?\s*,\s*(-?\d{1,3})(%)?\s*,\s*(-?\d{1,3})(%)?\s*\)$/i;	
		protected static const RGBA_REGEXP:RegExp = /^rgba\(\s*(-?\d{1,3})(%)?\s*,\s*(-?\d{1,3})(%)?\s*,\s*(-?\d{1,3})(%)?\s*,\s*((-?\d+?(?:\.\d+)?)|(\d{1,3})(%))\)$/i;
		protected static const HSL_REGEXP:RegExp = /^hsl\s*\((-?\d+)\s*,\s*(-?\d{1,3})(?:%)\s*,\s*(-?\d{1,3})(?:%)\s*\)$/i;
		protected static const HSLA_REGEXP:RegExp = /^hsla\s*\((-?\d+)\s*,\s*(-?\d{1,3})(?:%)\s*,\s*(-?\d{1,3})(?:%)\s*,\s*((-?\d+?(?:\.\d+)?)|(\d{1,3})(%))\)$/i;
		
		public static var parser:ColorParser = new ColorParser();
		protected static var regExp:RegExp;
		
		protected var _cachedData:Object = { };
		
		public function ColorParser ( ) {
			
		}
		
		public function parseValue ( value:String ):Object {
			return _cachedData[value] ||= this.getColorData(value);
		}
		
		protected function getColorData ( value:String ):ColorData {
			var colorData:ColorData;
			var match:Array;
			var val:String, r:int, g:int, b:int;
			if ((match = value.match(KEYWORD_REGEXP))) {
				colorData = new ColorData();
				colorData.alpha = 1;
				colorData.color = COLOR_KEYWORDS[match[1].toLowerCase()];
			} else if ((match = value.match(HEX_REGEXP))) {
				colorData = new ColorData();
				if (match[1] != undefined) {
					colorData.color = uint("0x" + match[1]);
					if (match[2] != undefined) {
						colorData.alpha = Math.max(0, Math.min(1, uint("0x" + match[2]) / 255));
					} else {
						colorData.alpha = 1;
					}
				} else if (match[3] != undefined) {
					val = match[3];
					r = uint("0x" + val.charAt(0) + val.charAt(0));
					g = uint("0x" + val.charAt(1) + val.charAt(1));
					b = uint("0x" + val.charAt(2) + val.charAt(2));
					colorData.color = ColorUtil.getUintFromRGB(r, g, b);
					colorData.alpha = 1;
				}
			} else if ((match = value.match(RGB_REGEXP) || value.match(RGBA_REGEXP))) {
				colorData = new ColorData();
				r = match[1];
				if (match[2] != undefined) {
					r = (r / 100) * 255;
				}
				g = match[3];
				if (match[4] != undefined) {
					g = (g / 100) * 255;
				}
				b = match[5];
				if (match[6] != undefined) {
					b = (b / 100) * 255;
				}
				
				r = Math.max(0, Math.min(255, r));
				g = Math.max(0, Math.min(255, g));
				b = Math.max(0, Math.min(255, b));
				
				colorData.color = ColorUtil.getUintFromRGB(r, g, b);
				if (match[7] != undefined) {
					if (match[8] != undefined) {
						colorData.alpha = Math.max(0, Math.min(1, Number(match[8])));
					} else if (match[9] != undefined) {
						colorData.alpha = Math.max(0, Math.min(1, Number(match[9]) / 100));
					}
				} else {
					colorData.alpha = 1;
				}
			} else if ((match = value.match(HSL_REGEXP) || value.match(HSLA_REGEXP))) {
				colorData = new ColorData();
				var h:Number, s:Number, l:Number;
				h = MathUtil.wrapAngle(match[1]);
				s = (match[2] / 100);
				l = (match[3] / 100);
				h = Math.max(0, Math.min(360, h));
				s = Math.max(0, Math.min(1, s));
				l = Math.max(0, Math.min(1, l));
				colorData.color = ColorUtil.getUintFromHSL(h, s, l);
				if (match[4] != undefined) {
					if (match[5] != undefined) {
						colorData.alpha = Math.max(0, Math.min(1, Number(match[5])));
					} else if (match[6] != undefined) {
						colorData.alpha = Math.max(0, Math.min(1, Number(match[6]) / 100));
					}
				} else {
					colorData.alpha = 1;
				}
			}
			return colorData;
		}
		
	}

}