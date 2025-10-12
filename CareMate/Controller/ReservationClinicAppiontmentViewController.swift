//
//  ReservationClinicAppiontmentViewController.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/19/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit

class ReservationClinicAppiontmentViewController: BaseViewController {
  
  var ReservArr: [TimeSlots] = []
  var dateID: TimeSlots?
  var SlotArr:[Slot] = []
  var clincID: String?
  var branchID: String?
  var docID: String?
  var clinicNameL: String?
  var docNameL: String?
  var selectedIndex: IndexPath?

  @IBOutlet weak var bookAppointtment: UIButton!
  @IBOutlet weak var clinicName: UILabel!
  @IBOutlet weak var informationDoctorView: UIView!
  @IBOutlet weak var doctorName: UILabel!
  @IBOutlet weak var dayName: UILabel!
  @IBOutlet weak var numberDatDay: UILabel!
  @IBOutlet weak var monthDateName: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let nib = UINib(nibName: "ReservCell", bundle: nil)

    self.collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    self.informationDoctorView.layer.cornerRadius = 10
    self.bookAppointtment.layer.cornerRadius = 20
    self.clinicName.text = clinicNameL
    self.doctorName.text = docNameL
//      setupTabBar.instance.setuptabBar(vc: self)

    TimeSlots.getSlotsTimes(branchID: branchID!, clincID: clincID!, docID: docID!, date: ""){
        slots,dat, slotsDay
      in
      self.ReservArr = slots!
      self.collectionView.reloadData()
    }
  }
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard

        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
              
                
                self.navigationController?.navigationBar.isHidden = false

              
               
            }
        }
        else
        {
            self.navigationController?.navigationBar.isHidden = true

        }
        
    }

}

extension ReservationClinicAppiontmentViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ReservArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ReservCell
    cell.configCell(slot: ReservArr[indexPath.row])

    if let selectedIndex = selectedIndex,
      selectedIndex == indexPath {
      cell.slotTimeView.backgroundColor = UIColor.orange
    }
    else {
      cell.slotTimeView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.5529411765, blue: 0.831372549, alpha: 1)
    }
    return cell
  }

}

extension ReservationClinicAppiontmentViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath
    self.collectionView.reloadData()
  }

}

extension ReservationClinicAppiontmentViewController: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let orientation = UIDevice.current.orientation
    let numberOfHorizontalCells: CGFloat = orientation.isPortrait || orientation.isFlat ? 3 : 4
    let numberOfVerticalCells: CGFloat = orientation.isPortrait || orientation.isFlat ? 6: 4

    return CGSize(width: self.collectionView.bounds.width / numberOfHorizontalCells - 10,
                  height: self.collectionView.bounds.height / numberOfVerticalCells - 10)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets (top: 5, left: 5, bottom: 0, right: 5)
  }

}

extension ReservationClinicAppiontmentViewController {

  @IBAction func backBtn(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func bookAppointMentReserv(_ sender: Any) {
    
  }

}

extension Date {
  func dayOfWeek() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    return dateFormatter.string(from: self).capitalized
  }
}

// Month Name
extension Date {
  func monthName() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM"
    return dateFormatter.string(from: self).capitalized
  }
}
