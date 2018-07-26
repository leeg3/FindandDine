//
//  ftInfoViewController.swift
//  Find&Dine
//
//  Created by Yan Wen Huang on 6/17/18.
//  Copyright © 2018 WIT Senior Design. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import MapKit

class ftInfoViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var foodTruckName: UILabel!
    @IBOutlet weak var ftAddress: UILabel!
    @IBOutlet weak var ftMeal: UILabel!
    @IBOutlet weak var ftDay: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    //local variables for receiving data from tableView VC
    var location = String()
    var meal = String()
    var dayOfWeek = String()
    var ftName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTruckName.text = ftName
        ftAddress.text = location
        ftMeal.text = meal
        ftDay.text = dayOfWeek
        
        self.mapView.mapType = MKMapType.standard
        self.mapView.showsUserLocation = true
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        print(ftName, " ", location, " ", meal, " ", dayOfWeek)
    }
    
    @IBAction func openMap(_ sender: Any) {
        coordinates(forAddress: "\(location)") {
            (location) in
            guard let location = location else {
                return
            }
            self.openMapForPlace(lat: location.latitude, long: location.longitude)
        }
    }
    
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding Error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    public func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.location
        mapItem.openInMaps(launchOptions: options)
    }
}
