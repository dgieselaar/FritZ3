package fritz3.utils.object {
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	internal class ClassManager {
		
		protected static var _classByAlias:Object = { };;
		
		public function ClassManager ( ) {
		}
		
		public static function addClassAlias ( alias:String, classObject:Class ):void {
			_classByAlias[alias] = classObject;
		}
		
		public static function removeClassAlias ( alias:String ):void {
			delete _classByAlias[alias];
		}
		
		public static function getClass ( alias:String ):Class {
			var classObject:Class = _classByAlias[alias];
			if (!classObject) {
				classObject = Class(getDefinitionByName(alias));
				if (!classObject) {
					classObject = getClassByAlias(alias);
				}
				_classByAlias[alias] = classObject;
			}
			return classObject;
		}
		
	}

}