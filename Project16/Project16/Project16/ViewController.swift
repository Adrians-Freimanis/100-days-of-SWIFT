//
//  ViewController.swift
//  Project16
//
//  Created by adrians.freimanis on 28/07/2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Add a button to the navigation bar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(changeMapTypeButtonTapped))
        
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Craziest football fans in the world!")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Almost all the women are bondes")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "The city with the big tower")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Great pasta")
        
        
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        
        
    }
    
    @objc func changeMapTypeButtonTapped(){
        let ac = UIAlertController(title: "Select map type", message: nil, preferredStyle: .actionSheet)
        
        let standartAction = UIAlertAction(title: "Standart", style: .default) {
            _ in
            self.mapView.mapType = .standard
        }
        
        let satelliteAction = UIAlertAction(title: "Satellite", style: .default){
            _ in
            self.mapView.mapType = .satellite
        }
        
        let hybridAction = UIAlertAction(title: "Hybrid", style: .default){
            _ in
            self.mapView.mapType = .hybrid
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(standartAction)
        ac.addAction(satelliteAction)
        ac.addAction(hybridAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }



    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard annotation is Capital else {return nil}
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        }else{
            annotationView?.annotation = annotation
        }
        
        // Typecast annotationView as MKPinAnnotationView and change pinTintColor to blue
        if let pinAnnotationView = annotationView as? MKMarkerAnnotationView {
            pinAnnotationView.markerTintColor = UIColor.blue
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//        let wikiAction = UIAlertAction(title: "View wiki", style: .default) { _ in
//            let city = capital.title?.lowercased()
//
//            if let wikiURL = self.wikipediaURLForCity(city: city ?? "riga") {
//                let webViewController = WebViewController()
//                webViewController.wikipediaURL = wikiURL // Set the wikipediaURL property before presenting the WebViewController
//                self.navigationController?.pushViewController(webViewController, animated: true)
//            } else {
//                let errorAlert = UIAlertController(title: "Error", message: "Wikipedia page not available for this city.", preferredStyle: .alert)
//                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(errorAlert, animated: true, completion: nil)
//            }
//        }
//
//        ac.addAction(wikiAction)
        present(ac, animated: true)
    }


//    
//
//    func wikipediaURLForCity(city: String) -> URL?{
//        let urlString = "https://en.wikipedia.org/wiki/\(city)"
//        return URL(string: urlString)
//    }


}

