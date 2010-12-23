package fritz3.utils.math {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class MathUtil {
		
		public static function getLineLength ( width:Number, height:Number, angleRadians:Number ):Number {
			width *= 2, height *= 2;
			var xDist:Number = Math.min(width/2, (height / 2) / Math.tan(angleRadians));
			var yDist:Number = Math.min(height/2, (width / 2) * Math.tan(angleRadians));
			return Point.distance(new Point(0, 0), new Point(xDist, yDist));
		}
		
		public static function getAngle ( p1:Point, p2:Point ):Number {
			return Math.atan2(p2.y-p1.y, p2.x-p1.x);
		}
		
		public static function getIntersection ( p1a:Point, p1b:Point, p2a:Point, p2b:Point ):Point {
			var k1:Number = (p1b.y - p1a.y) / (p1b.x - p1a.x);
			var k2:Number = (p2b.y - p2a.y) / (p2b.x - p2a.x);
			var m1:Number = (p1a.y - k1 * p1a.x);
			var m2:Number = (p2a.y - k2 * p2a.x);
			var x:Number = (m1 - m2) / (k2 - k1);
			var y:Number = k1 * x + m1;
			return new Point(x, y);
		}
		
		public static function hypot ( x:Number, y:Number ):Number {
			return Math.sqrt(x * x + y * y);
		}
		
	}

}