//
//  MapViewController.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var refreshBarItem: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    func updateData() {
        print("update map")
        let clear = self.mapView.annotations
        self.mapView.removeAnnotations(clear)
        
        var annotations = [MKPointAnnotation]()
        for location in StudentInformationModel.studentsLocation {
            let lat = location.latitude
            let long = location.longitude
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.lastName
            annotation.subtitle = location.mediaURL
            annotations.append(annotation)
        }
        self.mapView?.addAnnotations(annotations)
        
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let url: String = (view.annotation?.subtitle ?? "") ?? ""
            guard let toOpen =  URL(string: url), verifyUrl(urlString: url) else {
                self.showFailure(message: "can't open url: "  + url)
                return
            }
            UIApplication.shared.open(toOpen, options: [:], completionHandler: nil)
        }
    }
}

