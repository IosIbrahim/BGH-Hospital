//
//  Constants.swift
//  Phunations
//
//  Created by Yo7ia on 11/10/16.
//  Copyright © 2016 AMIT. All rights reserved.
//

import Foundation
import UIKit
//import NitroUIColorCategories
import OhhAuth
//struct Color {
//    static let black = UIColor(fromARGBHexString:"000000")
//    static let titleGreen = UIColor(fromARGBHexString:"ffffff")
//    static let gray = UIColor(fromARGBHexString: "444444")
//    static let lightGray = UIColor(fromARGBHexString: "E4E4E4")
//    static let GoldenYellow = UIColor(fromARGBHexString: "FEDA75")
//    static let darkGray = UIColor(fromARGBHexString: "13437b")
//    static let white = UIColor(fromARGBHexString: "ffffff")
//    static let RedColor = UIColor(fromARGBHexString: "DB235B")
//    static let GreenColor = UIColor(fromARGBHexString: "2CB78A")
//    static let darkGray2 = UIColor(fromARGBHexString: "ea8220")
//    
//}
struct Constants {
    
    fileprivate static let ScreenSize: CGRect = UIScreen.main.bounds
    static let ScreenWidth = ScreenSize.width
    static let ScreenHeight = ScreenSize.height
    static let DeviceID = UIDevice.current.identifierForVendor!.uuidString
    static let oAuthValueOnline = "oauth_signature_method=HMAC-SHA1&oauth_consumer_key=khaber_1&oauth_version=1.0&oauth_timestamp=0120110010&oauth_nonce=010011012&oauth_signature=iclDhfFldNcHKeGCDzhW5/Rso+c="
     static let oAuthValueDoctors = "oauth_signature_method=HMAC-SHA1&oauth_consumer_key=khaber_1&oauth_version=1.0&oauth_timestamp=0120110010&oauth_nonce=010011012&oauth_signature=UFtWF6scamOd/OXgYL3k4xklgXQ="
    static let oAuthValueSlots = "oauth_signature_method=HMAC-SHA1&oauth_consumer_key=khaber_1&oauth_version=1.0&oauth_timestamp=0120110010&oauth_nonce=010011012&oauth_signature=UFtWF6scamOd/OXgYL3k4xklgXQ="
    static let oAuthValueReservation = "oauth_signature_method=HMAC-SHA1&oauth_consumer_key=khaber_1&oauth_version=1.0&oauth_timestamp=0120110010&oauth_nonce=010011012&oauth_signature=UFtWF6scamOd/OXgYL3k4xklgXQ="
    static let oAuthValueLogin = "oauth_signature_method=HMAC-SHA1&oauth_consumer_key=khaber_1&oauth_version=1.0&oauth_timestamp=0120110010&oauth_nonce=010011012&oauth_signature=UFtWF6scamOd/OXgYL3k4xklgXQ="
    static let oAuthValueRegister = "oauth_signature_method=HMAC-SHA1&oauth_consumer_key=khaber_1&oauth_version=1.0&oauth_timestamp=0120110010&oauth_nonce=010011012&oauth_signature=UFtWF6scamOd/OXgYL3k4xklgXQ="

    static let COSTUMER_KEY = "khaber_1"
    static let COSTUMER_PASS = "khabeerP@$$w0rd"
    public static func getoAuthValue(url:URL , method: String , parameters: [String: String]? = nil) -> String
    {
        
        let cc = (key: COSTUMER_KEY, secret: COSTUMER_PASS)
//        return url.absoluteString.contains("doctor") ? oAuthValueDoctors : oAuthValueOnline
        return OhhAuth.calculateSignature(url: url, method: method, parameter: parameters != nil ? parameters! : [:], consumerCredentials: cc, userCredentials: nil)
    }
    struct UserDefaultsConstants {
        static let Email = "email"
        static let UserData = "UserData"
        static let Password = "password"
        static let FirstTime = "firstTime"
        static let isSocial = "isSocial"
        static let Token = "token"
    }
    
