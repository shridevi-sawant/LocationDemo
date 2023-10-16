//
//  ViewController.swift
//  LocationDemo
//
//  Created by Shridevi Sawant on 13/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusL: UILabel!
    
    let locUtility = LocationUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View did load")
    }

    @IBAction func startClick(_ sender: Any) {
        if locUtility.isAuthorized {
            locUtility.startTracking()
            statusL.text = "Tracking started.."
        }
        else {
            print("Authorization is not avaialable")
        }
    }
    
    // url scheme
    /*
     http - browser
     geo - map
     mailto - email
     smsto - messeging
     tel - call
     */
    @IBAction func mapClick(_ sender: Any) {
        // open map application
        if let loc = locUtility.currentLocation {
            let mapUrl = "http://maps.apple.com/?ll=\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
            
            if let mUrl = URL(string: mapUrl)
            {
                if UIApplication.shared.canOpenURL(mUrl) {
                    UIApplication.shared.open(mUrl)
                }
                else {
                    print("Map application not found")
                }
            }
        }
    }
    
    @IBAction func addressClick(_ sender: Any) {
        locUtility.getAddress { addr in
            self.statusL.text = addr
        }
    }
    
    @IBAction func currentClick(_ sender: Any) {
        if let loc = locUtility.currentLocation {
            statusL.text = """
            Lattitude: \(loc.coordinate.latitude)
            Longitude: \(loc.coordinate.longitude)
            """
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locUtility.stopTracking()
    }
}

