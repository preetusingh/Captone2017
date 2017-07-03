//
//  ProfileViewController.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/13/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD





class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var claimedButton: UIButton!
    let currentUser = User.current()
    @IBOutlet weak var postedButton: UIButton!
    var claimedBounties = [Bounty]()
    var postedBouties = [Bounty]()
    let refreshControl = UIRefreshControl()
    var isClaimed = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
        setupRefreshControl()
        self.animationButton(btn: claimedButton)
        self.getClaimedBouties(isRefresh: false)
        self.getPostedBounties(isRefresh: false)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        //Some View config
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.height/2
        self.imageProfile.layer.borderWidth = 2
        self.imageProfile.layer.borderColor = kYellow.cgColor
        
    }
    
    func setUpView(){
        
        
        //        let logOutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut(sender:)))
        //self.navigationItem.leftBarButtonItem = logOutButton
        
        if currentUser?.coverPictureUrl != nil {
            let url = URL(string: (currentUser?.coverPictureUrl!)!)
            coverImage.clipsToBounds = true
            coverImage.setImageWith(url!)
            coverImage.contentMode = .scaleAspectFill
        }
        if currentUser?.profileImageUrl != nil{
            
            let url = (currentUser?.profileImageUrl!)!
            imageProfile.clipsToBounds = true
            imageProfile.setImageWith(url)
            
        }
        if currentUser?.firstName != nil{
            self.usernameLabel.text = currentUser?.firstName
        }else{
            self.usernameLabel.text = ""
        }
        
        let tokens = currentUser!.tokens
        self.tokenLabel.text = "\(tokens)"
    }
    
    func setUpTableView(){
        tableView.dataSource = self;
        tableView.delegate = self
        tableView.estimatedRowHeight = 400
        self.tableView.register(HomeFeedUnclaimedBountyCell.self, forCellReuseIdentifier: "HomeFeedUnclaimedBountyCell")
        tableView.tableFooterView = UIView()
        
    }
    func setupRefreshControl() {
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        
        if isClaimed{
            
            self.getClaimedBouties(isRefresh: true)
        }else{
            self.getPostedBounties(isRefresh: true)
        }
    }
    
    
    @IBAction func getPostedBounties(_ sender: AnyObject){
        
        
        isClaimed = false
        self.claimedButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.animationButton(btn: postedButton)
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func getClaimedBounties(_ sender: AnyObject){
        
        isClaimed = true
        self.postedButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        self.animationButton(btn: claimedButton)
        self.tableView.reloadData()
        
    }
    
    @IBAction func  logOut(sender:UIButton) {
        PFUser.logOutInBackground { (error:Error?) in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDidLogOut"), object: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isClaimed{
            if self.claimedBounties != nil {
                return claimedBounties.count
            }
            else{
                return 0
            }
        }else{
            if self.postedBouties != nil {
                return postedBouties.count
            }
            else{
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.height * 0.25
        }
        else {
            return self.view.bounds.height * 0.30
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
        let cell = tableView.cellForRow(at: indexPath) as! BountyViewCell
        detailViewController.currentBounty = cell.bounty
        detailViewController.viewControllerMode = .browsing
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFeedUnclaimedBountyCell", for: indexPath) as! HomeFeedUnclaimedBountyCell
        
        let bounty : Bounty
        if isClaimed{
            cell.claimITLabel.isHidden = false
            bounty = self.claimedBounties[indexPath.row]
        }else{
            cell.claimITLabel.isHidden = true
            bounty = self.postedBouties[indexPath.row]
        }
        
        
        cell.distanceLabel.isHidden = true
        print("cell for row at index \(bounty.postedAtLocation.placeName)")
        cell.bounty = bounty
        
        
        
        return cell
        
        
        
        
    }
    func animationButton(btn : UIButton){
        UIView.animate(withDuration: 0.6 ,
                       animations: {
                        btn.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        },
                       completion: { finish in
                        UIView.animate(withDuration: 0.6){
                            //self.postedButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }
        })
    }
    func getClaimedBouties(isRefresh : Bool){
        if !isRefresh{
            SVProgressHUD.show()
        }
        
        Server.sharedInstance.fetchBountyEarneddBy(user: currentUser!, success: { (bounties : [Bounty]?) in
            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            if let bounties = bounties {
                
                self.claimedBounties = bounties
            }
            else {
                self.claimedBounties = []
            }
            
            self.tableView.reloadData()
            
            
        }) { (error: Error?) in
            print(error?.localizedDescription)
        }
    }
    func getPostedBounties(isRefresh : Bool){
        
        if !isRefresh{
            SVProgressHUD.show()
        }
        
        Server.sharedInstance.fetchBountyPostedBy(user: currentUser!, success: { (bounties: [Bounty]?) in
            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            if bounties != nil{
                
                if (bounties?.count)! > 0 {
                    self.postedBouties = bounties!
                }
                else {
                    self.postedBouties = []
                }
            }
            
            
            if isRefresh{
                self.tableView.reloadData()
            }
            
            
            
            
        }) { (error: Error?) in
            print(error)
        }
    }
    
    
}

