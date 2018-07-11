//
//  MapViewController.swift
//  MyContacts
//
//  Created by Admin on 09.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    //MARK: Properties
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var coordinatesTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: Actions
    
    @IBAction func revealCoordinatesWithLongPressOnMap(_ sender: UILongPressGestureRecognizer) {
        //Determine the coordinates
        if sender.state != UIGestureRecognizerState.began{
            return
        }
        let touchLocation = sender.location(in: map)
        let locationCoordinate = map.convert(touchLocation, toCoordinateFrom: map)
        coordinatesTextField.text = "lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)"
        
        //Create annotation
        map.removeAnnotations(map.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "He lives here"
        map.addAnnotation(annotation)
        
        //Reverse coordinates to address
        geocode(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude) { (placemark, error) in
            guard let placemark = placemark, error == nil else{
                return
            }
            self.addressTextField.text = "\(placemark.country ?? "") \(placemark.locality ?? "") \(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"
            
 
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPressentingInAddContactMode = presentingViewController is UINavigationController
        
        if isPressentingInAddContactMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ContactViewController is not inside a navigation controller.")
        }
    }
        
    
    //MARK: Geocode
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
}
