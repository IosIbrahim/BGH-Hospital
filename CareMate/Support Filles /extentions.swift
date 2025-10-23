//
//  extentions.swift
//  MySchool
//
//  Created by Mohamed Elmakkawy on 4/29/17.
//  Copyright © 2017 Mohamed Elmakkawy. All rights reserved.
//

import Foundation
import NitroUIColorCategories
import UIKit
import CCMPopup
class SemiCirleView: UIView {
    
    var semiCirleLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if semiCirleLayer == nil {
            let arcCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let circleRadius = bounds.size.width / 2
            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
            
            semiCirleLayer = CAShapeLayer()
            semiCirleLayer.path = circlePath.cgPath
            semiCirleLayer.fillColor = UIColor.red.cgColor
            layer.addSublayer(semiCirleLayer)
            
            // Make the view color transparent
            backgroundColor = UIColor.clear
        }
    }
}

extension Dictionary {
    
    var queryString: String? {
        var output: String = ""
       
        return output
    }
}
extension URL {
    
        
        /**
         Add, update, or remove a query string parameter from the URL
         
         - parameter url:   the URL
         - parameter key:   the key of the query string parameter
         - parameter value: the value to replace the query string parameter, nil will remove item
         
         - returns: the URL with the mutated query string
         */
        func appendingQueryItem(_ name: String, value: Any?) -> String {
            guard var urlComponents = URLComponents(string: absoluteString) else {
                return absoluteString
            }
            
            urlComponents.queryItems = urlComponents.queryItems?
                .filter { $0.name.lowercased() != name.lowercased() } ?? []
            
            // Skip if nil value
            if let value = value {
                urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
            }
            
            return urlComponents.string ?? absoluteString
        }
        
        /**
         Add, update, or remove a query string parameters from the URL
         
         - parameter url:   the URL
         - parameter values: the dictionary of query string parameters to replace
         
         - returns: the URL with the mutated query string
         */
        func appendingQueryItems(_ contentsOf: [String: Any?]) -> String {
            guard var urlComponents = URLComponents(string: absoluteString), !contentsOf.isEmpty else {
                return absoluteString
            }
            
            let keys = contentsOf.keys.map { $0.lowercased() }
            
            urlComponents.queryItems = urlComponents.queryItems?
                .filter { !keys.contains($0.name.lowercased()) } ?? []
            
            urlComponents.queryItems?.append(contentsOf: contentsOf.flatMap {
                guard let value = $0.value else { return nil } //Skip if nil
                return URLQueryItem(name: $0.key, value: "\(value)")
            })
            
            return urlComponents.string ?? absoluteString
        }
        
        /**
         Removes a query string parameter from the URL
         
         - parameter url:   the URL
         - parameter key:   the key of the query string parameter
         
         - returns: the URL with the mutated query string
         */
        func removeQueryItem(_ name: String) -> String {
            return appendingQueryItem(name, value: nil)
        }
    
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}
extension UIStoryboardSegue
{
    func ccmPopUp(width: Int? = Int(Constants.ScreenWidth-40),height: Int)  {
        let popupSegue = self as! CCMPopupSegue
        
        popupSegue.destinationBounds = CGRect(x: 0, y: 0 , width: width!, height: height)
        popupSegue.backgroundBlurRadius = 0.7
        popupSegue.backgroundViewAlpha = 0.7
        popupSegue.backgroundViewColor = UIColor.black
        popupSegue.dismissableByTouchingBackground = true
        
    }
}
class activitySegue {
    
    class func handlePopupStyle(segue: UIStoryboardSegue) {
        let popupSegue = segue as! CCMPopupSegue
        
        popupSegue.destinationBounds = CGRect(x:0, y: 0 , width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height-150)
        popupSegue.backgroundBlurRadius = 0.7
        popupSegue.backgroundViewAlpha = 0.7
        popupSegue.backgroundViewColor = UIColor.black
        popupSegue.dismissableByTouchingBackground = true
    }
    
    
    
}
extension UIColor {
    
    static let lightGray2 = UIColor(fromARGBHexString:"E2E2E2")
}