    struct APIProvider {
        static var IP =  "patientmobapp.alsalamhosp.com"
        static var IP_WITHOUT_PORT =  "patientmobapp.alsalamhosp.com"
         //Test
       // static var IMAGE_BASE2 = "https://patientmobapp.alsalamhosp.com/mobileapi/"  // live
      //  static var APIBaseURL = "https://patientmobapp.alsalamhosp.com/mobileapi/api/"  // live
      //  static var IMAGE_BASE = "https://patientmobapp.alsalamhosp.com/mobileapi/"
        // live
        static var APIBaseURL = "https://pr-h1services04.sherafia.bhg.com.sa/MobileApi/api/"    // test
        static var IMAGE_BASE = "https://pr-h1services04.sherafia.bhg.com.sa/MobileApi"   // test
        static var IMAGE_BASE2 = "https://pr-h1services04.sherafia.bhg.com.sa/MobileApi" // test
       
        static var SIHORPriceCare = "Primecaresihtest"
        static var Register = APIBaseURL+"register"
        static var Login = APIBaseURL+"patient_login?"
        static var Signup = APIBaseURL+"patient_signup?"
        static var SignupFirst = APIBaseURL+"check_patient_found_bakhsh"
        static var SignupSecond = APIBaseURL+"sendMail_for_patient_signup_bakhsh"

        static var logout = APIBaseURL+"patient_logout"
        static var submit_patient_password = APIBaseURL+"submit_patient_password?"
        static var signupvalidateCode = APIBaseURL+"signupvalidateCode?"
        
        static var validateCode = APIBaseURL+"validateCode?"
        static var get_govs_by_country = APIBaseURL+"get_govs_by_country?"
        static var get_cities = APIBaseURL+"get_cities?"
        static var get_villages = APIBaseURL+"get_villages?"
        static var getPacsUrl = APIBaseURL+"getPacsUrlMob?"
        static var getRadPacsUrl = APIBaseURL+"RadiologyController/getPacsReportUrlMob?"
        static var getPacsUrlPatient = APIBaseURL+"Confirmwritting?"

        static var GetOnlineAppointment = APIBaseURL+"load_online_appointment"
        static var getBranchesOnly = APIBaseURL+"loadBranches"
        static var getSpecialities = APIBaseURL+"loadBranchSpecilities?"
        static var GetDoctors = APIBaseURL+"get_doctors?"
        static var SpeclitiesImages = "https://\(IP)/MobileApi/images/SpeclitiesImages"
        static var getReservationServices = APIBaseURL+"getReservationServices?"
        
        static var getPatientAllergy = APIBaseURL+"MedicalRecord/getPatientAllergy?"
        static var getPatientOperation = APIBaseURL+"MedicalRecord/getPatientOperation?"
        static var CRMCOMPLAINTHistory = APIBaseURL+"CrmController/CRMCOMPLAINTHistory?"
        static var load_patient_family = APIBaseURL+"load_patient_family?"
        static var load_patient_accounts = APIBaseURL+"MedicalRcordController/getSamePatMobileNumber?"
        static var getPatientDiagnosis = APIBaseURL+"MedicalRecord/getPatientDiagnosis?"
    
        static var searchSickleave = APIBaseURL+"MedicalRecordController/searchSickleave?"
        static var searchSickleave2 = APIBaseURL+"MedicalRecord/loadScanVisitCategory?"
        static var sickleaveReport = APIBaseURL+"Hr/loadImage"
        static var printSickLeave = APIBaseURL+"MedicalRcordController/printSickLeave?"
        static var loadServiceResult = APIBaseURL+"MedicalRecordController/loadServiceResult?"
        static var ReportingPages = "http://\(Constants.APIProvider.IP)/"+"PrimeCare/Reporting/Pages/dxReportViewer.aspx؟"

   
        static var DDDocNurseNotesLoad = IP + "MobileApi/api/MedicalRcordController/DDDocNurseNotesLoad?"
        static var patientReportsRequests = APIBaseURL+"MedicalRecordController/patientReportsRequests?"
        static var loadReport = APIBaseURL+"MedicalRecordController/loadMinistryReports?"
        static var deleteReport = APIBaseURL+"MedicalRecord/cancelPrintRequest?"
        static var GetPatientHistory = APIBaseURL+"MedicalRecord/GetPatientHistory?"
        static var load_patient_data = APIBaseURL+"load_patient_data?"
        static var searchDoctors = APIBaseURL+"DoctorController/searchScheduledDoctors?"
        
