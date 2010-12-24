package fritz3.utils.tween {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	
	public function hasTween ( target:Object, propertyName:String ):Boolean {
		return Tweener.engine.hasTween(target, propertyName);
	}

}