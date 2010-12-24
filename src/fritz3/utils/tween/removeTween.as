package fritz3.utils.tween {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	
	
	public function removeTween ( target:Object, propertyName:String ):void { 
		Tweener.engine.removeTween(target, propertyName);
	}

}