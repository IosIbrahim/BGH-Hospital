//
//  ReservCell.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/19/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit

class ReservCell: UICollectionViewCell {
  
  @IBOutlet weak var timeSlotLabel: UILabel!
  
  @IBOutlet weak var slotTimeView: UIView!
  var dateString :String = ""
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.slotTimeView.layer.cornerRadius = 10
    
    
  }
  
    func configCell(slot: Slot)
    {
        var slot = String ( describing: slot.id )
        
        let timeOnly = String(slot.characters.suffix(8))
        
        
        self.timeSlotLabel.text = timeOnly
    }
  func configCell ( slot :TimeSlots) {
//     var slot = String ( describing: slot.slotsarray[0].id )
//
//           dateString = slot
//
//            let dateFormatter = DateFormatter()
//
//
//            dateFormatter.dateFormat = "dd/mm/yyyy hh:mm:ss"
//            dateFormatter.locale = Locale.init(identifier: "en_GB")
//
//            let dateObj = dateFormatter.date(from: dateString)
//
//            dateFormatter.dateFormat = "hh:mm"
//
//    var slotTime = dateFormatter.string(from: dateObj!)
//
//    self.timeSlotLabel.text = slotTime
//
//            print(slotTime)



   
  
    
    
    
    // i will  using  CocoaPods  SwiftDate 
    
    
    // i Want show all element  in  this  array  Not  First  elemnt
//    for  i in  0...3  {
//
//        var slot = String ( describing: slot.slotsarray[i].id )
//        self.timeSlotLabel.text = slot
//     print(slot)
//    }
   
   
   
    
   
    
    
    
      var slot = String ( describing: slot.slotsarray?.SINGLE_HOUR_SLOTS_ROW?[0].id )
   
    let timeOnly = String(slot.characters.suffix(8))
    

    self.timeSlotLabel.text = timeOnly
  
    print (timeOnly)

    
    
  }
}

