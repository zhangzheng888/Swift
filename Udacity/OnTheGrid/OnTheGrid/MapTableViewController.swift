//
//  MapTableViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 3/31/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

class MapTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let loadingIndicator = UIActivityIndicatorView()
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    // MARK: Outlets

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentLoadingAlert()
        updateTableView()
    }

    // MARK: Actions
    
    @IBAction func pressRefresh(_ sender: Any) {
        updateTableView()
    }

    @IBAction func pressAdd(_ sender: Any) {
        guard userLocation.objectId != nil else {
            presentAlertWithCancel("", "User " + "\"\(userLocation.firstName!)" + " " + "\(userLocation.lastName!)\"" + " Has Already Posted a Student Location. Would You Like to Overwrite Their Location?" , "Overwrite")
            return
        }

        guard let addLocation: AddLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController else {
            print("Add Location View Controller does not exist")
            return
        }
        self.present(addLocation, animated: true, completion: nil)
    }

    @IBAction func pressLogout(_ sender: Any) {
        showIndicator()
        UdacityClient.sharedInstance.logoutFromApplication(completionHandlerForLogout: {(success, error) in
            performUIUpdatesOnMain {
                if success {
                    print("Logout Success!")
                    self.dismissIndicator()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.dismissIndicator()
                    self.presentAlert("Failed to Logout", "Unable to logout. Please check network connection", "OK")
                    return
                }
            }
        })
    }
}

extension MapTableViewController {
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.sharedInstance.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MapTableViewCell
        let information = StudentData.sharedInstance.studentLocations[(indexPath as NSIndexPath).row]
        if let firstName = information.firstName, let lastName = information.lastName {
            cell.nameLabel?.text = firstName + " " + lastName
            cell.descriptionLabel?.text = information.mediaURL
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let information = StudentData.sharedInstance.studentLocations[(indexPath as NSIndexPath).row]
        if let mediaURL = information.mediaURL, let url = URL(string: mediaURL) {
            if url.scheme != "https" {
                print("ERROR with opening URL")
            } else {
                UIApplication.shared.open(url)
            }
        }
    }
}

private extension MapTableViewController {
    
    private func updateTableView() {
        ParseClient.sharedInstance.getStudentLocations({(success, result, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                    self.tableView.reloadData()
                }
                
                if errorString != nil {
                    self.presentAlert("Failed to Load", "Unable to retrieve map information. Please check network connection", "OK")
                    return
                }
            }
        })
    }
    
    // MARK: Alert Controller
    
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Alert Controller with Cancel
    
    private func presentAlertWithCancel(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            
            let addLocation: AddLocationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController)!
            self.present(addLocation, animated: true, completion: nil)
            NSLog("The \"\(title)\" alert occured.")
        }))
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        })
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Activity Indicator
    
    private func presentLoadingAlert() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showIndicator() {
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func dismissIndicator() {
        loadingIndicator.stopAnimating()
    }
}
