//
//  LoginViewController.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/6/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit
import MapKit
enum LoginSignupViewMode {
    case login
    case signup
}
class LoginViewController: UIViewController {
    
    
    var mode:LoginSignupViewMode = .signup
    let animateDuration = 0.25
    var animator: UIDynamicAnimator? = nil
    
    @IBOutlet weak var loginPasswordInput: loginInputView!
    
    @IBOutlet weak var loginEmailInput: loginInputView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signupPasswordInput: loginInputView!
    @IBOutlet weak var signupEmailInput: loginInputView!
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
    
    
    //    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    
    //    @IBOutlet weak var emailTextField: UITextField!
    //    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleView(animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */







    
    

    @IBAction func handleSignup(_ sender: UIButton) {
        if mode == .login {
            toggleView(animated: true)
        }
        else {
            let newUser = User()
            newUser.username = signupEmailInput.textFieldView.text!
            newUser.password = signupPasswordInput.textFieldView.text!
            newUser.email = signupEmailInput.textFieldView.text!
            
        }
        
    }
    
    @IBAction func handleLogin(_ sender: UIButton){
        if mode == .signup {
            toggleView(animated:true)
        }
        else {
            let userName = loginEmailInput.textFieldView.text!
            let password = loginPasswordInput.textFieldView.text!
            login(userName: userName, password: password)
        }
    }
    
    
    
    
    func login(userName: String, password: String){

        self.openNextController()
        
    }
    
    func toggleView(animated: Bool){
        mode = mode == .login ? .signup:.login
        loginWidthConstraint.isActive = mode == .signup ? true:false
        loginButtonVerticalCenterConstraint.priority = mode == .login ? 300:900
        signupButtonVerticalCenterConstraint.priority = mode == .signup ? 300:900
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: animated ? animateDuration : 0) {
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = self.mode == .login ? 1:0
            self.signupContentView.alpha = self.mode == .signup ? 1:0
            
            //rotate and scale login button
            let scaleLogin:CGFloat = self.mode == .login ? 1:0.4
            let rotateAngleLogin:CGFloat = self.mode == .login ? 0:CGFloat(-M_PI_2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLogin, y: scaleLogin)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            
            // rotate and scale signup button
            let scaleSignup:CGFloat = self.mode == .signup ? 1:0.4
            let rotateAngleSignup:CGFloat = self.mode == .signup ? 0:CGFloat(-M_PI_2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignup, y: scaleSignup)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
            
            let bounds = self.socialsView.bounds
            print(bounds)
            print(self.mode)
            self.animator = UIDynamicAnimator(referenceView: self.view)
            var points = CGPoint()
            if self.mode == .login{
                //                points = CGPoint(x: self.loginView.center.x, y: self.socialsView.bounds.midY)
                print(self.socialsView.center.x)
                points = CGPoint(x: self.socialsView.center.x, y: self.loginButton.center.y + 90)
            }
            else {
                points = CGPoint(x: self.signupView.center.x, y: self.signupButton.center.y + 90)
            }
            let snapBehaviour: UISnapBehavior = UISnapBehavior(item: self.socialsView, snapTo: points)
            self.animator?.addBehavior(snapBehaviour)
        }
        
    }
    
    func openNextController(){
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                let locationReq = LocationRequestViewController(nibName: "LocationRequestViewController", bundle: nil)
                
                self.present(locationReq, animated: true, completion: nil)
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                let homeTabBarVC = HomeTabBarViewController()
                self.present(homeTabBarVC, animated: false, completion: nil)
                
                
            }
        } else {
            print("Location services are not enabled")
            let locationReq = LocationRequestViewController(nibName: "LocationRequestViewController", bundle: nil)
            
            self.present(locationReq, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        
    }
    
}

