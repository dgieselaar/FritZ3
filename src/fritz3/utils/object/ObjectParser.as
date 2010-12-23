package fritz3.utils.object {
	import fritz3.base.collection.ItemCollection;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ObjectParser{
		
		public function ObjectParser ( ) {
			
		}
		
		public static function parseXML ( xml:XML ):* {
			var container:Object = new (getClass(xml.name()))();
			var i:int, l:int;
			var attributes:XMLList = xml.attributes();
			var child:XML;
			for (i = 0, l = attributes.length(); i < l; ++i) {
				child = attributes[i];
				container[child.name().toString()] = child;
			}
			
			if (!(container is ItemCollection || container is Array)) {
				return container;
			}
			
			var list:XMLList = xml.children();
			var children:Array = [], childObject:Object;
			for (i = 0, l = list.length(); i < l; ++i) {
				child = list[i];
				childObject = parseXML(child);
				children.push(childObject);
			}
			
			if (container is ItemCollection) {
				var itemCollection:ItemCollection = ItemCollection(container);
				for (i = 0, l = children.length; i < l; ++i) {
					itemCollection.add(children[i]);
				}
			} else if (container is Array) {
				var array:Array = container as Array;
				for (i = 0, l = children.length; i < l; ++i) {
					array.push(children[i]);
				}
			}
			return container;
		}
		
	}

}