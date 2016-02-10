//
//  ViewController.swift
//  playingWithMaterial
//
//  Created by Anne Cahalan on 2/2/16.
//  Copyright © 2016 Anne Cahalan. All rights reserved.
//

import Alamofire
import Foundation
import Material
import UIKit

class ViewController: UIViewController {
    
    var cardViewArray = [IconCardView]()
    
    func arrayOfEndpoints() -> [URLStringConvertible] {
        let firstEndpoint: URLStringConvertible = "http://api.wunderground.com/api/b193c8afeeecdbb2/conditions/q/MI/Detroit.json"
        let secondEndpoint: URLStringConvertible = "http://api.wunderground.com/api/b193c8afeeecdbb2/conditions/q/AK/Deadhorse.json"
        let thirdEndpoint: URLStringConvertible = "http://api.wunderground.com/api/b193c8afeeecdbb2/conditions/q/australia/sydney.json"
        
        let endpointsArray: [URLStringConvertible] = [firstEndpoint, secondEndpoint, thirdEndpoint]
        
        return endpointsArray
    }
    
    struct location {
        var city: String?
        var weatherDescription: String?
        var tempF: Int?
        var tempStringF: String?
        var windMPH:Int?
    }
    
    // conditions constants
    let iceSkatingRange: [Int] = Array(20...40)
    let coatMaximum: Int = 40
    let scarfAndGlovesMaximum: Int = 35
    let hatMaximum:Int = 20
    let kayakMinimum: Int = 75
    let bikeRange: [Int] = Array(70...85)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarView = createNavBar()
        view.addSubview(navBarView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navBarView)
        MaterialLayout.height(view, child: navBarView, height: 70)
        
        for endpoint in arrayOfEndpoints() {
            makeTheCall(endpoint)
        }
        
//        placeCardViews(cardViewArray)
    }
    
    func makeTheCall(endpoint: URLStringConvertible) {
        let parser = JSONParser()
        print(parser.pinged())
        
        Alamofire.request(.GET, endpoint).responseJSON { response in
            
            var currentLocation: location = location()
            if let currentObservationDictionary = response.result.value?["current_observation"] {
                
                if let displayLocationDictionary = currentObservationDictionary?["display_location"] {
                    
                    if let city = displayLocationDictionary?["city"] as? String {
                        print("City: \(city)")
                        currentLocation.city = city
                    }
                    
                    if let weatherDescription =  currentObservationDictionary?["weather"] as? String {
                        print("Weather: \(weatherDescription)")
                        currentLocation.weatherDescription = weatherDescription
                    }
                    
                    if let tempF = currentObservationDictionary?["temp_f"] as? Int {
                        print("Temp: \(tempF)")
                        currentLocation.tempF = tempF
                        currentLocation.tempStringF = "\(tempF)"
                    }
                    
                    if let windMPH = currentObservationDictionary?["wind_gust_mph"] as? Int {
                        print("wind speed: \(windMPH)")
                        currentLocation.windMPH = windMPH
                    }
                    
                }
                
            }
            
            self.createCardView(currentLocation)
//            self.cardViewArray.append(self.createCardView(currentLocation))
        }
 
    }
    
    func createCardView(location: ViewController.location) -> IconCardView {
        let cardView: IconCardView = IconCardView()
        
        cardView.backgroundColor = MaterialColor.grey.lighten3
        cardView.divider = false
        
        // title label
        let titleLabel: UILabel = UILabel()
        if let city = location.city {
            titleLabel.text = "\(city):"
        }
        titleLabel.textColor = MaterialColor.blue.darken1
        titleLabel.font = RobotoFont.mediumWithSize(20)
        cardView.titleLabel = titleLabel
        
        // detail label
        let detailLabel = UILabel()
        if let tempF = location.tempF, weatherDescription = location.weatherDescription {
            detailLabel.text = "\(tempF)° and \(weatherDescription)"
        }
        detailLabel.numberOfLines = 0
        cardView.detailLabel = detailLabel
       
        cardView.rightImages = makeAnImageArray(location.tempF!)
        
        placeCardView(cardView)
        return cardView
    }
    
    func placeCardViews(cardViewArray: [IconCardView]) {
        for cardView in cardViewArray {
            view.addSubview(cardView)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            if let topThing: Int = cardViewArray.indexOf(cardView) {
                let topThingFloat: CGFloat = CGFloat(topThing)
                MaterialLayout.alignFromTop(view, child: cardView, top: (topThingFloat + 1) * 100 )
            }
            
            MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
        }
    }
    
    func placeCardView(cardView: IconCardView) {
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: cardView, top: 100)
        MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
    }
    
    
    func makeAnImageArray(temp: Int) -> Array<UIImageView> {
        //images
        let skates: UIImageView = UIImageView()
        skates.image = UIImage(imageLiteral: "skates")
        
        let coat: UIImageView = UIImageView()
        coat.image = UIImage(imageLiteral: "coat")
        
        let bike: UIImageView = UIImageView()
        bike.image = UIImage(imageLiteral: "bike")
        
        let hat: UIImageView = UIImageView()
        hat.image = UIImage(imageLiteral: "hat")
        
        let mittens: UIImageView = UIImageView()
        mittens.image = UIImage(imageLiteral: "mitten")
        
        let scarf: UIImageView = UIImageView()
        scarf.image = UIImage(imageLiteral: "scarf")
        
        var imageArray = [UIImageView]()
        
        if iceSkatingRange.contains(temp) {
            print("you can go iceskating!")
            imageArray.append(skates)
        }
        
        if temp < hatMaximum {
            print("you should wear a hat")
            imageArray.append(hat)
        }
        
        if temp < coatMaximum {
            print("you should wear a coat")
            imageArray.append(coat)
        }
        
        if temp < scarfAndGlovesMaximum {
            print("you should wear a scarf and gloves")
            imageArray.append(scarf)
            imageArray.append(mittens)
        }
        
        if bikeRange.contains(temp) {
            print("you should go on a bike ride today")
            imageArray.append(bike)
        }
        
        return imageArray
        
    }
    
    func createNavBar() -> NavigationBarView {
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.deepPurple.darken1
        
        navigationBarView.statusBarStyle = .LightContent
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Weather"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64
        
        return navigationBarView
    }
    
}

