//
//  MapVC.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
   var objDashBoardContainerVC: DashBoardContainerVC?
    
    @IBOutlet weak var mapView: MKMapView!
    var arrPayload = [Restaurants]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    private var mapChangedFromUserInteraction = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.delegate = self
       self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        // If location services is enabled get the users location
       if CLLocationManager.locationServicesEnabled() {
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
                   locationManager.startUpdatingLocation()
               }

        // Do any additional setup after loading the view.
    }
    func setMapPayloadAndReload(arrPayload: [Restaurants]){
           self.arrPayload =  arrPayload
           self.addPinOnNearByLocation()
       }
    func addPinOnNearByLocation(){
           //remove old annotations before adding new annotations
           let allAnnotations = self.mapView.annotations
           self.mapView.removeAnnotations(allAnnotations)
           for objPayload in arrPayload{
            let objMapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: Double(objPayload.lat ?? 0) , longitude: Double(objPayload.lng ?? 0) ), title: objPayload.name ?? "", subtitle: "")
               mapView.addAnnotation(objMapPin)
           }
       }
    //MapView annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Identify user location
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        //Set custom annotation image
        annotationView?.image = UIImage(named: "MapPin")
        return annotationView
    }
    
    //Mapview Region change methods
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
       
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title)
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            // user changed map region
            print("user did completed changing map region")
            self.objDashBoardContainerVC?.getLocationData(userCoordinate: currentLocation?.coordinate, mapCenterCoordinate: mapView.centerCoordinate)
        }
    }
    
    // MARK: - MapView Delegate
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           defer {
               currentLocation = locations.last
               //self.getLocationData()
           }
           
           if currentLocation == nil {
               // Zoom to user location
               if let userLocation = locations.last {
                   let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                   mapView.setRegion(viewRegion, animated: false)
               }
           }
       }
       
       // If we have been deined access give the user the option to change it
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if(status == CLAuthorizationStatus.authorizedWhenInUse) {
               currentLocation = locationManager.location
               //Call API to get data based on user location
               self.objDashBoardContainerVC?.getLocationData(userCoordinate: currentLocation?.coordinate, mapCenterCoordinate: nil)
           }
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
