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
    
    let endpoint: URLStringConvertible = "http://api.wunderground.com/api/b193c8afeeecdbb2/conditions/q/MI/Detroit.json"
    var city: String?
    var weatherDescription: String?
    var tempF: Int?
    var tempStringF: String?
    var windMPH:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTheCall()
        
    }
    
    func makeSomeCards() {
        let cardview = createCardView()
        let navBarView = createNavBar()
        
        view.addSubview(navBarView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navBarView)
        MaterialLayout.height(view, child: navBarView, height: 70)
        
        
        view.addSubview(cardview)
        cardview.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: cardview, top: 100)
        MaterialLayout.alignToParentHorizontally(view, child: cardview, left: 20, right: 20)

    }
    
    func makeTheCall() {
        Alamofire.request(.GET, endpoint).responseJSON { response in
            
            if let currentObservationDictionary = response.result.value?["current_observation"] {
                if let displayLocationDictionary = currentObservationDictionary?["display_location"] {
                    
                    if let city = displayLocationDictionary?["city"] as? String {
                        print("City: \(city)")
                        self.city = city
                    }
                    
                    if let weatherDescription =  currentObservationDictionary?["weather"] as? String {
                        print("Weather: \(weatherDescription)")
                        self.weatherDescription = weatherDescription
                    }
                    
                    if let tempF = currentObservationDictionary?["temp_f"] as? Int {
                        print("Temp: \(tempF)")
                        self.tempF = tempF
                        self.tempStringF = "\(tempF)"
                    }
                    
                    if let windMPH = currentObservationDictionary?["temp_f"] as? Int {
                        print("wind speed: \(windMPH)")
                        self.windMPH = windMPH
                    }
                    
                }
                
            }
            
            self.makeSomeCards()
        }
 
    }
    
    func createCardView() -> IconCardView {
        let cardView: IconCardView = IconCardView()
        
        cardView.backgroundColor = MaterialColor.grey.lighten3
        cardView.divider = false
        
        // title label
        let titleLabel: UILabel = UILabel()
        titleLabel.text = weatherDescription
        
        titleLabel.textColor = MaterialColor.blue.darken1
        titleLabel.font = RobotoFont.mediumWithSize(20)
        cardView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = tempStringF
        detailLabel.numberOfLines = 0
        cardView.detailLabel = detailLabel
        
        //images 
        let img1: UIImageView = UIImageView()
        img1.image = UIImage(imageLiteral: "ic_favorite_white")
        
        let img2: UIImageView = UIImageView()
        img2.image = UIImage(imageLiteral: "ic_star_white")
        cardView.rightImages = [img1, img2]
        
        return cardView
 
    }
    
    func createNavBar() -> NavigationBarView {
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.deepPurple.darken1
        
        navigationBarView.statusBarStyle = .LightContent
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = city
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64
        
        return navigationBarView
    }
    
}

