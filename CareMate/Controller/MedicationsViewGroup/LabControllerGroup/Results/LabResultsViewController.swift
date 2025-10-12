//
//  LabResultsViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 08/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class LabResultsViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let arrayResults: [LabResultModel]
    
    init(arrayResults: [LabResultModel]) {
        self.arrayResults = arrayResults
        super.init(nibName: "LabResultsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الملفات" : "Files", hideBack: false)
        initCollectionView()
    }
}

extension LabResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func initCollectionView() {
        let nib = UINib(nibName: "LabResultCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "LabResultCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabResultCollectionViewCell", for: indexPath) as! LabResultCollectionViewCell
        cell.setData(model: arrayResults[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = arrayResults[indexPath.row]
        if model.BLOB_TYPE == "1" {
            let url = "\(Constants.APIProvider.IMAGE_BASE2)/\(model.BLOB_PATH)"
            let vc = LabResultController()
            vc.clinicsServiceReportPDFUrl = url
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let url = "\(Constants.APIProvider.IMAGE_BASE2)/\(model.BLOB_PATH)"
            self.navigationController?.pushViewController(WebViewViewController(url), animated: true)
        }
    }
}
