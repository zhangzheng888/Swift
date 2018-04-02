//
//  MapTableViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 3/31/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

class MapTableViewController: UITableViewController {

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
        updateTableView()
    }

    // MARK: Actions
    @IBAction func pressRefresh(_ sender: Any) {
        updateTableView()
    }

    @IBAction func pressAdd(_ sender: Any) {

        guard userLocation.objectId != nil else {
            print("User location is not empty")
            return
        }

        guard let addLocation: AddLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController else {
            print("Add Location View Controller does not exist")
            return
        }

        self.present(addLocation, animated: true, completion: nil)

    }

    @IBAction func pressLogout(_ sender: Any) {

        UdacityClient.sharedInstance.logoutFromApplication(completionHandlerForLogout: {(success, error) in performUIUpdatesOnMain {

            if success {
                print("Logout Success!")

            } else {
                print("Cannot logout!")
                return
            }
            self.dismiss(animated: true, completion: nil)
            }
        })
        
    }

    private func updateTableView() {
        ParseClient.sharedInstance().getStudentLocations({(success, result, errorString) in performUIUpdatesOnMain {
                if success {
                    self.tableView.reloadData()
                }

                if errorString != nil {
                        print("Cannot update data")
                }
            }
        })
    }

    // MARK: UITableViewDelegate Methods
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
            } else { UIApplication.shared.open(url) }
        }
    }
}
