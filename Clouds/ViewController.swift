//
//  ViewController.swift
//  Clouds
//
//  Created by Isaac Williams on 9/18/14.
//  Copyright (c) 2014 Isaac Williams. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var precipLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var currentLocationAddress: UILabel!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var currentLongitude: CLLocationDegrees = 0.0
    var currentLatitude: CLLocationDegrees = 0.0
    var currentLocationAddressRaw: AnyObject?

    private let apiKey = "d428124abc32d191be041287437e0f8d"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
        
//        getUpdatedWeatherData()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last! as CLLocation
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.latitude
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) in
            if placemarks!.count > 0 {
                self.currentLocationAddressRaw = placemarks![0]
                print("\(self.currentLocationAddressRaw)")
            }
        })
        
        NSLog("latitude %+.6f, longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
    }

    func getUpdatedWeatherData() -> Void {
        print("\(currentLongitude), \(currentLatitude)")
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: String(format: "%X,%X", currentLatitude, currentLongitude), relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location!)
                let weatherDictionary: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tempLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            }
            
        })
        
        downloadTask.resume()
    }
    
    @IBAction func refresh() {
        getUpdatedWeatherData()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }

}

