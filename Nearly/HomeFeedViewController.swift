//
//  HomeFeedViewController.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/13/17.
//  Copyright © 2017 Nearly. All rights reserved.
//


import UIKit
import Parse
import SVProgressHUD
var searchDistanceInMiles = 200.0
class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NearByClaimedViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundColorMask: UIView!
    
    var bountiesArray:[Bounty]?
    var claimedBountiesArray:[Bounty]?
    var tableViewDataBackArray = [Bounty]()
    var tableViewDataBackArrayFar = [Bounty]()
    
    var userCurrentLocation:PFGeoPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.title = "HOME"
//        let appLogo = UIImage(named: "icons8-NFC N_100")
//        let appLogoImageView = UIImageView(image: appLogo)
//        appLogoImageView.contentMode = .scaleAspectFit
//        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        appLogoImageView.frame = titleView.bounds
//        titleView.addSubview(appLogoImageView)
//        self.navigationItem.titleView = titleView
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let titleView = NavigationTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        titleView.textLabel.text = "Nearly"
        self.navigationItem.titleView = titleView
        
        self.setupTableView()
        self.setupRefreshControl()
        // Do any additional setup after loading the view.
        weak var weakSelf = self
        SVProgressHUD.show()
        
        self.callAPI {
            weakSelf?.updateTableView()
        }
        
        let notificationName = Notification.Name("CompletedClaiming")
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteClaiming(sender:)), name: notificationName, object: nil)
        
    }
    
    func didCompleteClaiming(sender:Any) {
        weak var weakSelf = self
        self.callAPI {
            weakSelf?.updateTableView()
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callAPI(success:@escaping ()->()) {
        
        
        let server = Server.sharedInstance
        
        //Get unclaimed bounties nearby
        PFGeoPoint.geoPointForCurrentLocation { (currentLocation:PFGeoPoint?, error:Error?) in
            
            if error == nil {
                print("lat = \(currentLocation?.latitude), long = \(currentLocation?.longitude)")
                if let currentLocation = currentLocation {
                    
                    self.userCurrentLocation = currentLocation
                    weak var weakSelf = self
                    server.fetchUnClaimedBountyNear(location: currentLocation, withInMiles: searchDistanceInMiles,
                                                    success: { (bountiesArray:[Bounty]?) in
                                                        
                                                        if let strongSelf = weakSelf {
                                                            
                                                            strongSelf.bountiesArray = bountiesArray
                                                            
                                                            server.fetchClaimedBountyNear(location: currentLocation, withInMiles: searchDistanceInMiles,
                                                                                          success: { (claimedBountiesArray:[Bounty]?) in
                                                                                            weakSelf?.claimedBountiesArray = claimedBountiesArray
                                                                                            success()
                                                                                            SVProgressHUD.dismiss()
                                                            },
                                                                                          failure: { (error:Error?) in
                                                                                            SVProgressHUD.dismiss()
                                                            })
                                                            
                                                        }
                    },
                                                    failure: { (error:Error?) in
                                                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        weak var weakSelf = self
        self.callAPI {
            refreshControl.endRefreshing()
            weakSelf?.updateTableView()
        }
    }
    
    // MARK: - TableView Methods
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(HomeFeedUnclaimedBountyCell.self, forCellReuseIdentifier: "HomeFeedUnclaimedBountyCell")
        let collectionViewNib = UINib(nibName: "NearByClaimedViewCell", bundle: nil)
        self.tableView.register(collectionViewNib, forCellReuseIdentifier: "NearByClaimedViewCell")
        
        self.tableView.isHidden = true
    }
    
    func updateTableView() {
        
        self.tableView.isHidden = false
        
        self.tableViewDataBackArray.removeAll()
        self.tableViewDataBackArrayFar.removeAll()
        self.tableView.reloadData()
        
        if let bountiesArray = bountiesArray {
            
            for bounty in bountiesArray {
                
                if bounty.distanceFromCurrentInMiles < 10 {  //If bounty is close
                    
                    self.tableViewDataBackArray.append(bounty)
                    
                    let newIndexPath = IndexPath(row: self.tableViewDataBackArray.count-1, section: 1)
                    
                    UIView.animate(withDuration: 2, animations: {
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: [newIndexPath], with:.fade)
                        self.tableView.endUpdates()
                    })
                }
                else {
                    
                    self.tableViewDataBackArrayFar.append(bounty)
                    
                    let newIndexPath = IndexPath(row: self.tableViewDataBackArrayFar.count-1, section: 2)
                    
                    UIView.animate(withDuration: 2, animations: {
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: [newIndexPath], with:.left)
                        self.tableView.endUpdates()
                        
                        //                        self.tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: false)
                    })
                    
                    //                    self.tableView.reloadRows(at: [newIndexPath], with: .left)
                    
                    
                    //                    let indexOfFirstFar = bountiesArray.index(of: bounty)
                    //                    let restOfBounties = Array(bountiesArray.suffix(from: indexOfFirstFar!))
                    //                    self.tableViewDataBackArrayFar.append(contentsOf: restOfBounties)
                    //                    break
                }
            }
            
            UIView.animate(withDuration: 1, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
        }
        
        //        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1{
            return tableViewDataBackArray.count
        }
        else {
            return tableViewDataBackArrayFar.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearByClaimedViewCell", for: indexPath) as! NearByClaimedViewCell
            
            cell.nearByClaimedArray = claimedBountiesArray
            
            cell.delegate = self
            
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFeedUnclaimedBountyCell", for: indexPath) as! HomeFeedUnclaimedBountyCell
            
            let bounty = self.tableViewDataBackArray[indexPath.row]
            
            cell.bounty = bounty
            cell.claimITLabel.isHidden = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFeedUnclaimedBountyCell", for: indexPath) as! HomeFeedUnclaimedBountyCell
            
            let bounty = self.tableViewDataBackArrayFar[indexPath.row]
            cell.bounty = bounty
            cell.claimITLabel.isHidden = true
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If selected is a BountyViewCell run it's builtin selected animation before pushing
        if indexPath.section == 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as! BountyViewCell
            cell.startSelectedAnimation(completion: { (selectedCell:BountyViewCell) in
                let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
                detailViewController.currentBounty = selectedCell.bounty
                detailViewController.viewControllerMode = .claiming
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
        }
        if indexPath.section == 2 {
            let cell = tableView.cellForRow(at: indexPath) as! BountyViewCell
            cell.startDeniedSelectionAnimation(completion: { (selectedCell:BountyViewCell) in
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.height * 0.25
        }
        else {
            return self.view.bounds.height * 0.25
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Make all cell transparent for backgroundMask to show through
        cell.backgroundColor = UIColor.clear
        
        //        if indexPath.section == 0 {
        //
        //            if claimedBountiesArray != nil && (claimedBountiesArray?.count)! > 0 {
        //                let nearByClaimedViewCell = cell as! NearByClaimedViewCell
        //
        //                nearByClaimedViewCell.collectionView.collectionViewLayout.collectionViewContentSize
        //                let indexPathOfItemOne = IndexPath(item: 0, section: 0)
        //                nearByClaimedViewCell.collectionView.scrollToItem(at: indexPathOfItemOne, at: .left, animated: true)
        //            }
        //        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section == 2 {
            if let headerView = view as? HomeFeedHeaderView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.clear
                headerView.backgroundView = backgroundView
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
            let headerView = HomeFeedHeaderView()
            headerView.headerLabel.text = "Go There!"
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
            return 30.0
        }
        return 0
    }
    
    // MARK: - NearByClaimedViewCell Delegate
    func userDidSwipeCollectionViewTo(offset: CGFloat) {
        self.backgroundColorMask.alpha = offset * 0.25
    }
    
    func userDidChoose(claimedBounty: Bounty) {
        let detailVC = DetailViewController()
        detailVC.viewControllerMode = .browsing
        detailVC.currentBounty = claimedBounty
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}

