//
//  SecondVC.swift
//  Weather App
//
//  Created by Aurelio Le Clarke on 31.01.2022.
//

import Foundation
import UIKit
import CoreLocation

class SecondVC: UIViewController, UITextFieldDelegate {
    let weatherManager = WeatherManager()
    
    @IBOutlet weak var WeatherTemperature: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ConditionImage: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
    

    }
    
}