        static var getKnowYourDoctor = APIBaseURL+"getKnowYourDoctorLink"
        static var allSurvies = APIBaseURL+"loadPatCrmSatisficationMeasure?"
        static var ambulanceHistory = APIBaseURL+"MedicalRecord/loadAmbulanceRequests?"
        static var ambulanceCancelReasons = APIBaseURL+"MedicalRecord/loadAmbulanceCancellReasons?"
        static var cancelAmbulanceRequest = APIBaseURL+"MedicalRecordController/cancelAmbulanceRequest?"
        static var PatReceipts = APIBaseURL+"BillingController/patientReceipt?"
        static var getVisitForPatient = APIBaseURL +    "DoctorController/getVisitForPatient?"
        
        static let CRMCOMPLAINTSLOAD = APIBaseURL +    "CrmController/CRMCOMPLAINTSLOAD?"
        static let loadPatNotification = APIBaseURL +    "loadPatNotification?"
        static let notificationGroups = APIBaseURL + "AlertMangmentController/GET_ALERTS_COUNTS?"
        static let notifGroupDetail = APIBaseURL + "AlertMangmentController/GET_ALERTS_DETAILS?"
        static let getNotificationCount = APIBaseURL +    "AlertMangmentController/GET_USER_PAT_ALERTS_COUNT?OBJECT_TYPE=3&BRANCH_ID=1&SEARCH_TEXT=&USER_ID="
        static let updateNotificationCount = APIBaseURL + "AlertMangmentController/UPDATE_MULTI_ALERT_STATUS"

        static let loadPatNotificationDetails = APIBaseURL +    "loadPatNotificationDetils?"
        static let getVisitDetailsForPatient = APIBaseURL +    "DoctorController/getVisitDetailsForPatient?"
        static var PrimeCareTempFiles =  "http://"  + IP  + "/TempFiles/ReportPDFS/"
        static var LOADPRINTREPORTREQUEST = APIBaseURL +    "MedicalRecord/LOADPRINTREPORTREQUEST?"
        static var PatInvoices = APIBaseURL+"BillingController/patientInvoice?"
        
        static var getAmbuNurseServicePrice = APIBaseURL+"getAmbuNurseServicePrice?"
        static var gethvhcServicePrice = APIBaseURL+"gethvhcServicePrice?"
        static var LoadERCALLCENTER = APIBaseURL+"LoadERCALLCENTER?"
        static var getAmbuDocServicePrice = APIBaseURL+"getAmbuDocServicePrice?"
        static var GetDoctorProfile = APIBaseURL+"get_profile_docotr?emp_id="
        static var GetDoctorTimeSlots = APIBaseURL+"get_doc_next_availble_slot?"
        static var SubmitAppointment = APIBaseURL+"submit_appointment?"
        
        static var ConfirmAppointment = APIBaseURL+"DoctorController/confirmPatientReservation?"
        static var sendMessage = IP+"MobileApi/api/MedicalRcordController/DDDocNurseNotesSave"
        static var SubmitStepNew = APIBaseURL+"SubmitStepNew"
        static var PRINTREPORTSUBMIT = APIBaseURL+"MedicalRecordController/PRINTREPORTSUBMIT"
        static var MyAppointment = APIBaseURL+"getPatientOnlineAppointment?"
        static var doctorProfiledata = APIBaseURL+"PersonalController/loadEmplyeeBiography?"
        static var OutpatientControllersearchOpCallCenter = APIBaseURL+"OutpatientController/searchOpCallCenter?"

  
        
        static var CrmControllerCOMPLAINTSSAVE = APIBaseURL+"CrmController/COMPLAINTSSAVE"
        static var update_patientprofile = APIBaseURL+"update_patientprofile"
        static var getCurrentMed = APIBaseURL+"StockController/getCurrentMed?"
        static var schedule_items = APIBaseURL+"StockController/schedule_items?"
        static var getPatPrescHistory = APIBaseURL+"StockController/getPatPrescHistory?"
        static var getPatPrescHistoryItems = APIBaseURL+"StockController/getPatPrescHistoryItems?"
        static var getDrugHistory = APIBaseURL+"StockController/getDrugHistory?"
        
