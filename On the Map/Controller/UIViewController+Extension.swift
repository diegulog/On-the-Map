//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by Diego on 25/09/2020.
//

import UIKit

extension UIViewController {
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        Client.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func refreshAction(_ sender: Any) {
        refresh()
    }
    
    func refresh(){
        let rootController = UIApplication.shared.windows.first!.rootViewController
        let tabController = rootController?.presentedViewController as! TabBarController
        tabController.getStudentLocation()
    }
    
    @IBAction func createLocationAction(_ sender: Any) {
       
        if StudentInformationModel.userLocation?.objectId != nil {
            let alertVC = UIAlertController(title: nil, message: "You have already posted a Student Location, Would you like to overwrite your current location", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {(alert: UIAlertAction!) in self.presentAddLocationVC()}))
            self.present(alertVC, animated: true, completion: nil)
        }else{
            presentAddLocationVC()
        }
       
    }
    
    func presentAddLocationVC(){
      performSegue(withIdentifier: "addLocationViewController", sender: self)
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func verifyUrl (urlString: String?) -> Bool {
       if let urlString = urlString {
           if let url = NSURL(string: urlString) {
               return UIApplication.shared.canOpenURL(url as URL)
           }
       }
       return false
   }
}


extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = 5
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

