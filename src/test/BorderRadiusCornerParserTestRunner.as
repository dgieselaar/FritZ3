package test {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.BorderRadiusValue;
	import fritz3.display.graphics.parser.border.BorderRadiusCornerParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderRadiusCornerParserTestRunner extends ParserTestRunner {
		
		public function BorderRadiusCornerParserTestRunner() {
			super();
		}
		
		override protected function getTests ( ):Array {
			var tests:Array = [
			{ id: "4px 10%", value: "4px 10%", expectedResult: new BorderRadiusValue(new DisplayValue(4, DisplayValueType.PIXEL), new DisplayValue(10, DisplayValueType.PERCENTAGE)) },
			{ id: "4px 4px", value: "4px 4px", expectedResult: new BorderRadiusValue(new DisplayValue(4, DisplayValueType.PIXEL), new DisplayValue(4, DisplayValueType.PIXEL)) },
			{ id: "10% 10%", value: "10% 10%", expectedResult: new BorderRadiusValue(new DisplayValue(10, DisplayValueType.PERCENTAGE), new DisplayValue(10, DisplayValueType.PERCENTAGE)) },
			{ id: "10 10", value: "10 10", expectedResult: new BorderRadiusValue(new DisplayValue(10, DisplayValueType.PIXEL), new DisplayValue(10, DisplayValueType.PIXEL)) },
			{ id: "5%", value: "5%", expectedResult: new BorderRadiusValue(new DisplayValue(5, DisplayValueType.PERCENTAGE), new DisplayValue(5, DisplayValueType.PERCENTAGE)) },
			{ id: "12px", value: "12px", expectedResult: new BorderRadiusValue(new DisplayValue(12, DisplayValueType.PIXEL), new DisplayValue(12, DisplayValueType.PIXEL)) },
			{ id: "0", value: "0", expectedResult: new BorderRadiusValue(new DisplayValue(0, DisplayValueType.PIXEL), new DisplayValue(0, DisplayValueType.PIXEL)) }
			];
			
			return tests;
		}
		
		override protected function getParser ( ):IPropertyParser {
			return BorderRadiusCornerParser.parser;
		}
		
		override protected function assertEquals(result:Object, expectedResult:Object ):Boolean {
			return BorderRadiusValue(result).assertEquals(BorderRadiusValue(expectedResult));
		}
		
	}

}