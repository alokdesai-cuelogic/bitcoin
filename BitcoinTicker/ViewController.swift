//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencyCode = ["BTC","ETH","XRP","LTC","BCH"]
    let currencyName = ["Bitcoin","Ethereum","Ripple","Litecoin","Bitcoin Cash"]
    let currencyImages = ["bitcoin","ethereum","ripple","litecoin","bitcoincash"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var finalURL = ""
    var currencyNameIndex = 0
    var currencyIndex = 0

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyNamePicker: UIPickerView!
    @IBOutlet weak var currencyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyNamePicker.delegate = self
        currencyNamePicker.dataSource = self
        getBitcoinCurreny()
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPicker {
            return currencyArray.count
        } else {
            return currencyName.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == currencyPicker {
            return currencySymbol[row] + " " + currencyArray[row] 
        } else {
            return currencyName[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == currencyPicker {
            currencyIndex = row
        } else {
            currencyImage.image = UIImage(named: currencyImages[row])
            currencyNameIndex = row
        }
        getBitcoinCurreny()
    }
    
    func getBitcoinCurreny(){
        finalURL = baseURL + currencyCode[currencyNameIndex] + currencyArray[currencyIndex]
        getBitCoinRate(url: finalURL)
    }
    
    func getBitCoinRate(url: String) {
        SVProgressHUD.show()
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess {
                print("Success")
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinRate(json: bitcoinJSON)
            } else {
                self.bitcoinPriceLabel.text = "Price Not Available"
            }
        }
    }
    
    func updateBitcoinRate(json: JSON){
        SVProgressHUD.dismiss()
        if let bitcoinRate = json["ask"].int {
            bitcoinPriceLabel.text = String(bitcoinRate)
        } else {
            bitcoinPriceLabel.text = "Price Not Available"
        }
    }
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
//    
//    func getWeatherData(url: String, parameters: [String : String]) {
//        
//        Alamofire.request(url, method: .get, parameters: parameters)
//            .responseJSON { response in
//                if response.result.isSuccess {
//
//                    print("Sucess! Got the weather data")
//                    let weatherJSON : JSON = JSON(response.result.value!)
//
//                    self.updateWeatherData(json: weatherJSON)
//
//                } else {
//                    print("Error: \(String(describing: response.result.error))")
//                    self.bitcoinPriceLabel.text = "Connection Issues"
//                }
//            }
//
//    }
//
//    
//    
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
//    func updateWeatherData(json : JSON) {
//        
//        if let tempResult = json["main"]["temp"].double {
//        
//        weatherData.temperature = Int(round(tempResult!) - 273.15)
//        weatherData.city = json["name"].stringValue
//        weatherData.condition = json["weather"][0]["id"].intValue
//        weatherData.weatherIconName =    weatherData.updateWeatherIcon(condition: weatherData.condition)
//        }
//        
//        updateUIWithWeatherData()
//    }
//    




}

