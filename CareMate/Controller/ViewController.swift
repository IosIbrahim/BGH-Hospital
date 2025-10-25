//
//  BaseViewController.swift
//  Youmeda
//
//  Created by Mohamed on 1/9/21.
//

import UIKit
import SCLAlertView
import MZFormSheetController

class MyNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
  }

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    
    
    var isNotifcation = true
    var isLanguage = true
    var viewNoDAtaIsHidden = true
    var Title = ""
    let labelNoData = UILabel()

    let nc = NotificationCenter.default
    let viewNoDAta = UIView()
    
    let labelTitle1 = UILabel()
    let imageView = UIImageView()
    let viewBack = UIView()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewBack.backgroundColor = .red
        nc.addObserver(self, selector: #selector(nodataFound), name: Notification.Name("nodataFound"), object: nil)
        nc.addObserver(self, selector: #selector(dataFound), name: Notification.Name("dataFound"), object: nil)
        
        nc.addObserver(self, selector: #selector(changeTile), name: Notification.Name("changeTile"), object: nil)
        
        nc.addObserver(self, selector: #selector(changeErrorMeesage), name: Notification.Name("changeErrorTitle"), object: nil)
        nc.addObserver(self, selector: #selector(hideBack), name: Notification.Name("hideBack"), object: nil)
        nc.addObserver(self, selector: #selector(showBack), name: Notification.Name("showBack"), object: nil)

        self.navigationController?.navigationBar.isHidden = true
//        initBackGround()
        self.view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        if self is DoseReminderHomeViewController || self is OperationViewController{
                    initNotDataShape(200)
                } else {
                    initNotDataShape()
                }


    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("dataFound"), object: nil)
    }
    
    func setErrorLabelText(error: String) {
        labelNoData.text = error
    }
    
//    func initNotDataShape(_ topConstant: CGFloat = 30) {
//        viewNoDAta.isHidden = true
//        view.addSubview(viewNoDAta)
//
//        viewNoDAta.backgroundColor = .clear
//        viewNoDAta.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            viewNoDAta.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant),
//            viewNoDAta.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
//            viewNoDAta.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            viewNoDAta.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            viewNoDAta.heightAnchor.constraint(equalToConstant: 250)
//        ])
//
//        viewNoDAta.addSubview(imageView)
//        viewNoDAta.addSubview(labelNoData)
//
//        imageView.image = UIImage(named: "BHG-NoData")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageView.centerXAnchor.constraint(equalTo: viewNoDAta.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: viewNoDAta.centerYAnchor, constant: -40),
//            imageView.heightAnchor.constraint(equalToConstant: 250),
//            imageView.widthAnchor.constraint(equalToConstant: 250)
//        ])
//
//        labelNoData.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            labelNoData.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
//            labelNoData.leadingAnchor.constraint(equalTo: viewNoDAta.leadingAnchor, constant: 16),
//            labelNoData.trailingAnchor.constraint(equalTo: viewNoDAta.trailingAnchor, constant: -16)
//        ])
//        labelNoData.textAlignment = .center
//        labelNoData.numberOfLines = 0
//
//        let mainText = UserManager.isArabic ? "لا يوجد اي بيانات\n" : "There Is No Data\n"
//        let subText = UserManager.isArabic ? "عذراً لايوجد بيانات لعرضها" : "Sorry, no data available"
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        paragraphStyle.lineSpacing = 6
//
//        let attributed = NSMutableAttributedString(
//            string: mainText,
//            attributes: [
//                .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
//                .foregroundColor: UIColor.black,
//                .paragraphStyle: paragraphStyle
//            ]
//        )
//
//        attributed.append(NSAttributedString(
//            string: subText,
//            attributes: [
//                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
//                .foregroundColor: UIColor.darkGray,
//                .paragraphStyle: paragraphStyle
//            ]
//        ))
//
//        labelNoData.attributedText = attributed
//    }

    func initNotDataShape(_ topConstant: CGFloat = 30) {
        viewNoDAta.isHidden = true
        view.addSubview(viewNoDAta)

        viewNoDAta.backgroundColor = .clear
        viewNoDAta.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNoDAta.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant),
            viewNoDAta.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            viewNoDAta.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewNoDAta.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            viewNoDAta.heightAnchor.constraint(equalToConstant: 250)
        ])

        viewNoDAta.addSubview(imageView)
        viewNoDAta.addSubview(labelNoData)

        imageView.image = UIImage(named: "BHG-NoData")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: viewNoDAta.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: viewNoDAta.centerYAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 250)
        ])

        labelNoData.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelNoData.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            labelNoData.leadingAnchor.constraint(equalTo: viewNoDAta.leadingAnchor, constant: 16),
            labelNoData.trailingAnchor.constraint(equalTo: viewNoDAta.trailingAnchor, constant: -16)
        ])
        labelNoData.textAlignment = .center
        labelNoData.numberOfLines = 0

        let mainText = UserManager.isArabic ? "لا يوجد اي بيانات\n" : "There Is No Data\n"
        let subText = UserManager.isArabic ? "عذراً لايوجد بيانات لعرضها" : "Sorry, no data available"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 6

        let attributed = NSMutableAttributedString(
            string: mainText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
                .foregroundColor: UIColor.fromHex(hex: "#2E4E8E", alpha: 1), // الأزرق المطلوب
                .paragraphStyle: paragraphStyle
            ]
        )

        attributed.append(NSAttributedString(
            string: subText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.darkGray,
                .paragraphStyle: paragraphStyle
            ]
        ))

        labelNoData.attributedText = attributed
    }



    
    func initBackGround(){
        let imageBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageBackground.contentMode = .scaleAspectFill
        imageBackground.image = UIImage(named: "Image 1")
        view.insertSubview(imageBackground, at: 0)
    }
    
    func initHeader(isNotifcation:Bool = false , isLanguage:Bool = false,title:String = "",hideBack: Bool = false){
        self.isNotifcation = isNotifcation
        self.isLanguage = isLanguage
        let viewHeader = UIView()
        viewHeader.backgroundColor = .clear
        view.insertSubview(viewHeader, at: 2)
        
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        viewHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        viewHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        viewHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        viewHeader.heightAnchor.constraint(equalToConstant: 60).isActive = true
        if !hideBack{
            createBackBtn(viewHeader)
            
        }
        
        if isNotifcation {
            createNotifcationBtn(viewHeader)
        }
        
        if isLanguage{
            createLanguageBtn(viewHeader)
        }
        createTitle(viewHeader, title: title)
    }
    
    @objc func dataFound(){
        viewNoDAta.isHidden = true
    }
 
    @objc func nodataFound(){
        viewNoDAta.isHidden = false
    }
    
    @objc func changeTile(){
        labelTitle1.text = Title
    }
    
    @objc func hideBack(){
        viewBack.isHidden = true
       
    }
    @objc func showBack(){
        viewBack.isHidden = false
       
    }
    
    
    @objc func changeErrorMeesage(){
        labelNoData.numberOfLines = 0
        labelNoData.text = UserManager.isArabic ? " لا يوجد اي جدوله لم تتم عمليه الجدوله لاي دواء من الادويه" :"There is no scheduling.No medication has been scheduled"
        
        labelNoData.setSpecificAttributes(texts: UserManager.isArabic ? ["لا يوجد اي جدولة\n\n", "لم تتم عملية الجدولة لاي دواء من الادوية"] : ["There is no scheduling\n\n", "No medication has been scheduled"], fonts: [UIFont(name: "Tajawal-Bold", size: 18)!, UIFont(name: "Tajawal-Bold", size: 15)!], colors: [.fromHex(hex: "#2E4E8E", alpha: 1), .fromHex(hex: "#969BA5", alpha: 1)])
        imageView.image = UIImage(named: "BHG-NOSchedule")
    }
    
    
    func createTitle(_ viewHeader: UIView, title: String) {
        labelTitle1.text = title
        labelTitle1.textColor = .black
        labelTitle1.textAlignment = .center
        labelTitle1.numberOfLines = 2
//        labelTitle1.font = labelTitle1.font.withSize(14)
        viewHeader.addSubview(labelTitle1)
        labelTitle1.translatesAutoresizingMaskIntoConstraints = false
        labelTitle1.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor).isActive = true
        labelTitle1.centerXAnchor.constraint(equalTo: viewHeader.centerXAnchor).isActive = true
        labelTitle1.widthAnchor.constraint(equalTo: viewHeader.widthAnchor, multiplier: 0.55).isActive = true
        
        labelTitle1.font = UIFont(name: "Tajawal-Bold", size: 16)

    }
    
    func createBackBtn(_ viewHeader: UIView) {
        viewBack.backgroundColor = .clear
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        viewHeader.addSubview(viewBack)
        
        viewBack.translatesAutoresizingMaskIntoConstraints = false
        viewBack.topAnchor.constraint(equalTo: viewHeader.topAnchor).isActive = true
        viewBack.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor).isActive = true
        viewBack.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor).isActive = true
        viewBack.widthAnchor.constraint(equalTo: viewBack.heightAnchor).isActive = true
        
        let imageViewBack = UIImageView()

