package fritz3.utils.color {
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
		
	}

}