package demo.all {
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filters.GlowFilter;
	import fritz3.base.collection.ArrayItemCollection;
	import fritz3.display.core.DisplayComponentContainer;
	import fritz3.display.core.GraphicsComponent;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.document.ApplicationDocument;
	import fritz3.style.StyleManager;
	import fritz3.style.StyleRule;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DemoDocument extends ApplicationDocument {
	 
		[Embed(source = '../../../assets/demo/stylesheet/demo-all.xml', mimeType="application/octet-stream")]
		private var StyleSheetXML:Class;
		
		protected var _panelHolder:DisplayComponentContainer;
		protected var _demoPanel:DemoPanel;
		
		protected var _demoHolder:DisplayComponentContainer;
		
		protected var _selectedComponent:GraphicsComponent;
		
		public function DemoDocument ( ) {
			super();
		}
		
		override public function onAdd():void {
			super.onAdd();
			
			/*this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
			
			function onUncaughtError ( event:UncaughtErrorEvent ):void {
				event.preventDefault();
			}*/
			
			_panelHolder = new DisplayComponentContainer( { className: "panel_holder" } );
			this.add(_panelHolder);
			
			_demoPanel = new DemoPanel();
			_panelHolder.add(_demoPanel);
			
			_demoHolder = new DisplayComponentContainer( { className: "demo_holder", boxFlex: 1 } );
			this.add(_demoHolder);
			
			_demoHolder.addEventListener(MouseEvent.CLICK, this.onDemoHolderClick);
			
			_demoPanel.addComponentButton.addEventListener(MouseEvent.CLICK, this.onAddButtonClick);
			_demoPanel.removeComponentButton.addEventListener(MouseEvent.CLICK, this.onRemoveButtonClick);
			_demoPanel.resetButton.addEventListener(MouseEvent.CLICK, this.onResetButtonClick);
			
			_demoPanel.styleSheetXMLInput.textField.addEventListener(KeyboardEvent.KEY_UP, this.onStyleChange);
			_demoPanel.idInputField.textField.addEventListener(KeyboardEvent.KEY_UP, this.onIDChange);
			_demoPanel.classNameInputfield.textField.addEventListener(KeyboardEvent.KEY_UP, this.onClassNameChange);
			_demoPanel.nameInputField.textField.addEventListener(KeyboardEvent.KEY_UP, this.onNameChange);
			
			this.setDefaults();
		}
		
		protected function setDefaults ( ):void {
			var child:DisplayObject;
			
			this.selectComponent(null);
			
			while (_demoHolder.numItems) {
				_demoHolder.removeItemAt(0);
			}
			
			this.addComponent();
			this.addComponent();
			this.addComponent();
			
			var defaultStyle:String = ".demo_holder { \nlayout.align: stretch; \nbackground.background-color: 0xBBBBBB; \nauto-width: false; \nauto-height: false; \n}";
			defaultStyle += "\n\n\GraphicsComponent {\nbox-flex: 1;\nbackground.background-color: 0x666666;\nmargin: 10;\n}";
			defaultStyle += "\n\n\GraphicsComponent:last-child {\nbox-flex: 2\n}";
			//defaultStyle += "\n\n<rule where='GraphicsComponent'>\n\t<property name='width'>100</property>\n\t<property name='marginRight'>10</property>\n\t<property name='background.backgroundColor'>0x00FFFF</property>\n</rule>";
			//defaultStyle += "\n\n<rule where='GraphicsComponent:last-child'>\n\t<property name='marginRight'>0</property>\n</rule>";
			_demoPanel.styleSheetXMLInput.text = defaultStyle;
			
			this.parseStyleSheet();
		}
		
		protected function addComponent ( ):GraphicsComponent {
			var component:GraphicsComponent = new GraphicsComponent();
			component.addEventListener(MouseEvent.CLICK, this.onComponentClick);
			_demoHolder.add(component);
			return component;
		}
		
		protected function removeComponent ( component:GraphicsComponent ):void {
			if (_selectedComponent == component) {
				this.selectComponent(null);
			}
			component.removeEventListener(MouseEvent.CLICK, this.onComponentClick);
			_demoHolder.remove(component);
		}
		
		protected function onComponentClick ( e:MouseEvent ):void {
			this.selectComponent(e.currentTarget == _selectedComponent ? null : GraphicsComponent(e.currentTarget));
		}
		
		protected function onDemoHolderClick ( e:MouseEvent ):void {
			if (e.target == _demoHolder) {
				this.selectComponent(null);
			}
		}
		
		protected function selectComponent ( graphicsComponent:GraphicsComponent ):void {
			var background:BoxBackground;
			
			if (_selectedComponent) {
				_selectedComponent.filters = null;
			}
			
			_selectedComponent = graphicsComponent;
			var disabled:Boolean = !Boolean(_selectedComponent);
			if (disabled) {
				_demoPanel.classNameInputfield.enabled = _demoPanel.idInputField.enabled = _demoPanel.nameInputField.enabled = _demoPanel.removeComponentButton.enabled = false;
				_demoPanel.classNameInputfield.text = _demoPanel.idInputField.text = _demoPanel.nameInputField.text = "";
			} else {
				_demoPanel.classNameInputfield.enabled = _demoPanel.idInputField.enabled = _demoPanel.nameInputField.enabled = _demoPanel.removeComponentButton.enabled = true;
				var id:String = _selectedComponent.id, className:String = _selectedComponent.className, name:String = _selectedComponent.name;
				_demoPanel.idInputField.text = id ? id : "";
				_demoPanel.classNameInputfield.text = className ? className : "";
				_demoPanel.nameInputField.text = name ? name : "";
				_selectedComponent.filters = [ new GlowFilter(0x0000FF, 1, 5, 5, 1) ];
			}
		}
		
		protected function onAddButtonClick ( e:MouseEvent ):void {
			this.selectComponent(this.addComponent());
		}
		
		protected function onRemoveButtonClick ( e:MouseEvent ):void {
			if (_selectedComponent) {
				this.removeComponent(_selectedComponent);
			}
		}
		
		protected function onResetButtonClick ( e:MouseEvent ):void {
			this.setDefaults();
		}
		
		protected function onStyleChange ( e:KeyboardEvent ):void {
			try {
				var xml:XML = this.getXMLFromCSS(_demoPanel.styleSheetXMLInput.text);
				this.parseStyleSheet();
 			} catch ( error:Error ) {
				
			}
		}
		
		protected function onIDChange ( e:KeyboardEvent ):void {
			_selectedComponent.id = _demoPanel.idInputField.text;
		}
		
		protected function onClassNameChange ( e:KeyboardEvent ):void {
			_selectedComponent.className = _demoPanel.classNameInputfield.text;
		}
		
		protected function onNameChange ( e:KeyboardEvent ):void {
			_selectedComponent.name = _demoPanel.nameInputField.text;
		}
		
		protected function parseStyleSheet ( ):void {
			var node:StyleRule = StyleManager.getFirstRule(StyleManager.DEFAULT_STYLESHEET_ID);
			var nextNode:StyleRule;
			while (node) {
				nextNode = node.nextNode;
				StyleManager.removeRule(node);
				node = node.nextNode;
			}
			
			var defaultXML:XML = XML(new StyleSheetXML());
			StyleManager.parseXML(defaultXML);
			
			var customCSS:String = _demoPanel.styleSheetXMLInput.text;
			var customXML:XML = this.getXMLFromCSS(_demoPanel.styleSheetXMLInput.text)
			StyleManager.parseXML(customXML);
			
		}
		
		protected function getXMLFromCSS ( css:String ):XML {
			var xml:XML = <style/>;
			var match:Array = css.match(/(.*?){(.*?)}/gms);
			if (!match) {
				throw new Error("Error parsing css");
			}
			
			var matchedString:String, childMatch:Array, propertyMatch:Array, keyValueMatch:Array, name:String, value:String;
			var where:String, node:XML;
			var i:int, l:int, j:int, m:int;
			for (i= 0, l = match.length; i < l; ++i) {
				matchedString = match[i];
				childMatch = matchedString.match(/\s*(.*?)\s*{\s+(.*?)\s*}/ms);
				if (childMatch) {
					node = new XML("<rule where='" + childMatch[1] + "'/>");
					if (childMatch[2]) {
						propertyMatch = String(childMatch[2]).match(/\s*(.*?):\s*(.*?);\s*/gms);
						if (propertyMatch) {
							m = propertyMatch.length;
							for (j = 0; j < m; ++j) {
								keyValueMatch = String(propertyMatch[j]).match(/\s*(.*?):\s*(.*?);\s*/ms);
								name = keyValueMatch[1];
								value = keyValueMatch[2];
								node.appendChild(new XML("<property name='"+name+"'>"+value+"</property>"));
							}
						}
					}
					xml.appendChild(node);
				}
			}
			return xml;
		}
		
	}

}