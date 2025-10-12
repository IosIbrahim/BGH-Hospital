

import Foundation

// MARK: - Welcome
struct ErCallCenterrBigModel {
    let erParms: ErParms?
    var erCallCenterr: [ErCallCenterr]?
    init(ErParmsObject : ErParms,erCallCenterrOb:[ErCallCenterr]) {
        self.erParms = ErParmsObject
        self.erCallCenterr = erCallCenterrOb
       }

}

// MARK: - ErCallCenterr
struct ErCallCenterr {
    var bufferStatus, callarName, homePhone, govID: String?
    var cityID, villageCode, address, newRemarks: String?
    var callType, ambulanceDocNeed, ambulanceNurseNeed, ambulanceCarType: String?
    var callPatType, patientID: String?

    var DATE_OF_BIRTH:String?
    var years:Int?
    var NEW_REMARKS:String?
    var F_NAME:String?

    var S_NAME:String?
    var T_NAME:String?
    var L_NAME:String?
    var GENDER:String?
    var group:String?
    var A2sima:String?
    var ADDRESS:String?
    var AumotedNumber:String?
    var bulidingNumber:String?
    var DATE_OF_BIRTH_STR_FORMATED:String?
    var HOME_VISIT_CAR_TYPE:String?
    var PAT_AGE:Int?
    
   
    
    
}

// MARK: - ErParms
struct ErParms {
    let branchID, processID, userID, computerName: String?
    let inOutCity: String?

  
}

struct homeVisitAmbulance {
    var nameEn = ""
    var nameAr = ""
    var id  = ""
}
//</CALLAR_NAME><HOME_PHONE>9565466446</HOME_PHONE><GOV_ID>1</GOV_ID><CITY_ID>1</CITY_ID><STREETNAME>القسيمة</STREETNAME><BUILDING_NO>رقم/المبني/المنزل</BUILDING_NO><DATE_OF_BIRTH>01/01/1990 00:00:00</DATE_OF_BIRTH><DATE_OF_BIRTH_STR_FORMATED>01-01-1990 00:00:00</DATE_OF_BIRTH_STR_FORMATED><NEW_REMARKS>الملاحظات</NEW_REMARKS><F_NAME>جلال</F_NAME><S_NAME>جلال</S_NAME><T_NAME>جلال</T_NAME><L_NAME></L_NAME><F_NAME_EN>Galal</F_NAME_EN><S_NAME_EN>Galal</S_NAME_EN><T_NAME_EN>Galal</T_NAME_EN><L_NAME_EN></L_NAME_EN><PAT_AGE>31</PAT_AGE><GENDER>M</GENDER><ADDRESS>الدقهلية المنصورة مجموعة ميت خميس القسيمة رقم/المبني/المنزل الرقم الألي</ADDRESS><CALL_TYPE>1</CALL_TYPE><AMBULANCE_NURSE_NEED>1</AMBULANCE_NURSE_NEED><AMBULANCE_DOC_NEED>1</AMBULANCE_DOC_NEED><CALL_PAT_TYPE>3</CALL_PAT_TYPE><VILLAGE_CODE>2</VILLAGE_CODE><BUILDING_COMPUTER_SERIAL>الرقم الألي</BUILDING_COMPUTER_SERIAL><ADDRESS_BLOCK_DESC>مجموعة</ADDRESS_BLOCK_DESC><AMBULANCE_CAR_TYPE>4</AMBULANCE_CAR_TYPE><BUFFER_STATUS>1</BUFFER_STATUS></ER_CALL_CENTERR></Root>';
