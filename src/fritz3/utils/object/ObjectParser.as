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
			var child:XML, value:Object;
			for (i = 0, l = attributes.length(); i < l; ++i) {
				child = attributes[i];
				value = getSimpleValue(child.toString());
				parent[child.name().toString()] = value;
			}
			
			if (!(parent is ItemCollection || parent is Array)) {
				return parent;
			}
			
			return parseXMLChildren(parent, xml.children());
			
		}
		
		private static function getSimpleValue ( val:String ):Object {
			var value:Object;
			switch(val) {
				default:
				value = val;
				break;
				
				case "NaN": case "Number.NaN":
				value = NaN;
				break;
				
				case "true":
				value = true;
				break;
				
				case "false":
				value = false;
				break;
				
				case "Number.MIN_VALUE":
				value = Number.MIN_VALUE;
				break;
				
				case "Number.MAX_VALUE":
				value = Number.MAX_VALUE;
				break;
				
				case "Number.NEGATIVE_INFINITY":
				value = Number.NEGATIVE_INFINITY;
				break;
				
				case "Number.POSITIVE_INFINITY":
				value = Number.POSITIVE_INFINITY;
				break;
			}
			return value;
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