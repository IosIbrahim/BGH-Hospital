//
//  DoctorSlotsViewController+CollectionView.swift
//  CareMate
//
//  Created by Khabber on 20/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation

extension DoseReminderHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func setupcollectionView(){
        let nib = UINib(nibName: "DoseReminderCalenderCollectionViewCell", bundle: nil)
        collectioViewSlotDays?.register(nib, forCellWithReuseIdentifier: "DoseReminderCalenderCollectionViewCell")
        collectioViewSlotDays.delegate = self
        collectioViewSlotDays.dataSource = self
        
        doseReminderTableView.register("DoseTimesTableViewCell")

        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return  datesInMonthList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoseReminderCalenderCollectionViewCell", for: indexPath) as! DoseReminderCalenderCollectionViewCell
            let date = datesInMonthList[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            if UserManager.isArabic{
                dateFormatter.locale = Locale(identifier: "ar")
            }
            else{
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            }
            let dayInWeek = dateFormatter.string(from: date)
            cell.labelDayText.text = dayInWeek
            
            let dateFormatterYYYMMDD = DateFormatter()
            dateFormatterYYYMMDD.dateFormat = "yyyy-MM-dd"
            dateFormatterYYYMMDD.locale = Locale(identifier: "en_US_POSIX")

            let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: date)
            let dayInYYYMMDDCuurentDate = dateFormatterYYYMMDD.string(from: Date())

            cell.labelDayText.text = dayInWeek
            //cell.labelDaynumber.text = "\(indexPath.row + 1)"
            let dayNumber = Calendar.current.component(.day, from: date)
            cell.labelDaynumber.text = "\(dayNumber)"
            if dayInYYYMMDDDateInCell == dayInYYYMMDDCuurentDate{
                    cell.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.231372549, blue: 0.4431372549, alpha: 1)
                    cell.labelDayText.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) 
            }
            else{
                if indexPath.row == selecteIndexPAth{
                    cell.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.6705882353, blue: 0.7843137255, alpha: 1)
                    cell.labelDayText.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                }
                else{
                    cell.mainView.backgroundColor = #colorLiteral(red: 0.9450153708, green: 0.945151031, blue: 0.9449856877, alpha: 1)
                    cell.labelDayText.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
        
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectioViewSlotDays {
                let selectedDate = datesInMonthList[indexPath.row]
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let tappedDay = calendar.startOfDay(for: selectedDate)

                // ❌ Prevent selection if the date is in the past
                if tappedDay < today {
                    return
                }

                let dateFormatterYYYMMDD = DateFormatter()
                dateFormatterYYYMMDD.dateFormat = "dd/MM/yyyy"
                dateFormatterYYYMMDD.locale = Locale(identifier: "en")

                let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: selectedDate)
                selecteDate = dayInYYYMMDDDateInCell
                selecteIndexPAth = indexPath.row

                self.filterByDate(date: selectedDate)
                self.collectioViewSlotDays.reloadData()

                NotificationCenter.default.post(name: Notification.Name("changeErrorTitle"), object: nil)
            }
//        if collectionView == collectioViewSlotDays{
//            let dateFormatterYYYMMDD = DateFormatter()
//            dateFormatterYYYMMDD.dateFormat = "dd/MM/yyyy"
//            if UserManager.isArabic{
//                dateFormatterYYYMMDD.locale = NSLocale(localeIdentifier: "En") as Locale
//
//            }
//            else
//            {
//                dateFormatterYYYMMDD.locale = NSLocale(localeIdentifier: "En") as Locale
//
//            }
//            let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: datesInMonthList[indexPath.row])
//            selecteDate = dayInYYYMMDDDateInCell
//            selecteIndexPAth = indexPath.row
//            self.filterByDate(date:datesInMonthList[indexPath.row])
//            self.collectioViewSlotDays.reloadData()
//            let nc = NotificationCenter.default
//
//            nc.post(name: Notification.Name("changeErrorTitle"), object: nil)
//
//        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            var size = CGSize.zero
            let screenSize = UIScreen.main.bounds
            var screenWidth = screenSize.width
            screenWidth = screenWidth - 50
            let cellSize = screenWidth / 5
            size.width = cellSize
            size.height =  100
            return size
    }
    
    
}

