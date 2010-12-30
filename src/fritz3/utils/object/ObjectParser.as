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
			var parent:Object = new (getClass(xml.name()))();
			var i:int, l:int;
			var attributes:XMLList = xml.attributes();
			var child:XML;
			for (i = 0, l = attributes.length(); i < l; ++i) {
				child = attributes[i];
				parent[child.name().toString()] = child;
			}
			
			if (!(parent is ItemCollection || parent is Array)) {
				return parent;
			}
			
			return parseXMLChildren(parent, xml.children());
			
		}
		
		public static function parseXMLChildren ( parent:Object, list:XMLList ):* {
			var i:int, l:int;
			var child:XML, children:Array = [], childObject:Object;
			for (i = 0, l = list.length(); i < l; ++i) {
				child = list[i];
				childObject = parseXML(child);
				children.push(childObject);
			}
			
			if (parent is ItemCollection) {
				var itemCollection:ItemCollection = ItemCollection(parent);
				for (i = 0, l = children.length; i < l; ++i) {
					itemCollection.add(children[i]);
				}
			} else if (parent is Array) {
				var array:Array = parent as Array;
				for (i = 0, l = children.length; i < l; ++i) {
					array.push(children[i]);
				}
			}
			return parent;
		}
		
	}

}