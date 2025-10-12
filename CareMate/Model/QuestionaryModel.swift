/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct QuestionaryModel : Mappable {
    var iTEM_ID : String?
    var iTEM_AR_NAME : String?
    var iTEM_EN_NAME : String?
    var rEFRENCE : String?
    var hOSP_ID : String?
    var vALUE : String?
    var vALID : String?
    var sORT : String?
    var uSER_ID : String?
    var lAST_MODE_DATE : String?
    var pARENT_ITEM_ID : String?
    var mASTER_CODE : String?
    var iTEM_DISPLAY : String?
    var yESNO_PREFERDDEGREE : String?
    var dETAILED_ITEMS : DETAILED_ITEMS?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        iTEM_ID <- map["ITEM_ID"]
        iTEM_AR_NAME <- map["ITEM_AR_NAME"]
        iTEM_EN_NAME <- map["ITEM_EN_NAME"]
        rEFRENCE <- map["REFRENCE"]
        hOSP_ID <- map["HOSP_ID"]
        vALUE <- map["VALUE"]
        vALID <- map["VALID"]
        sORT <- map["SORT"]
        uSER_ID <- map["USER_ID"]
        lAST_MODE_DATE <- map["LAST_MODE_DATE"]
        pARENT_ITEM_ID <- map["PARENT_ITEM_ID"]
        mASTER_CODE <- map["MASTER_CODE"]
        iTEM_DISPLAY <- map["ITEM_DISPLAY"]
        yESNO_PREFERDDEGREE <- map["YESNO_PREFERDDEGREE"]
        dETAILED_ITEMS <- map["DETAILED_ITEMS"]
    }
    
}
