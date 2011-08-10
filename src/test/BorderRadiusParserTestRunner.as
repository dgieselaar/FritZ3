package test {
	import fritz3.base.parser.IPropertyParser;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.graphics.BorderRadiusValue;
	import fritz3.display.graphics.parser.border.BorderRadiusData;
	import fritz3.display.graphics.parser.border.BorderRadiusParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class BorderRadiusParserTestRunner extends ParserTestRunner {
		
		public function BorderRadiusParserTestRunner ( ) {
			
		}
		
		override protected function getParser():IPropertyParser {
			return BorderRadiusParser.parser;	
		}
		
		override protected function getTests():Array {
			var px1dv:DisplayValue = new DisplayValue(1, DisplayValueType.PIXEL);
			var perc10dv:DisplayValue = new DisplayValue(10, DisplayValueType.PERCENTAGE);
			var px1bv:BorderRadiusValue = new BorderRadiusValue(px1dv.clone(), px1dv.clone());
			var pc10bv:BorderRadiusValue = new BorderRadiusValue(perc10dv.clone(), perc10dv.clone());
			var mixedPercPx:BorderRadiusValue = new BorderRadiusValue(perc10dv.clone(), px1dv.clone());
			
			var tests:Array = [
				{ id: "1px", value: "1px", expectedResult: new BorderRadiusData(px1bv, px1bv, px1bv, px1bv) },
				{ id: "10% / 1px", value: "10% / 1px", expectedResult: new BorderRadiusData(mixedPercPx, mixedPercPx, mixedPercPx, mixedPercPx) },
				{ id: "4px 2px / 1px 3px", value: "4px 2px / 1px 3px", expectedResult: new BorderRadiusData(new BorderRadiusValue(new DisplayValue(4), new DisplayValue(1)), new BorderRadiusValue(new DisplayValue(2), new DisplayValue(3)), new BorderRadiusValue(new DisplayValue(4), new DisplayValue(1)), new BorderRadiusValue(new DisplayValue(2), new DisplayValue(3))) },
				{ id: "10px 2px 1px 1px / 1px", value: "10px 2px 1px 1px / 1px", expectedResult: new BorderRadiusData(new BorderRadiusValue(new DisplayValue(10), new DisplayValue(1)), new BorderRadiusValue(new DisplayValue(2), new DisplayValue(1)), new BorderRadiusValue(new DisplayValue(1), new DisplayValue(1)), new BorderRadiusValue(new DisplayValue(1), new DisplayValue(1))) },
				{ id: "14px 0px 0px 7px / 2px 3px 1px", value: "14px 0px 0px 7px / 2px 3px 1px", expectedResult: new BorderRadiusData(new BorderRadiusValue(new DisplayValue(14), new DisplayValue(2)), new BorderRadiusValue(new DisplayValue(0), new DisplayValue(3)), new BorderRadiusValue(new DisplayValue(0), new DisplayValue(1)), new BorderRadiusValue(new DisplayValue(7), new DisplayValue(3))) },
				{ id: "0 / 0", value: "0 / 0", expectedResult: new BorderRadiusData(new BorderRadiusValue(new DisplayValue(0), new DisplayValue(0)), new BorderRadiusValue(new DisplayValue(0), new DisplayValue(0)), new BorderRadiusValue(new DisplayValue(0), new DisplayValue(0)), new BorderRadiusValue(new DisplayValue(0), new DisplayValue(0))) },
				{ id: "foo", value: "foo", expectedResult: new BorderRadiusData() }
			];
			
			return tests;
		}
		
		override protected function assertEquals(result:Object, expectedResult:Object):Boolean {
			return BorderRadiusData(result).assertEquals(BorderRadiusData(expectedResult));
		}
		
	}

}