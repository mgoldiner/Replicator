//
//  ViewController.swift
//  Replicator
//
//  Created by Malcolm Goldiner on 12/22/16.
//  Copyright © 2016 Malcolm Goldiner. All rights reserved.
//

import UIKit
import FatSecretKit

class ViewController: UIViewController, FoodSearchClientDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var firstFoodTextField: UITextField!
    @IBOutlet weak var secondFoodTextField: UITextField!
    var firstFood: String? {
        get{
            return firstFoodTextField?.text
        }
    }
    var secondFood: String? {
        return secondFoodTextField?.text
    }
    
    func setup()
    {
        FoodSearchClient.sharedInstance.sharedFSClient = FSClient.shared()
        FoodSearchClient.sharedInstance.sharedFSClient!.oauthConsumerKey = "9f75a0ffde2c415fb401e3649f2685f6"
        FoodSearchClient.sharedInstance.sharedFSClient!.oauthConsumerSecret = "806be4a0328941109cb9dffbe0c03118"
        FoodSearchClient.sharedInstance.setup()
        FoodSearchClient.sharedInstance.delegate = self
    }
    
    func didGetResultsForSearch(result: String) {
        weak var weakSelf: ViewController? = self
        DispatchQueue.main.async {
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.updateUIForResult(result: result)
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        firstFoodTextField.delegate = self
        secondFoodTextField.delegate = self
    }
    
    @IBAction func pressCompare(_ sender: UIButton)
    {
        guard firstFood != nil && secondFood != nil else {
            return
        }
        
        FoodSearchClient.sharedInstance.getFoods(foodOne: firstFood!, foodTwo: secondFood!)
        
        activityIndicator.startAnimating()
        
        sender.isHidden = true
    }
    
    func updateUIForResult(result: String)
    {
        weak var weakSelf: ViewController? = self
        DispatchQueue.main.async {
            if result == "true"
            {
                weakSelf?.resultImageView.image = UIImage(named: "check")
            }
            else if result == "false"
            {
                weakSelf?.resultImageView.image = UIImage(named: "x")
            }
            else
            {
                weakSelf?.resultImageView.image = UIImage(named: "questionmark")
            }
            
            weakSelf?.compareButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}
