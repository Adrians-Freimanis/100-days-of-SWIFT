//
//  ViewController.swift
//  Project22
//
//  Created by adrians.freimanis on 01/08/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    
    var locationManager: CLLocationManager!
    
    var beaconDetected = false // New variable to track if the beacon has been detected

    let circleView = UIView() // Circle view for animation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        view.backgroundColor = UIColor.gray
        
        // Create the circle view and add it to the main view
               circleView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
               circleView.backgroundColor = UIColor.blue
               circleView.layer.cornerRadius = 25
               view.addSubview(circleView)

               // Add Auto Layout constraints to center the circleView horizontally and vertically
               circleView.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   circleView.widthAnchor.constraint(equalToConstant: 50),
                   circleView.heightAnchor.constraint(equalToConstant: 50)
               ])
           }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    //00
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // Reset scale to default

            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                circleView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // Scale down the circle

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                circleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Scale up the circle

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                circleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5) // Scale up the circle

            @unknown default:
                print("Error")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            if !beaconDetected {
                           // Show UIAlertController when beacon is first detected
                           let alertController = UIAlertController(title: "Beacon Detected", message: "Your bacon is first detected!", preferredStyle: .alert)
                           alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                           present(alertController, animated: true, completion: nil)

                           beaconDetected = true // Update the boolean to true so the alert won't be shown again
                       }
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }


}


