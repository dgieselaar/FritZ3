package fritz3.utils.color {
	import fritz3.utils.math.MathUtil;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ColorUtil {
		
		public function ColorUtil ( ) {
			
		}
		
		public static function getStringFromUint ( value:uint ):String {
			var r:String = uint((value >> 16) & 0xFF).toString(16);
            var g:String = uint((value >> 8) & 0xFF).toString(16);
            var b:String = uint(value & 0xFF).toString(16);
			return (r.length < 2 ? "0" + r : r) + (g.length < 2 ? "0" + g : g) + (b.length < 2 ? "0" + b : b);
		}
		
		public static function getUintFromRGB ( r:uint, g:uint, b:uint ):uint {
			return r << 16 | g << 8 | b;
		}
		
		/**
		 * (Taken from: Michael Jackson, http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript)
		 * (Adapted to AS3 & return type uint by Dario Gieselaar)
		 * 
		 * Converts an HSL color value to uint. Conversion formula
		 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
		 * Assumes h, s, and l are contained in the set [0, 1] and
		 * returns color as uint.
		 *
		 * @param   Number  h       The hue
		 * @param   Number  s       The saturation
		 * @param   Number  l       The lightness
		 * @return  uint           	The uint representation
		 */
		
		public static function getUintFromHSL ( h:Number, s:Number, l:Number ):uint {
			var r:Number, g:Number, b:Number;

			if (s == 0) {
				r = g = b = l; // achromatic
			} else {
				function hue2rgb ( p:Number, q:Number, t:Number ):Number {
					if(t < 0) t += 1;
					if (t > 1) t -= 1;
					if(t < 1/6) return p + (q - p) * 6 * t;
					if(t < 1/2) return q;
					if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
					return p;
				}

				var q:Number = l < 0.5 ? l * (1 + s) : l + s - l * s;
				var p:Number = 2 * l - q;
				r = hue2rgb(p, q, h / 360 + 1 / 3);
				g = hue2rgb(p, q, h / 360);
				b = hue2rgb(p, q, h / 360 - 1 / 3);
			}
			// correct rounding errors
			r = MathUtil.correctRoundingErrors(r, 8);
			g = MathUtil.correctRoundingErrors(g, 8);
			b = MathUtil.correctRoundingErrors(b, 8);
			
			r *= 255, g *= 255, b *= 255;
			return getUintFromRGB(r,g,b);
		}
	}

}