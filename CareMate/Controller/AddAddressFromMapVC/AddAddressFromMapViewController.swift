//
//  AddAddressFromMapViewController.swift
//  careMatePatient
//
//  Created by Mohamed on 7/21/20.
//  Copyright © 2020 khabeer. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol popFromMap {
    func popFromMapFRom(lat:Double,Lng:Double,Street:String)
}

class AddAddressFromMapViewController: BaseViewController {

    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var viewSearch: UIView!
    
    let locationManager = CLLocationManager()
    var lat: Double = 0
    var lng: Double = 0
    var locationCame = false
    
    var delegate:popFromMap?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewSearch()
        initLocation()
        initMap()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "appDidBecomeActive"), object: nil, queue: nil) { [weak self] notification in
            self?.initLocation()
        }
    }
    
   
    
    func initViewSearch(){
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تعديل العنوان" : "Edit Location", hideBack: false)
        viewSearch.layer.cornerRadius = 20
        viewSearch.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSearch)))
    }
    
    @objc func openSearch(){
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.accessibilityLanguage = "ar" 
        filter.type = .establishment  //suitable filter type
        filter.country = "EG"  //appropriate country code
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func initLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 14.0, *) {
                switch locationManager.authorizationStatus {
                case .notDetermined:
                    print("notDetermined")
                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.startUpdatingLocation()
                    break
                case .authorizedAlways, .authorizedWhenInUse:
                    print("authorizedAlways")
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.startUpdatingLocation()
                    break
                case .restricted:
                    print("restricted")
//                    AppPopUpHandler.instance.initHintPopUp(container: self, message: "openLocation".localize, type: "app_location")
                    break
                case .denied:
                    print("denied")
//                    AppPopUpHandler.instance.initHintPopUp(container: self, message: "openLocation".localize, type: "app_location")
                    break
                default:
                    print("default")
//                    AppPopUpHandler.instance.initHintPopUp(container: self, message: "openLocation".localize, type: "location")
                    break
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
//            AppPopUpHandler.instance.initHintPopUp(container: self, message: "openLocation".localize, type: "location")
            
        }
    }
    
    func initMap() {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
        viewMap.camera = camera
        viewMap.isMyLocationEnabled = true
        viewMap.settings.myLocationButton = true
        viewMap.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    @IBAction func confirm(_ sender: Any) {
        let newGeoCOder = GMSGeocoder()
        self.lat =  viewMap.camera.target.latitude
        self.lng =  viewMap.camera.target.longitude
        
//        self.lat =  29.378586
//        self.lng = 47.990341

       
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
   
        var streetName = ""
        var cityName = ""
        var governorateName = ""
        
//        newGeoCOder.accessibilityLanguage = "En"

        newGeoCOder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            if let address = response?.firstResult() {
                let addressLines = address.lines
                var locality = ""
                if addressLines?.count ?? 0 > 0 {
                    let array = addressLines?[0].components(separatedBy: ", ")
                   
                    if let arrayOfAddres = array
                    {
                        streetName = arrayOfAddres[0]
                        if arrayOfAddres.count > 1 {
                            cityName = arrayOfAddres[1]
                        }
                        if arrayOfAddres.count > 2 {
                            governorateName = arrayOfAddres[2]
                        }

                        if arrayOfAddres.count > 3 {
                            locality = arrayOfAddres[arrayOfAddres.count - 3]
                        }
                    }
                  
                }
                if locality == ""{
                    locality = address.locality ?? ""
                }
//                let gov = address.administrativeArea ?? ""
//                let streetName = address.locality ?? ""
//                self.showIndicator(false)
                self.delegate?.popFromMapFRom(lat: self.lat , Lng: self.lng , Street: "\(streetName)  , \(cityName) , \(governorateName)")
                
                self.navigationController?.popViewController(animated: true)
             
//                self.navigationController?.pushViewController(addNewAddress(lat: self.lat, lng: self.lng, gov: gov, city: locality, streetName: streetName, address: self.selectedAddress), animated: true)
            } else {
//                self.navigationController?.pushViewController(addNewAddress(lat: self.lat, lng: self.lng, gov: "", city: "", streetName: "", address: self.selectedAddress), animated: true)
            }
        }
    }
}

extension AddAddressFromMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lng = locValue.longitude
        lat = locValue.latitude

        print("locations = \(locValue.latitude) \(locValue.longitude)")
      
           
            if !locationCame {
                initMap()
                locationCame = true
            }
        
    }
}

//extension AddAddressFromMapViewController: HintPopupDelegate {
//
//    func hintPopupReturn(type: String) {
//        if type == "location" {
//            UIApplication.shared.open(URL(string: "App-prefs:LOCATION_SERVICES")!)
//        } else if type == "app_location" {
//            if let url = URL(string: UIApplication.openSettingsURLString) {
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//        }
//    }
//}

extension AddAddressFromMapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: {
            self.viewMap.animate(toLocation: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude))
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
