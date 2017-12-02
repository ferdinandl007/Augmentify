//
//  ViewController.swift
//  Augmentify
//
//  Created by Ferdinand Lösch on 02.12.17.
//  Copyright © 2017 Ferdinand Lösch. All rights reserved.
//

import UIKit
import SceneKit
import MapKit
import CoreLocation
import ARCL
import MapKit
import ArcGIS

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
   var  places = [
    ["Arena Berlin", "Veranstaltungsort in großem Transportkomplex aus den 1920ern für Konzerte, Theater, Festivals & Versammlungen."],
    ["Badeschiff Berlin", "Strandbar am Flussufer, Yogakurse, beheizte Swimmingpools in umfunktionierten Lastkähnen & Saunas im Winter."],
    [" Molecule Man", "Statue in der Spree zwischen Elsenbrücke und Oberbaumbrücke"],
    [ "The Wall Museum", "Historisches Museum über die Berliner Mauer"],
    [ "Mercedes Benz Arena", "Große, moderne Veranstaltungshalle am Fluss für internationale Rock- & Pop-Konzerte mit privatem Pier."],
    [" Markthalle Neun"," Markthalle mit internationalen Essensständen und Geschäften sowie gelegentlichen Community-Veranstaltungen."],
    [" East Side Gallery", "Graffiti-Kunstwerke von 118 Künstlern an der Berliner Mauer, in denen der Mauerfall zelebriert wird."],
    [" Bahnhof Ostkreuz", "Der S- und Regionalbahnhof Berlin Ostkreuz ist der am meisten frequentierte Nahverkehrs-Umsteigebahnhof in Berlin."],
    [ "Berlinische Galerie", "Modernes Museum für Bildende Kunst, Fotografie & Architektur aus Berlin von 1870 bis zur Gegenwart."],
    [" Computerspielemuseum", "1997 gegründetes Museum über die Geschichte von Computerspielen."],
    [ "Berlin Ostbahnhof, Berlin Ostbahnhof ist ein Fern- und Nahverkehrsbahnhof im Berliner Ortsteil Friedrichshain."],
    [ "Heizkraftwerk Klingenberg", "Das Heizkraftwerk Klingenberg ist ein Heizkraftwerk (HKW) im Berliner Ortsteil Rummelsburg, das mehr als 300.000 Haushalte mit Strom und Wärme versorgt."]]
    
    var  code = [
        [52.496916, 13.453888, 36],
        [52.497864, 13.453771, 36],
        [52.496983, 13.458968, 32],
        [52.502724, 13.445309, 36],
        [52.506363, 13.443613, 37],
        [52.502322, 13.431819, 38],
        [52.505045, 13.439724, 37],
        [52.503121, 13.468970, 35],
        [52.503937, 13.398191, 37],
        [52.517513, 13.442016, 39],
        [52.510577, 13.434919, 37],
        [52.489448, 13.497694, 36]
    ]
    
    let  restaurantsCode = [[52.496763, 13.451002, 36],
    [52.497339, 13.450793, 36],
    [52.500984, 13.451011, 36],
    [52.491720, 13.446253, 38],
    [52.491178, 13.457766, 36],
    [52.493213, 13.460832, 37],
    [52.497968, 13.463622, 36],
    [52.502369, 13.456495, 37]
    ]
    
    let restaurants = [[ "Restaurante Chic", "Restaurant on the river with a nice view"],
    ["Freischwimmer", "Laid-back eclectic eatery over the river. Open until 00:00"],
    ["Fabrics", "Designer restaurant with panoramic views. Open until 11:00PM"],
    ["Pizzeria Farina", "Quiet and cozy pizza restaurant. Open until 11:30PM"],
    ["McDonald's", "Classic, long-running fast-food chain known for its burgers, fries & shakes."],
    ["BackWerk", "Bakery and fast-food chain."],
    ["WaffelTraum", "Ice cream shop and waffle restaurant. Open until 11:00PM"],
    ["Restaurant Areti", "Greek restaurant close to the Spree. Open until 11:00PM"]]
    
    var carLoc = CLLocation()
    var isDawn = true
    @IBOutlet weak var view2: UIView!
    let locationManager = CLLocationManager()
    
    
 
    
    let sceneLocationView = SceneLocationView()
    var map2:AGSMap!
    @IBOutlet weak var map: AGSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUP()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        sceneLocationView.run()
        view2.addSubview(sceneLocationView)
        setUpMap()
         self.carLoc = CLLocation(latitude: 52.3885715968019, longitude: 13.0602211208282)
        for item in code {
                loc(latitude: item[0] , longitude: item[1], altitude: item[2], imageName: "pin")
            
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.carLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    
    }

    
    
    func setUP(){
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.showMap))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.dowMap))
        swipedown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipedown)
    }
    
    @objc func dowMap(){
        if !isDawn {
            isDawn = true
            UIView.animate(withDuration: 0.2, animations: {
                self.map.center.x = self.view.center.x
                self.map.frame.origin.y += 600
                
            }) { _ in
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.map.center.x = self.view.center.x
                    
                })
            }
        }
    }
    
    @objc func showMap(){
        print("ShowMap")
        if isDawn {
             isDawn = false
        UIView.animate(withDuration: 0.25, animations: {
            self.map.frame.size.width -= 20
            self.map.frame.size.height -= 20
            self.map.center.x = self.view.center.x
            self.map.frame.origin.y -= 600
           
        }) { _ in
            
            UIView.animate(withDuration: 0.25, animations: {
                self.map.frame.size.width += 20
                self.map.frame.size.height += 20
                self.map.center.x = self.view.center.x
                
            })
        }
    }
    }
    
    func setUpMap(){
        //Add a basemap tiled layer
        self.map.layer.cornerRadius = 35
        //initialize map with a basemap
        self.map2 = AGSMap(basemapType: .darkGrayCanvasVector, latitude: 52.496983, longitude: 13.458968, levelOfDetail: 16)

        //assign the map to the map view
        self.map.map = map2
        
        
        
    }
    
    func loc(latitude: Double,longitude: Double,altitude: Double, imageName:String){
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let location2 = CLLocation(coordinate: coordinate, altitude: altitude - 10)
        let image = UIImage(named: imageName)!
        let distanceInMeters = self.carLoc.distance(from: CLLocation(latitude: latitude, longitude: longitude)) // result is in metexpected
        
        print("distanceInMeters\(distanceInMeters)")

        
        let  text  = LocationLabelAnnotationNode(location: location2, Label: "\( String(format: "%.2f", Double(distanceInMeters / 100))) km")
        let annotationNode = LocationAnnotationNode(location: location, image: image)
         sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: text)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    
    


}