extension UILabel
{
    func checkAligment()
    {
//        self.textAlignment = Languages.isArabic() ? .right : .left
    }
}
extension UITextView
{
    func addPadding(_ amount:CGFloat){
        self.contentInset = UIEdgeInsets(top: 0, left: amount, bottom: 0, right: amount)

    }
    func checkAligment()
    {
//        self.textAlignment = Languages.isArabic() ? .right : .left
    }
    
}
extension UITextField
{
    func checkAligment()
    {
//        self.textAlignment = Languages.isArabic() ? .right : .left
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension UIButton
{
    func checkAligment()
    {
//        self.contentHorizontalAlignment = Languages.isArabic() ? .right : .left
    }
}

extension UIImage
{
    /**
     Tint, Colorize image with given tint color<br><br>
     This is similar to Photoshop's "Color" layer blend mode<br><br>
     This is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved<br><br>
     white will stay white and black will stay black as the lightness of the image is preserved<br><br>
     
     <img src="http://yannickstephan.com/easyhelper/tint1.png" height="70" width="120"/>
     
     **To**
     
     <img src="http://yannickstephan.com/easyhelper/tint2.png" height="70" width="120"/>
     
     - parameter tintColor: UIColor
     
     - returns: UIImage
     */
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    func flipImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width, y: self.size.height)
        context.scaleBy(x: -self.scale, y: -self.scale)
        
        context.draw(self.cgImage!, in: CGRect(origin:CGPoint.zero, size: self.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    func roundedimage()
    {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    func Curvyimage()
    {
        self.layer.cornerRadius = self.frame.size.width / 6
        self.clipsToBounds = true
    }
    func Rounded(corner: CGFloat)
    {
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
    }
    func AddBorderWithColor(radius:Int? = 10,borderWidth:CGFloat? = 0,color:String? = "FFFFFF" )
    {
        self.layer.cornerRadius = CGFloat(radius!)
        self.layer.borderWidth = borderWidth!
        self.layer.borderColor = UIColor(fromARGBHexString: color).cgColor
        self.clipsToBounds = true
        
    }
    func AddRoundedBorderWithColor(color:String? = "FFFFFF" )
    {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(fromARGBHexString: color).cgColor
        self.clipsToBounds = true
        
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}




public extension UIDevice {
    enum deviceType {
        case iPodTouch5
        case iPodTouch6
        case iPhone4
        case iPhone4s
        case iPhone5
        case iPhone5c
        case iPhone5s
        case iPhone6
        case iPhone6s
        case iPhone6Plus
        case iPhone6sPlus
        case iPhone7
        case iPhone7Plus
        case iPhoneSE
        case iPad2
        case iPad3
        case iPad4
        case iPadAir
        case iPadAir2
        case iPadMini
        case iPadMini2
        case iPadMini3
        case iPadMini4
        case iPadPro
        case appleTv
        case Simulator
        case identifier
    }
    
    func getPlatformNSString()->String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let DEVICE_IS_SIMULATOR = true
        #else
            let DEVICE_IS_SIMULATOR = false
        #endif
        
        var machineSwiftString : String = ""
        
        if DEVICE_IS_SIMULATOR == true
        {
            // this neat trick is found at http://kelan.io/2015/easier-getenv-in-swift/
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineSwiftString = dir
            }
        } else {
            var size : size_t = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: Int(size))
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            machineSwiftString = String(describing: machine)
        }
        
        //print("machine is \(machineSwiftString)")
        return machineSwiftString
    }
    
    
    
    var modelName: deviceType {
        
        let identifierSimulator = getPlatformNSString()
        
        
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifierIphone = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        var identifier :String = ""
        
        if identifierIphone == "i386" ||  identifierIphone == "x86_64" {
            identifier=identifierSimulator
        }else {
            identifier=identifierIphone
            
        }
        print("identifier=\(identifier)")
        
        switch identifier {
            
        case "iPod5,1":                                 return .iPodTouch5
        case "iPod7,1":                                 return .iPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iPhone4
        case "iPhone4,1":                               return .iPhone4s
        case "iPhone5,1", "iPhone5,2":                  return .iPhone5
        case "iPhone5,3", "iPhone5,4":                  return .iPhone5c
        case "iPhone6,1", "iPhone6,2":                  return .iPhone5s
        case "iPhone7,2":                               return .iPhone6
        case "iPhone7,1":                               return .iPhone6Plus
        case "iPhone8,1":                               return .iPhone6s
        case "iPhone8,2":                               return .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3":                  return .iPhone7
        case "iPhone9,2", "iPhone9,4":                  return .iPhone7Plus
        case "iPhone8,4":                               return .iPhoneSE
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return .iPadAir
        case "iPad5,3", "iPad5,4":                      return .iPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":           return .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return .iPadMini3
        case "iPad5,1", "iPad5,2":                      return .iPadMini4
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return .iPadPro
        case "AppleTV5,3":                              return .appleTv
        case "i386", "x86_64":                          return .Simulator
        default:                                        return .identifier
        }
    }
    
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension String
{
    var unescaped: String {
        let entities = ["\0": "\\0",
                        "\t": "\\t",
                        "\n": "\\n",
                        "\r": "\\r",
                        "\"": "\\\"",
                        "\'": "\\'",
                        ]
        
        return entities
            .reduce(self) { (string, entity) in
                string.replacingOccurrences(of: entity.value, with: entity.key)
            }
            .replacingOccurrences(of: "\\\\(?!\\\\)", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\\\", with: "\\")
            .replacingOccurrences(of: "\\", with: "")
    }
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    var ConvertToDate: Date
    {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm a"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        
        dateFormatter.dateFormat = "MMM d yyyy h:mm"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        dateFormatter.dateFormat = "HH:mm a"
        if dateFormatter.date(from: dateString) != nil {
            return dateFormatter.date(from: dateString)!
        }
        
        if dateString == ""
        {
            return Date()
        }
        return dateFormatter.date(from:dateString) ?? Date()
    }
}
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    var year: Int
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy"
            
            return Int(dateFormatter.string(from: self)) ?? 0
        }
        var month: Int
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "MM"
            
            return Int(dateFormatter.string(from: self)) ?? 0
        }
    var asString: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter.string(from: self)
    }
    var asStringFull: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.full
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter.string(from: self)
    }
    var asStringDMY: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")

        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
    var asStringDMYEN: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en")

        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
    var asStringDMYDashes: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: self)
    }
    var asStringYMD: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    var asStringYMDWithTime: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
    var asStringDMYWithTime: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
    var asStringYMDWithoutZero: String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-d"
        
        return dateFormatter.string(from: self)
    }
    func timeAgoSinceDate(numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        if let year = components.year {
            if (year >= 2) {
                return "\(year) years ago"
            } else if (year >= 1) {
                return stringToReturn(flag: numericDates, strings: ("1 year ago", "Last year"))
            }
        }
        
        if let month = components.month {
            if (month >= 2) {
                return "\(month) months ago"
            } else if (month >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 month ago", "Last month"))
            }
        }
        
        if let weekOfYear = components.weekOfYear {
            if (weekOfYear >= 2) {
                return "\(weekOfYear) months ago"
            } else if (weekOfYear >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 week ago", "Last week"))
            }
        }
        
        if let day = components.day {
            if (day >= 2) {
                return "\(day) days ago"
            } else if (day >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 day ago", "Yesterday"))
            }
        }
        
        if let hour = components.hour {
            if (hour >= 2) {
                return "\(hour) hours ago"
            } else if (hour >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 hour ago", "An hour ago"))
            }
        }
        
        if let minute = components.minute {
            if (minute >= 2) {
                return "\(minute) minutes ago"
            } else if (minute >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 minute ago", "A minute ago"))
            }
        }
        
        if let second = components.second {
            if (second >= 3) {
                return "\(second) seconds ago"
            }
        }
        
        return "Just now"
    }
    
    private func stringToReturn(flag:Bool, strings: (String, String)) -> String {
        if (flag){
            return strings.0
        } else {
            return strings.1
        }
    }
    
    var asStringWithTime: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: self)
    }
    var ToTimeOnly: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "hh:mm a"
        dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    var ToTimeOnlyEn: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    
    var ToDayOnly: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "dd"
      //  dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.locale =  .current
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    var ToMonthOnly: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "MMM"
  //      dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.locale =  .current
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    var toWeekDay: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "EEEE"
   //     dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.locale =  .current
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    var withMonthName: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "dd MMM yy"
    //    dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.locale =  .current
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    var withMonthNameWithTime: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "dd MMM yy hh:mm a"
    //    dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.locale =  .current
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    var ToDayTextOnly: String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        let timeformat = "ddd"
     //   dateFormatter.locale =  UserManager.isArabic ? Locale(identifier: "ar") : Locale(identifier: "en")
        dateFormatter.locale = .current
        dateFormatter.dateFormat = timeformat
        
        return dateFormatter.string(from: self)
    }
    
    func addDaysToCurrentDate(numofDays: Int) -> Date
    {
        let today = self
        
        return Calendar.current.date(byAdding: .day, value: numofDays, to: today)!
    }
    var YearsBetweenDates: Int
    {
        let selectedDate = self
        let today = Date()
        let cal = Calendar.current
        let components = cal.dateComponents([.year], from: selectedDate, to: today)

        return components.year!
    }
    var trimTime: Date {
        
        
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        //        let components = cal.components([.Day, .Month, .Year], fromDate: self)
        return (cal as NSCalendar).date(bySettingHour: 2, minute: 0, second: 0, of: self, options: NSCalendar.Options())!
    }
    
}

