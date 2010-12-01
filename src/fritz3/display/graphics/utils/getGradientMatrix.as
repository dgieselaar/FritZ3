package fritz3.display.graphics.utils {
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	
	
	public function getGradientMatrix ( width:Number, height:Number, angle:Number = 90, tx:Number = 0, ty:Number = 0):Matrix {
		var m:Matrix = new Matrix()
		m.createGradientBox(width,height,angle * Math.PI/180);
		return m;
	}

}