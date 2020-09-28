//
//  TabBarController.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import UIKit

class TabBarController: UITabBarController {
    
    lazy var mapController: MapViewController = {
        let navigationMapController = self.viewControllers?[0] as! UINavigationController
        return navigationMapController.topViewController as! MapViewController
    }()
    lazy var tableController:TableViewController = {
        let navigationTableController = self.viewControllers?[1] as! UINavigationController
        return navigationTableController.topViewController as! TableViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocation()
    }
    
    func getStudentLocation() {
        self.mapController.refreshBarItem.isEnabled = false
        Client.getStudentLocation { (studentLocation, error) in
            self.mapController.refreshBarItem.isEnabled = true
            if error != nil {
                self.showErrorGetLocation(message: error?.localizedDescription ?? "")
            }
            StudentInformationModel.studentsLocation = studentLocation
            self.mapController.updateData()
            self.tableController.updateData()
        }
    }
    
    func showErrorGetLocation(message: String) {
        let alertVC = UIAlertController(title: "Failed to get locations", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(alert: UIAlertAction!) in self.getStudentLocation()}))
        show(alertVC, sender: nil)
    }
}
