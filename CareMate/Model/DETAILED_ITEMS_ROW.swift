/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct DETAILED_ITEMS_ROW : Mappable {
	var iTEM_AR_NAME : String?
	var iTEM_EN_NAME : String?
	var iTEM_ID : String?
	var iTEM_DISPLAY_NEW : String?
	var iTEM_TYPE_SETUP : ITEM_TYPE_SETUP?
	var tRANSSERIAL : String?
	var dEGREE_VALUE : String?
	var rEMARK : String?
	var sERIAL : String?
    var ID_VALUE = "-1"
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		iTEM_AR_NAME <- map["ITEM_AR_NAME"]
		iTEM_EN_NAME <- map["ITEM_EN_NAME"]
		iTEM_ID <- map["ITEM_ID"]
		iTEM_DISPLAY_NEW <- map["ITEM_DISPLAY_NEW"]
		iTEM_TYPE_SETUP <- map["ITEM_TYPE_SETUP"]
		tRANSSERIAL <- map["TRANSSERIAL"]
		dEGREE_VALUE <- map["DEGREE_VALUE"]
		rEMARK <- map["REMARK"]
		sERIAL <- map["SERIAL"]
	}

}
