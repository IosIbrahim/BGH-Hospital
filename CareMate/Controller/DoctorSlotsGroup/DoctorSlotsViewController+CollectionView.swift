//
//  DoctorSlotsViewController+CollectionView.swift
//  CareMate
//
//  Created by Khabber on 20/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation

extension DcotorSlotsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func setupcollectionView(){
        let nib = UINib(nibName: "daySlotCollectionViewCell", bundle: nil)
        collectioViewSlotDays?.register(nib, forCellWithReuseIdentifier: "daySlotCollectionViewCell")
        collectioViewSlotDays.delegate = self
        collectioViewSlotDays.dataSource = self
        
        let nib1 = UINib(nibName: "SlotTimeSlotCollectionViewCell", bundle: nil)
        collectioViewSlotTimes?.register(nib1, forCellWithReuseIdentifier: "SlotTimeSlotCollectionViewCell")
        collectioViewSlotTimes.delegate = self
        collectioViewSlotTimes.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectioViewSlotDays{
            return  datesInMonthList.count
        }
        else{
            return  SlotArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectioViewSlotDays{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daySlotCollectionViewCell", for: indexPath) as! daySlotCollectionViewCell
            let date = datesInMonthList[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
          //  if UserManager.isArabic{
            dateFormatter.locale = .current
//            }
//            else{
//                dateFormatter.locale = Locale(identifier: "en")
//            }
            let dayInWeek = dateFormatter.string(from: date)
            cell.labelDayText.text = dayInWeek
            
            let dateFormatterYYYMMDD = DateFormatter()
            dateFormatterYYYMMDD.dateFormat = "yyyy-MM-dd"
          //  dateFormatterYYYMMDD.locale = Locale(identifier: "en_US_POSIX")
            dateFormatterYYYMMDD.locale = .current

            let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: date)
            let dayInYYYMMDDCuurentDate = dateFormatterYYYMMDD.string(from: Date())

            cell.labelDayText.text = dayInWeek
            cell.labelDaynumber.text = "\(date.ToDayOnly)"
            cell.mainView.makeShadow(color: .black, alpha: 0.25, radius: 3)
            
            
            if dayInYYYMMDDDateInCell == dayInYYYMMDDCuurentDate{
                    cell.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.231372549, blue: 0.4431372549, alpha: 1)
                    cell.labelDayText.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            }
            else{
                if indexPath.row == selecteIndexPAth{
                    cell.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.7239288688, blue: 0.8250393271, alpha: 1)
                    cell.labelDayText.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                }
                else{
                    cell.mainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell.labelDayText.textColor = #colorLiteral(red: 0.4872305393, green: 0.4918760657, blue: 0.5142763853, alpha: 1)
                }
            }
        
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotTimeSlotCollectionViewCell", for: indexPath) as! SlotTimeSlotCollectionViewCell
            cell.configCell(slot: SlotArr[indexPath.row])
            if indexPath.row == selectedIndexSlot{
                cell.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.7239288688, blue: 0.8250393271, alpha: 1)
                cell.labelDayText.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

            }
            else{
                cell.mainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.labelDayText.textColor = #colorLiteral(red: 0.4872305393, green: 0.4918760657, blue: 0.5142763853, alpha: 1)
            }
            return cell

        }
        
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectioViewSlotDays{
            self.SlotArr.removeAll()
            let dateFormatterYYYMMDD = DateFormatter()
            dateFormatterYYYMMDD.dateFormat = "dd/MM/yyyy"
            let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: datesInMonthList[indexPath.row])
            selecteDate = dayInYYYMMDDDateInCell
            selecteIndexPAth = indexPath.row
            self.collectioViewSlotDays.reloadData()
            loadSlots()
        }
        else{
            selectedIndexSlot = indexPath.row
            collectioViewSlotTimes.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectioViewSlotDays{
            var size = CGSize.zero
            let screenSize = UIScreen.main.bounds
            var screenWidth = screenSize.width
            screenWidth = screenWidth - 50
            let cellSize = screenWidth / 6
            size.width = cellSize
            size.height =  65
            return size
        }
        else{
            let screenSize = UIScreen.main.bounds
            var screenWidth = screenSize.width
            screenWidth = screenWidth - 100
            let cellSize = screenWidth / 4
            var size = CGSize.zero
            size.width = cellSize
            size.height =  46
            return size
        }
      
    }
    
    
}