extension UISearchBar
{
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
    
    func setMagnifyingGlassImageTo(color: UIImage)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = color
    }
}
extension UIViewController {
   
    func GoToControllerWithIdentifier(identifier : String)
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func GoToHomeView()  {
     
        let defaults = UserDefaults.standard

        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
              
                let window = UIApplication.shared.delegate!.window
                let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "SplashNavigation")
                window!?.rootViewController = mainViewController
                window!?.makeKeyAndVisible()
                
            }
        }
        else
        {
            
            
              let window = UIApplication.shared.delegate!.window
              let vc = BHGLoginController()
              window!?.rootViewController = vc
              window!?.makeKeyAndVisible()
          
        }
        
    }
    
    func GoToHomeReminderView()  {
        let window = UIApplication.shared.delegate!.window
        let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "DoseReminderVC")
        window!?.rootViewController = mainViewController
        window!?.makeKeyAndVisible()
    }
    
    func GoToOnBoardingView()  {
        let window = UIApplication.shared.delegate!.window
        let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "onBoardingVC")
        window!?.rootViewController = mainViewController
        window!?.makeKeyAndVisible()
    }
    func GoToOnLandingView()  {
        let window = UIApplication.shared.delegate!.window
        let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "LandingVC")
        window!?.rootViewController = mainViewController
        window!?.makeKeyAndVisible()
    }
    
    func GoToDeliveryView()  {
        let window = UIApplication.shared.delegate!.window
        let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "deliveryVC")
        window!?.rootViewController = mainViewController
        window!?.makeKeyAndVisible()
    }
    
    func GoToLoginView(nav : UINavigationController)  {
       let vc = BHGLoginController()
        nav.pushViewController(vc, animated: true)
    }
    func delay(time: Double, closure:@escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+time, execute: {
            closure()
        })
        
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func handleLocalizationChange()
    {
        //        if Languages.currentAppleLanguage() == "ar"
        //        {
        //        loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
        //        }
//        UIView.appearance().semanticContentAttribute = Languages.currentAppleLanguage() == "en" ? .forceLeftToRight : .forceRightToLeft
    }
    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIImageView) && subView.tag < 0 {
                    let toRightArrow = subView as! UIImageView
                    if let _img = toRightArrow.image {
                        toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
                    }
                    
                }
                else if (subView is UIButton) && subView.tag < 0 {
                    let toRightArrow = subView as! UIButton
                    if let _img = toRightArrow.currentImage {
                        toRightArrow.setImage(UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored), for: .normal)
                    }
                    
                }
                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}




extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
}

private var networkActivityCount = 0

extension UIApplication {
    
    func startNetworkActivity() {
        networkActivityCount += 1
        isNetworkActivityIndicatorVisible = true
    }
    
    func stopNetworkActivity() {
        if networkActivityCount < 1 {
            return;
        }
        
        networkActivityCount -= 1
        if networkActivityCount == 0 {
            isNetworkActivityIndicatorVisible = false
        }
    }
    
}
