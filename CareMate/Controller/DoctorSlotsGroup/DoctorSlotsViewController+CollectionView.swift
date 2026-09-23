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
            dateFormatter.locale = .current
            let dayInWeek = dateFormatter.string(from: date)
            cell.labelDayText.text = dayInWeek
            
            let dateFormatterYYYMMDD = DateFormatter()
            dateFormatterYYYMMDD.dateFormat = "yyyy-MM-dd"
            dateFormatterYYYMMDD.locale = .current

            let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: date)
            let dayInYYYMMDDCuurentDate = dateFormatterYYYMMDD.string(from: Date())

            cell.labelDayText.text = dayInWeek
            cell.labelDaynumber.text = "\(date.ToDayOnly)"
            cell.mainView.makeShadow(color: .black, alpha: 0.25, radius: 3)
            
            
            if dayInYYYMMDDDateInCell == dayInYYYMMDDCuurentDate{
                cell.mainView.backgroundColor = UIColor.fromHex(hex: "#003B71", alpha: 1.0)
                cell.labelDayText.textColor = .white
            }
            else{
                if indexPath.row == selecteIndexPAth{
                    cell.mainView.backgroundColor = UIColor.fromHex(hex: "#003B71", alpha: 1.0)
                    cell.labelDayText.textColor = .white
                }
                else{
                    cell.mainView.backgroundColor = .white
                    cell.labelDayText.textColor = UIColor.fromHex(hex: "#1B2A3A", alpha: 1.0)
                }
            }
            cell.labelDaynumber.textAlignment = .center
        
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotTimeSlotCollectionViewCell", for: indexPath) as! SlotTimeSlotCollectionViewCell
            cell.configCell(slot: SlotArr[indexPath.row])
            if indexPath.row == selectedIndexSlot{
                cell.mainView.backgroundColor = UIColor.fromHex(hex: "#00ABC8", alpha: 1.0)
                cell.labelDayText.textColor = .white

            }
            else{
                cell.mainView.backgroundColor = .white
                cell.labelDayText.textColor = UIColor.fromHex(hex: "#1B2A3A", alpha: 1.0)
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
            let cellSize = screenWidth * 0.20
            size.width = cellSize
            size.height =  90
            return size
        }
        else{
            let screenSize = UIScreen.main.bounds
            var screenWidth = screenSize.width
            let cellSize = screenWidth * 0.21
            var size = CGSize.zero
            size.width = cellSize
            size.height =  65
            return size
        }
      
    }
    
    
}
