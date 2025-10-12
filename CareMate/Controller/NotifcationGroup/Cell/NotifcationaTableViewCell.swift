//
//  NotifcationaTableViewCell.swift
//  CareMate
//
//  Created by Khabber on 12/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class NotifcationaTableViewCell: UITableViewCell{
    let colors = ["#006DFF","#FFAA00","#300DBC","#086D5D"]
    let backgrounds = ["#E0EDFF","#FFECD1","#E8DFFF","#B2F2D4"]
    private var selectIndex:Int = 0

    @IBOutlet weak var imgTint: UIImageView!
    @IBOutlet weak var pickerTint: RoundUIView!
    @IBOutlet public weak var labelHeader: UILabel!
    @IBOutlet public weak var labelBody: UILabel!
    @IBOutlet public weak var labeldate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
        
        
    }
    
    func setModel(_ model:notifcationDTO)
    {
        labelBody.text = model.ALERT_BODY
        labelHeader.text = model.ALERT_HEADER
    //labeldate.text = model.TRANSDATE.formateDAte(dateString: model.TRANSDATE, formateString: "HH:mm")
        //labeldate.text = model.TRANSDATE
    }
    
    
    func drawCell(_ item: AlertsResultRow?,index:Int) {
        labelHeader.text = item?.getHeader()
    //    labelBody.attributedText = item?.getBody().stringFromHtml()
        checkURL(item?.getBody() ?? "")
        //labeldate.text = item?.transdate
        imgTint.image = imgTint.image?.withRenderingMode(.alwaysTemplate)
        if index < 4 {
            selectIndex = index
        }else {
            let mod = index % 4
            selectIndex = mod
        }
        if item?.readFlag == "0" {
            imgTint.tintColor = .red
            pickerTint.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            labelHeader.textColor = .red
        }else  {
            imgTint.tintColor = UIColor.fromHex(hex: colors[selectIndex],alpha: 1.0)
            pickerTint.backgroundColor = UIColor.fromHex(hex: backgrounds[selectIndex],alpha: 1.0)
            labelHeader.textColor = UIColor.fromHex(hex: colors[selectIndex],alpha: 1.0)
        }
    }
    
    func checkURL(_ body:String) {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: body, options: [], range: NSRange(location: 0, length: body.utf16.count))
        if matches.isEmpty {
            labelBody.attributedText = body.stringFromHtml()
        }
        for match in matches {
            guard let range = Range(match.range, in: body) else {
                continue
            }
            let url = body[range]
            print(url)
            let urlStr = String(url)
            if urlStr.isEmpty {
                labelBody.attributedText = body.stringFromHtml()
            }else {
                let html = body.stringFromHtml()?.string ?? ""
                let attributedString = NSMutableAttributedString(string: html)
                let redTexts: [String] = [urlStr]
                for redText in redTexts {
                    var searchRange = html.startIndex..<html.endIndex
                    while let range = html.range(of: redText, options: [], range: searchRange) {
                        let nsRange = NSRange(range, in: html)
                        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
                        searchRange = range.upperBound..<html.endIndex
                    }
                }
                
                labelBody.attributedText = attributedString
            }
        }
    }
    
}

extension String {
    func stringFromHtml() -> NSAttributedString? {
        
        let style = NSMutableParagraphStyle()
        style.alignment = UserManager.isArabic ? .right:.left
        
        let htmlData = NSString(string: self).data(using: String.Encoding.unicode.rawValue)
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        let richText = NSMutableAttributedString(string: attributedString.string,attributes: [ NSAttributedString.Key.paragraphStyle: style])
        return richText
    }
    
    func highlightedText(searched: String,mainColor:UIColor) -> NSMutableAttributedString {
        
   //     guard !searched.isEmpty else { return self }
        
        var result = ""
        let parts = self.components(separatedBy: " ")
        let mutableAttributedString = NSMutableAttributedString.init(string: result)
        let range = (self as NSString).range(of: searched)

        for part_index in parts.indices {
            result = (result.isEmpty ? "" : result + " ")
            if searched.contains(parts[part_index].trimmingCharacters(in: .punctuationCharacters)) {
                result = result + parts[part_index]
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)

            }
            else {
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: mainColor, range: range)
            }
        }
        
        return mutableAttributedString
    }
}
