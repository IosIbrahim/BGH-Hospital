//
//  extensions.swift
//  careMatePatient
//
//  Created by khabeer on 4/1/20.
//  Copyright © 2020 khabeer. All rights reserved.
//

import Foundation

import UIKit
@IBDesignable
class RoundUIView: UIView {
    
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadow: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
extension UIView
{
    
    func setGradient(view:UIView,firstColor:UIColor,secondeColor:UIColor,gradient:CAGradientLayer)   {
        gradient.frame = gradient.bounds
            view.layoutIfNeeded()
            view.backgroundColor = nil
            gradient.masksToBounds = false
            gradient.frame = view.bounds
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.colors = [firstColor.cgColor,secondeColor.cgColor]
            gradient.cornerRadius = 20
    }
    
    func setShadowLight()  {
        
        self.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
        
    }
    
}

extension String
{
    
//    Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
//    09/12/2018                        --> MM/dd/yyyy
//    09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
//    Sep 12, 2:11 PM                   --> MMM d, h:mm a
//    September 2018                    --> MMMM yyyy
//    Sep 12, 2018                      --> MMM d, yyyy
//    Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
//    2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
//    12.09.18                          --> dd.MM.yy
//    10:41:02.112                      --> HH:mm:ss.SSS
    
    
    func formateDAte(dateString:String?,formateString:String, localEn: Bool = false)  -> String {
        if let dateConstant = dateString
         {


            
                         let dateFormatterGet = DateFormatter()
                         dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"

                         let stringDateMily = dateFormatterGet.date(from: dateConstant )
                         if let BigDateConstan = stringDateMily
                         {
                             let formattedDate1 = dateFormatterGet.string(from: BigDateConstan)

                             dateFormatterGet.dateFormat = formateString

                             let year_month_day = dateFormatterGet.string(from: BigDateConstan)
//                            self.dayText.text = year_month_day
                            
                            
                            
                            dateFormatterGet.dateFormat = formateString
                             if localEn {
                                 dateFormatterGet.locale = NSLocale(localeIdentifier: "En") as Locale
                             } else {
                                 if UserManager.isArabic
                                 {
                                     dateFormatterGet.locale = NSLocale(localeIdentifier: "ar") as Locale

                                 }
                                 else
                                 {
                                     dateFormatterGet.locale = NSLocale(localeIdentifier: "En") as Locale

                                 }
                             }
                            let dayNumber = dateFormatterGet.string(from: BigDateConstan)


//                            self.datyNumnber.text = dayNumber
                            
                            return dayNumber
                            dateFormatterGet.dateFormat = formateString

                            let monthtext = dateFormatterGet.string(from: BigDateConstan)


//                            self.monthText.text = monthtext
                         }
                         else{
          

                            
                            let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"
                            
                            let stringDateWithoutMily = dateFormatterGet.date(from: dateConstant)
                            
                            dateFormatterGet.dateFormat = formateString
                            
                            let formattedDate1 = dateFormatterGet.string(from: stringDateWithoutMily ?? Date())
                            
//                            02/06/2021 13:35:32
                            dateFormatterGet.dateFormat = formateString
                            //                            self.dayText.text = formattedDate1
                            
                            
                            dateFormatterGet.dateFormat = formateString
                            
                             let dayNumber = dateFormatterGet.string(from: stringDateWithoutMily ?? Date())
                            
                            
                            //                           self.datyNumnber.text = dayNumber
                            
                            
                            dateFormatterGet.dateFormat = formateString
                            
                            let monthText = dateFormatterGet.string(from: stringDateWithoutMily ?? Date())
                            
                            
                            return formattedDate1

                         }
                         
         }
        
        return ""
    }
}