        static var LabReqHistoryload = APIBaseURL+"LabReqHistoryload?"
        static var clinicServicesReports = APIBaseURL+"MedicalRecord/getIntegMachines?"
        static var clinicServicesReportsVisits = APIBaseURL+"MedicalRecord/getIntegPatVisits?"
        static var clinicServicesReportsVisitsResults = APIBaseURL+"MedicalRecord/getIntegPatVisitResult?"
        static var RadReqHistoryload = APIBaseURL+"RadReqHistoryload?"
        static var GetQuestionary = APIBaseURL+"get_questionar_mobile"
        static var SaveQuestionary = APIBaseURL+"submit_online_surveynew"
        
        static var VERIFYPATIENTID = APIBaseURL+"verify_patient_identity_sms"
        static var verifyQuestNumber = APIBaseURL+"verifyQuestNumber"
        static var validate_update_mobile_no = APIBaseURL+"validate_update_mobile_no"
        static var CHANGEPASSWORD = APIBaseURL+"submit_patient_password"
        static var GETPATIENTID = APIBaseURL+"detect_patient_identity"
        static var VALIDATECODE = APIBaseURL+"validateCode"
        static var GetLabServiceResult = APIBaseURL+"get_service_result?"
        
        static var MedicalReports = APIBaseURL + "MedicalRcordController/loadMedicalReport?"
        static var MedicalReportDetails = APIBaseURL + "MedicalRcordController/loadPatReportBySerial?"
        static var prhtermsPDF = IMAGE_BASE + "images/prhterms.pdf"
        static var generatePDF = IMAGE_BASE + "LaboratoryController/generatePdf"


        //01013084123 P@$$w0rd
       }
   
    public func updateIP(ip:String) {
        Constants.APIProvider.IP = ip
     //   Constants.APIProvider.APIBase = "http://"+ip+"/MobileApi/api/"
        Constants.APIProvider.APIBaseURL = Constants.APIProvider.APIBaseURL
        Constants.APIProvider.Register = Constants.APIProvider.APIBaseURL+"register"
        Constants.APIProvider.Login = Constants.APIProvider.APIBaseURL+"patient_login?"
        Constants.APIProvider.GetOnlineAppointment = Constants.APIProvider.APIBaseURL+"load_online_appointment"
        Constants.APIProvider.GetDoctors = Constants.APIProvider.APIBaseURL+"get_doctors?"
        Constants.APIProvider.GetDoctorProfile = Constants.APIProvider.APIBaseURL+"get_profile_docotr?emp_id="
        Constants.APIProvider.GetDoctorTimeSlots = Constants.APIProvider.APIBaseURL+"get_doc_next_availble_slot?"
        Constants.APIProvider.SubmitAppointment = Constants.APIProvider.APIBaseURL+"submit_appointment"
        Constants.APIProvider.MyAppointment = Constants.APIProvider.APIBaseURL+"getPatientOnlineAppointment?PATIENT_ID="
        Constants.APIProvider.getDrugHistory = Constants.APIProvider.APIBaseURL+"StockController/getDrugHistory?"
        Constants.APIProvider.LabReqHistoryload = Constants.APIProvider.APIBaseURL+"LabReqHistoryload?"
        Constants.APIProvider.RadReqHistoryload = Constants.APIProvider.APIBaseURL+"RadReqHistoryload?"
    }
}
//NiceDice
struct ConstantsData {
    static let survey = "http://\(Constants.APIProvider.IP)/mobileApi/images/survey.png"
    static let vitual = "http://\(Constants.APIProvider.IP)/mobileApi/images/virtualTour.png"
    static let locationIMG = "https://\(Constants.APIProvider.IP)/mobileApi/images/ourLocation.png"
    static let linkedin = "https://www.linkedin.com/company/bhghospital"
    static let email = "info@drbakhsh.com"
    static let facebook = "https://www.facebook.com/bhghospital/"
    static let mobile = "0126510666"
    static let whatsapp = "0126510555"
    static let twitter = "https://x.com/BHGHOSPITAL"
    static let instegram = "https://www.instagram.com/bhghospital/"
    static let snapchat = ""
    static let youtube = "https://www.youtube.com/@bhghospital"
    static let drama = "https://www.drbakhsh.com/"
    static let lat1 = 21.5203866
    static let long1 = 39.1910548
}
