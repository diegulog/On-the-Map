//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Diego on 25/09/2020.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findButtom: CustomButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var stackViewLink: UIStackView!
    @IBOutlet weak var stackViewLocation: UIStackView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewLink?.addBackground(color: .systemGray6)
        stackViewLocation?.addBackground(color: .systemGray6)
    }
    
    @IBAction func findLocationAction(_ sender: Any) {
        guard let locationText = locationTextField.text, locationTextField.hasText else{
            showFailure(message: "Please enter a valid location")
            return
        }
        guard let linkText = linkTextField.text, verifyUrl(urlString: linkTextField.text!) else {
            showFailure(message: "Please enter a valid link example: http://www.udacity.com")
            return
        }
        
        setSearch(true)
        Client.getUserData { (userModel, error) in
            if let userModel = userModel{
                self.geocoder.geocodeAddressString(locationText) { placemarks, error in
                    self.setSearch(false)
                    guard let location = placemarks?.first?.location else {
                        self.showFailure(message: "Geocoding error: Please try another location")
                        return
                    }
                    let mapString = placemarks?.first?.description.components(separatedBy: "@")[0]
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as! ConfirmLocationViewController
                    let studenLocation = StudentLocation(createdAt: nil, firstName: userModel.firstName, lastName: userModel.lastName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, mapString: mapString ?? locationText, mediaURL: linkText, objectId: nil, uniqueKey: userModel.uniqueKey, updatedAt: nil)
                    vc.studentLocation = studenLocation
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                
            }else{
                self.showFailure(message: error?.localizedDescription ?? "")
                self.setSearch(false)
            }
        }
    }
    
    func setSearch(_ loggingIn: Bool) {
        if loggingIn {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        locationTextField.isEnabled = !loggingIn
        linkTextField.isEnabled = !loggingIn
        findButtom.isEnabled = !loggingIn
        findButtom.alpha = loggingIn ? 0.5 : 1.0

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
