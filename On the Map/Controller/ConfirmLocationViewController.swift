//
//  ConfirmLocationViewController.swift
//  On the Map
//
//  Created by Diego on 27/09/2020.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    var studentLocation: StudentLocation!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: CustomButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        var annotations = [MKPointAnnotation]()
        let coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = studentLocation.mapString
        annotations.append(annotation)
        mapView?.addAnnotations(annotations)
        mapView?.showAnnotations(self.mapView.annotations, animated: true)

    }
    
    func updateUI(_ loggingIn: Bool) {
        if loggingIn {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        finishButton.isEnabled = !loggingIn
        finishButton.alpha = loggingIn ? 0.5 : 1.0

    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func finishAction(_ sender: Any) {
        updateUI(true)
        Client.createLocation(studentLocation: studentLocation) { (success, error) in
            self.updateUI(false)
            if(success){
                self.dismiss(animated: true, completion: nil)
                self.refresh()
            }else{
                self.showFailure(message: "Failed to publish location: " + (error?.localizedDescription ?? "" ))
            }
        }
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
