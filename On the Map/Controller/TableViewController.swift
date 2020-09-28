//
//  TableViewController.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateData() {
        print("update table")
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationModel.studentsLocation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellStudentLocation", for: indexPath)
        let studentLocation = StudentInformationModel.studentsLocation[indexPath.row]
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = StudentInformationModel.studentsLocation[indexPath.row]
        guard let toOpen =  URL(string: studentLocation.mediaURL), verifyUrl(urlString: studentLocation.mediaURL) else {
            self.showFailure(message: "can't open url: "  + studentLocation.mediaURL)
            return
        }
        UIApplication.shared.open(toOpen, options: [:], completionHandler: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
