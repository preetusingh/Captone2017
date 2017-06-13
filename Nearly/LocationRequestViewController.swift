//
//  LocationRequestViewController.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/13/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit
import STLocationRequest

class LocationRequestViewController: UIViewController,STLocationRequestControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationRequestController = STLocationRequestController.getInstance()
        locationRequestController.titleText = "We need your location for some awesome features"
        locationRequestController.allowButtonTitle = "Alright"
        locationRequestController.notNowButtonTitle = "Not now"
        locationRequestController.authorizeType = .requestAlwaysAuthorization
        locationRequestController.delegate = self
        //locationRequestController.present(onViewController: self)
        locationRequestController.view.frame = self.view.frame
        self.view.addSubview(locationRequestController.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

       
    func locationRequestControllerDidChange(_ event: STLocationRequestControllerEvent) {
        switch event {
        case .locationRequestAuthorized:
            self.showHomePage()
            break
        case .locationRequestDenied:
            self.showHomePage()
            break
        case .notNowButtonTapped:
            self.showHomePage()
            break
        case .didPresented:
            break
        case .didDisappear:
            break
        }
    }
    func showHomePage(){
        
        //self.dismiss(animated: true, completion: nil)
        let homeTabBarVC = XHERHomeTabBarViewController()
        self.present(homeTabBarVC, animated: false, completion: nil)
        
    }

    

}