//        if UserManager.isArabic
//        {
//            imageViewBack.image = #imageLiteral(resourceName: "right-arrow-3")
//
//        }
//        else
//        {
//            imageViewBack.image = #imageLiteral(resourceName: "left-arrow")
//
//        }
        imageViewBack.image = #imageLiteral(resourceName: "left-arrow").imageFlippedForRightToLeftLayoutDirection()
        imageViewBack.contentMode = .scaleAspectFit
        viewBack.addSubview(imageViewBack)
        
        imageViewBack.translatesAutoresizingMaskIntoConstraints = false
        imageViewBack.leadingAnchor.constraint(equalTo: viewBack.leadingAnchor, constant: 8).isActive = true
        imageViewBack.heightAnchor.constraint(equalTo: viewBack.heightAnchor).isActive = true
        imageViewBack.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func createLanguageBtn(_ viewHeader: UIView) {
        let viewBack = UIView()
        viewBack.backgroundColor = .clear
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLanguage)))
        viewHeader.addSubview(viewBack)
        
        viewBack.translatesAutoresizingMaskIntoConstraints = false
        viewBack.topAnchor.constraint(equalTo: viewHeader.topAnchor).isActive = true
        viewBack.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor,constant: -40).isActive = true
        viewBack.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor).isActive = true
        viewBack.widthAnchor.constraint(equalTo: viewBack.heightAnchor).isActive = true
        
        let imageViewBack = UIImageView()
        imageViewBack.image = #imageLiteral(resourceName: "world")
        imageViewBack.contentMode = .scaleAspectFit
        viewBack.addSubview(imageViewBack)
        
        imageViewBack.translatesAutoresizingMaskIntoConstraints = false
        imageViewBack.leadingAnchor.constraint(equalTo: viewBack.leadingAnchor, constant: 8).isActive = true
        imageViewBack.centerYAnchor.constraint(equalTo: viewBack.centerYAnchor).isActive = true
        imageViewBack.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func createNotifcationWithBadgeBtn(_ viewHeader: UIView,badge:String) {
        let viewBack = UIView()
        viewBack.backgroundColor = .clear
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openNotifcation)))
        viewHeader.addSubview(viewBack)
        
        viewBack.translatesAutoresizingMaskIntoConstraints = false
        viewBack.topAnchor.constraint(equalTo: viewHeader.topAnchor).isActive = true
        viewBack.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor).isActive = true
        viewBack.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor).isActive = true
        viewBack.widthAnchor.constraint(equalTo: viewBack.heightAnchor).isActive = true
        
        if Utilities.sharedInstance.getPatientId() != "" {
            let imageViewBack = UIImageView()
            imageViewBack.image = UIImage(named: "notification 1")
            imageViewBack.contentMode = .scaleAspectFit
            viewBack.addSubview(imageViewBack)
            
            imageViewBack.translatesAutoresizingMaskIntoConstraints = false
            imageViewBack.leadingAnchor.constraint(equalTo: viewBack.leadingAnchor, constant: 1).isActive = true
            imageViewBack.centerYAnchor.constraint(equalTo: viewBack.centerYAnchor).isActive = true
            imageViewBack.widthAnchor.constraint(equalToConstant: 35).isActive = true
            
        }
    }
    
    func createNotifcationBtn(_ viewHeader: UIView) {
        let viewBack = UIView()
        viewBack.backgroundColor = .clear
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openNotifcation)))
        viewHeader.addSubview(viewBack)
        
        viewBack.translatesAutoresizingMaskIntoConstraints = false
        viewBack.topAnchor.constraint(equalTo: viewHeader.topAnchor).isActive = true
        viewBack.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor).isActive = true
        viewBack.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor).isActive = true
        viewBack.widthAnchor.constraint(equalTo: viewBack.heightAnchor).isActive = true
        if Utilities.sharedInstance.getPatientId() != "" {
            let imageViewBack = UIImageView()


                imageViewBack.image = #imageLiteral(resourceName: "notification 1")

            imageViewBack.contentMode = .scaleAspectFit
            viewBack.addSubview(imageViewBack)
            
            imageViewBack.translatesAutoresizingMaskIntoConstraints = false
            imageViewBack.leadingAnchor.constraint(equalTo: viewBack.leadingAnchor, constant: 8).isActive = true
            imageViewBack.centerYAnchor.constraint(equalTo: viewBack.centerYAnchor).isActive = true
            imageViewBack.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
    }
    
    @objc func openNotifcation() {
       
        let vc = NotifcationsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func openLanguage() {
       
        let vc = LanguageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func back() {
        UIView.setAnimationsEnabled(true)
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        }else {
            navigationController?.dismiss(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.831372549, alpha: 1)
//        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.433473289, blue: 0.8313797116, alpha: 1)
//        navigationController?.navigationBar.tintColor = .white
//
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        self.navigationController?.navigationBar.backItem?.title = ""
//        setTabBar()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        print("Class name: \(String(describing: self))")
    }
    
    func setTabBar(){
        
        let button = UIButton()
        button.setImage(UIImage(named: "world.png"), for: UIControlState.normal)
        button.isHidden = !isLanguage

        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        if UserManager.language == "ar"
//        {
////            button.setTitle(" لغه", for: .normal)
//
//        }
//        else
//        {
////            button.setTitle("Language", for: .normal)
//
//        }
        button.addTarget(  self, action:#selector(language), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        let barButton = UIBarButtonItem(customView: button)
        let buttonNotifcation = UIButton()
        buttonNotifcation.isHidden = !isNotifcation

        buttonNotifcation.setImage(UIImage(named: "bell.png"), for: UIControlState.normal)
        buttonNotifcation.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonNotifcation.addTarget(self, action:#selector(Notifcation), for: UIControlEvents.touchUpInside)
        buttonNotifcation.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        let barButtonNotifcation = UIBarButtonItem(customView: buttonNotifcation)
        self.navigationItem.rightBarButtonItems = [barButton ,barButtonNotifcation]
     

        
       
    }
    
    @objc func language()
     {
         self.navigationController?.pushViewController(LanguageViewController(), animated: true)

     }
//    @objc func back()
//     {
//         self.navigationController?.popViewController(animated: true)
//     }
     @objc func Notifcation()
      {
        let vc =  NotifcationsViewController()
          AppPopUpHandler.instance.openVCPop(vc, height: 600)
      }
    
    func settitle(_ titleAr:String, _ titleEn:String)
    {
        
        if UserManager.isArabic
        {
            title = titleAr
        }
        else
        {
            title = titleEn

        }
    }
    
}


extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

var viewLoading = UIView()
var appLoading = false

func showIndicator() {
    if appLoading { return }
    appLoading = true
    
   // guard let vc = ((UIApplication.shared.delegate as! AppDelegate).window!.rootViewController as? UINavigationController)?.viewControllers.last else { return }
    guard let vc = rootNavigation.viewControllers.last else { return }
    viewLoading = UIView(frame: vc.view.bounds)
    viewLoading.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    
    // ✅ خليها ما تمنعش التاتش
    viewLoading.isUserInteractionEnabled = false
    
    vc.view.addSubview(viewLoading)
    
    let imageView = UIImageView(image: UIImage(named: "BHG-Loader"))
    viewLoading.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        imageView.centerXAnchor.constraint(equalTo: viewLoading.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: viewLoading.centerYAnchor),
        imageView.widthAnchor.constraint(equalToConstant: 100),
        imageView.heightAnchor.constraint(equalToConstant: 100)
    ])
    
    // Zoom In/Out Animation
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.fromValue = 1.0
    animation.toValue = 1.2
    animation.duration = 0.6
    animation.autoreverses = true
    animation.repeatCount = .infinity
    imageView.layer.add(animation, forKey: "zoomInOut")
}




func hideIndicator() {
    appLoading = false
    viewLoading.removeFromSuperview()
}
