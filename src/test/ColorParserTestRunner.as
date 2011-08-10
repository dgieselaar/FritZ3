package test {
	import fritz3.display.graphics.parser.color.ColorParser;
	import fritz3.utils.color.ColorUtil;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ColorParserTestRunner extends TestRunner {
		
		public function ColorParserTestRunner() {
		}
		
		override protected function runDesignatedTest():void {
			super.runDesignatedTest();
			var parser:ColorParser = ColorParser.parser;
			
			var _defaultResult:Object = { alpha: 1, color: 0x000000 };
			// tests taken from: http://www.w3.org/Style/CSS/Test/CSS3/Color/current/html4//
			var tests:Array = [
				// test keywords
				{ id: "green", value: "green", expectedResult: { alpha: 1, color: 0x008000 } },
				{ id: "blue", value: "blue", expectedResult: { alpha: 1, color: 0x0000FF } },
				{ id: "BLUE", value: "BLUE", expectedResult: { alpha: 1, color: 0x0000FF } },
				// test 3hex
				{ id: "#e92", value: "#e92", expectedResult: { alpha: 1, color: 0xEE9922 } },
				{ id: "#fb0", value: "#fb0", expectedResult: { alpha: 1, color: 0xFFBB00 } },
				{ id: "#381", value: "#381", expectedResult: { alpha: 1, color: 0x338811 } },
				// test 6hex
				{ id: "#000000", value: "#000000", expectedResult: { alpha: 1, color: 0x000000 } },
				{ id: "#ffffff", value: "#ffffff", expectedResult: { alpha: 1, color: 0xFFFFFF } },
				{ id: "#ff0000", value: "#ff0000", expectedResult: { alpha: 1, color: 0xFF0000 } },
				// test 8hex
				{ id: "#000000FF", value: "#000000FF", expectedResult: { alpha: 1, color: 0x000000 } },
				{ id: "#ffffff00", value: "#ffffff00", expectedResult: { alpha: 0, color: 0xFFFFFF } },
				{ id: "#ff6630FF", value: "#ff6630FF", expectedResult: { alpha: 1, color: 0xff6630 } },
				{ id: "#e4673A33", value: "#e4673A33", expectedResult: { alpha: 0.2, color: 0xe4673A } },
				{ id: "#007EB499", value: "#007EB499", expectedResult: { alpha: 0.6, color: 0x007EB4 } },
				{ id: "#003399CC", value: "#003399CC", expectedResult: { alpha: 0.8, color: 0x003399 } },
				// test rgb
				{ id: "rgb(-30, 500, -1)", value: "rgb(-30, 500, -1)", expectedResult: { alpha: 1, color: 0x00ff00 } },
				{ id: "rgb(0, 255, 0)", value: "rgb(0, 255, 0)", expectedResult: { alpha: 1, color: 0x00ff00 } },
				{ id: "rgb(-260, -254, 300)", value: "rgb(-260, -254, 300)", expectedResult: { alpha: 1, color: 0x0000ff } },
				{ id: "rgb(0, 0, 255)", value: "rgb(0, 0, 255)", expectedResult: { alpha: 1, color: 0x0000ff } },
				{ id: "rgb(-10%, 200%, -1%)", value: "rgb(-10%, 200%, -1%)", expectedResult: { alpha: 1, color: 0x00ff00 } },
				{ id: "rgb(0, 255, 0)", value: "rgb(0, 255, 0)", expectedResult: { alpha: 1, color: 0x00ff00 } },
				{ id: "rgb(50, -30, 255)", value: "rgb(50, -30, 255)", expectedResult: { alpha: 1, color: 0x3200FF } },
				{ id: "rgb(50, 0, 255)", value: "rgb(50, 0, 255)", expectedResult: { alpha: 1, color: 0x3200FF } },
				// test hsl
				{ id: "hsl(120, 100%, 25%)", value: "hsl(120, 100%, 25%)", expectedResult: { alpha: 1, color: 0x007F00 } },
				{ id: "hsl(240, 100%, -100%)", value: "hsl(240, 100%, -100%)", expectedResult: { alpha: 1, color: 0x000000 } },
				{ id: "hsl(240, 75%, 120%)", value: "hsl(240, 75%, 120%)", expectedResult: { alpha: 1, color: 0xFFFFFF } },
				{ id: "hsl(264, 130%, 50%)", value: "hsl(264, 130%, 50%)", expectedResult: { alpha: 1, color: 0x6600FF } },
				{ id: "hsl(-360, 100%, 50%)", value: "hsl(-360, 100%, 50%)", expectedResult: { alpha: 1, color: 0xFF0000 } },
				{ id: "hsl(540, 100%, 50%)", value: "hsl(540, 100%, 50%)", expectedResult: { alpha: 1, color: 0x00FFFF } },
				{ id: "hsl(-104880, 100%, 50%)", value: "hsl(-104880, 100%, 50%)", expectedResult: { alpha: 1, color: 0x0000FF } },
				// test rgba
				{ id: "rgba(0, 0, 0, 1)", value: "rgba(0, 0, 0, 1)", expectedResult: { alpha: 1, color: 0x000000 } },
				{ id: "rgba(0, 0, 0, 0)", value: "rgba(0, 0, 0, 0)", expectedResult: { alpha: 0, color: 0x000000 } },
				{ id: "rgba(0, 0, 0, 0.6)", value: "rgba(0, 0, 0, 0.6)", expectedResult: { alpha: 0.6, color: 0x000000 } },
				{ id: "rgba(0, 0, 0, -0.0)", value: "rgba(0, 0, 0, -0.0)", expectedResult: { alpha: 0, color: 0x000000 } },
				{ id: "rgba(0, 0, 0, -7439.79)", value: "rgba(0, 0, 0, -7439.79)", expectedResult: { alpha: 0, color: 0x000000 } },
				{ id: "rgba(0, 0, 0, 30)", value: "rgba(0, 0, 0, 30)", expectedResult: { alpha: 1, color: 0x000000 } },
				{ id: "rgba(-30, 500, -1, 0.6)", value: "rgba(-30, 500, -1, 0.6)", expectedResult: { alpha: 0.6, color: ColorUtil.getUintFromRGB(0, 255, 0) } },
				{ id: "rgba(-10%, 200%, -1%, 0.4)", value: "rgba(-10%, 200%, -1%, 0.4)", expectedResult: { alpha: 0.4, color: ColorUtil.getUintFromRGB(0, 255, 0) } },
				// TODO: add more hsla tests
				{ id: "hsla(120, 100%, 25%,.4)", value: "hsla(120, 100%, 25%,.4)", expectedResult: { alpha: 0.04, color: 0x007F00 } },
				{ id: "hsla(240, 100%, -100%, 0.09)", value: "hsla(240, 100%, -100%, 0.09)", expectedResult: { alpha: 0.09, color: 0x000000 } },
				{ id: "hsla(240, 75%, 120%, 747473)", value: "hsla(240, 75%, 120%, 747473)", expectedResult: { alpha: 1, color: 0xFFFFFF } },
				{ id: "hsla(264, 130%, 50%, -9393.1)", value: "hsla(264, 130%, 50%, -9393.1)", expectedResult: { alpha: 0, color: 0x6600FF } },
				{ id: "hsla(-360, 100%, 50%, 1)", value: "hsla(-360, 100%, 50%, 1)", expectedResult: { alpha: 1, color: 0xFF0000 } },
				{ id: "hsla(540, 100%, 50%,0)", value: "hsla(540, 100%, 50%,0)", expectedResult: { alpha: 0, color: 0x00FFFF } },
				{ id: "hsla(-104880, 100%, 50%)", value: "hsla(-104880, 100%, 50%, 0.2)", expectedResult: { alpha: 0.2, color: 0x0000FF } },
			];
			
			var tst:Object, result:Object, succes:Boolean;
			var numSucceeded:int, numError:int, numTotal:int;
			for (var i:int, l:int = tests.length; i < l; ++i) {
				tst = tests[i];
				result = parser.parseValue(tst.value);
				succes = assertEquals(result, tst.expectedResult);
				numTotal++;
				if (succes) {
					numSucceeded++;
				} else {
					numError++;
					trace("Error: " + tst.value + " (expected " + tst.expectedResult.alpha + "/" + ColorUtil.getStringFromUint(tst.expectedResult.color) + ", got " + (result ? (result.alpha + "/" + ColorUtil.getStringFromUint(result.color)) : null)) + ")";
				}
			}
			
			trace("Ran " + numTotal + " tests: " + (numError ? (numError + " errors") : " All OK"));
			
			function assertEquals ( result:Object, expected:Object ):Boolean {
				for (var id:Object in result) {
					if (expected && result[id] != expected[id]) {
						return false;
					}
				}
				for (id in expected) {
					if (result && expected[id] != result[id]) {
						return false;
					}
				}
				return true;
			}
		}
		
		override protected function getTimeout():int {
			return 0;
		}
		
		override protected function getMaxIterations():int {
			return 0;
		}
		
	}

}