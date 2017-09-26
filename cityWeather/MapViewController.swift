//
//  ViewController.swift
//  cityWeather
//
//  Created by Andrea Agudo on 4/9/17.
//  Copyright © 2017 Andrea Agudo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBtn : UIButton!
    @IBOutlet weak var topFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    fileprivate let weatherPresenter = WeatherPresenter(weatherService: WeatherService())
    fileprivate var dataToDisplay = MapData()
    
    var cityTextField: String = ""
    var cityName : String = ""
 
    typealias FinishedDownload = () -> ()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBtn
        searchBtn.setTitle(NSLocalizedString("Search",comment:""), for: .normal)
        
        searchBtn.backgroundColor = .red
        searchBtn.titleLabel?.textColor = .white
        searchBtn.layer.cornerRadius = 5
        
        //mapView
        mapView.isHidden = true
        mapView.delegate = self
        
        //title
        titleLabel.text = NSLocalizedString("AppName",comment:"")
        
        //presenter
        weatherPresenter.attachView(self)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchAction(_ sender: Any) {        
        weatherPresenter.cityTextField = textField.text!
        self.weatherPresenter.getLocation()
        
    }
    
}

extension MapViewController: WeatherView {
    
    func locationDataRecieved() {
        
        self.weatherPresenter.getWeather()
        if weatherPresenter.totalResultsCount > 0 {
            UIView.animate(withDuration: 0.8, animations: {
                self.topFieldConstraint.constant = 15
                self.titleLabel.alpha = 0
                
                //mapView
                self.mapView.isHidden = false
                
                self.view.layoutIfNeeded()
            }, completion: {
                _ in self.titleLabel.isHidden = true
            })
            
            //mapView
            let lat = Double(dataToDisplay.lat)!
            let long = Double(dataToDisplay.lng)!
            let latDelta:CLLocationDegrees = 0.01
            let longDelta:CLLocationDegrees = 0.01
            
            
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
            mapView.setRegion(region, animated: true)
            
            let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = dataToDisplay.name
            self.mapView.addAnnotation(objectAnnotation)
        }
        
    }
    
    func error() {
        
        let alert = UIAlertController(title: NSLocalizedString("Error",comment:""), message: NSLocalizedString("NotExist",comment:""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok",comment:""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setData(_ data: MapData) {
        dataToDisplay = data
        print("DataToDisplay: " + String(describing: dataToDisplay))
    }
}
