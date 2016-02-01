//
//  DetailViewController.swift
//  Yelp
//
//  Created by Andrei Gurau on 1/29/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
class DetailViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var business: Business!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        var latitude = business.location!["coordinate"]!["latitude"]! as! Double
        var longitude = business.location!["coordinate"]!["longitude"]! as! Double
        let centerLocation = CLLocation(latitude: latitude, longitude: longitude)
        goToLocation(centerLocation)
        var coordinates = centerLocation.coordinate
        addAnnotationAtCoordinate(coordinates)
        navigationItem.title = business.name
        
        
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        print("function called")
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "An annotation"
        mapView.addAnnotation(annotation)
        //mapView(mapView, viewForAnnotation: annotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        // custom pin annotation
        print("mapview function called")
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        if #available(iOS 9.0, *) {
            annotationView!.pinTintColor = UIColor.greenColor()
        } else {
            // Fallback on earlier versions
        }
        
        return annotationView
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}


