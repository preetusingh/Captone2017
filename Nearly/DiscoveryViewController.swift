//
//  DiscoveryViewController.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/13/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD


let kTabbarHeight:Int = 0
let selectedPinImage = UIImage(named: "pinselected")
let pinImage = UIImage(named: "pin")

class DiscoveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    var currentLocation : CLLocationCoordinate2D!
    var locations : [GeoPoint]?
    var autoComplete : [POI]?
    
    @IBOutlet weak var currentLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        
        self.setupCollectionView()
        self.setupTableView()
        autoCompleteTableView.isHidden = true
        
        self.onCurrentLocationClick(currentLocationButton)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Setup View
    func setupTableView() {
        self.edgesForExtendedLayout = []
        
        
        let tblView =  UIView(frame: CGRect.zero)
        self.autoCompleteTableView.tableFooterView = tblView
        self.autoCompleteTableView.tableFooterView?.isHidden = true
        self.autoCompleteTableView.backgroundColor = UIColor.clear
        
        self.autoCompleteTableView.estimatedRowHeight = 100
        self.autoCompleteTableView.rowHeight = UITableViewAutomaticDimension
        let autoCompleteCellNib = UINib(nibName: "AutoCompleteCell", bundle: nil)
        self.autoCompleteTableView.register(autoCompleteCellNib, forCellReuseIdentifier: "AutoCompleteCell")
    }
    
    func setUpMapView(){
        
        
        
        mapView.removeAnnotations(mapView.annotations)
        //mapView.showsUserLocation = true
        if self.locations != nil{
            var index = 0
            for  location in self.locations!{
                index += 1
                
                let coordinate = CLLocationCoordinate2DMake(location.latitute,location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.placeName
                annotation.subtitle = "\(index)"
                self.mapView.addAnnotation(annotation)
                
                
            }
        }
        
        let yourAnnotationArray = mapView.annotations
        mapView.showAnnotations(yourAnnotationArray, animated: true)
        
        
        
        
        
    }
    func setupCollectionView() {
        
        let nib = UINib(nibName: "LocationCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "LocationCollectionViewCell")
        self.collectionViewHeightConstraint.constant = self.view.frame.size.height*0.22
        self.collectionViewBottomConstraint.constant = CGFloat(kTabbarHeight)
        
        
    }
    
    // MARK: - Map view delegate
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation
        {
            return
        }
        self.deselectAllPins()
        view.image = selectedPinImage
        //let pTitle = ((view.annotation?.title)!)!
        let pTitle = ((view.annotation?.subtitle)!)!
        let index = Int.init(pTitle)
        let bIndex = index! - 1
        let indexPath : IndexPath = NSIndexPath(row: bIndex, section: 0) as IndexPath
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        self.deselectAllPins()
    }
    
    func deselectAllPins(){
        
        
        for annotation in mapView.annotations {
            
            
            let viewI = mapView.view(for: annotation)
            if(viewI != nil){
                
                if (viewI?.isKind(of: MKAnnotationView.self))!
                {
                    viewI?.image = pinImage
                    
                }
            }
            
        }
    }
    
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let title = annotation.subtitle
        var index = 0
        if title! != nil{
            index = Int.init(title!!)!
        }
        
        if annotationView?.annotation is MKUserLocation
        {
            print("uerewjew fjksd fkldsjf d*********'")
            
        }else if(index == 1){
            annotationView!.image = selectedPinImage
        }
        else{
            annotationView!.image = pinImage
        }
        
        
        return annotationView
    }
    // MARK: - Table view delegate
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if autoComplete != nil{
            return autoComplete!.count
        }else{
            return 0
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoCompleteTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell", for: indexPath) as! AutoCompleteCell
            cell.autoComplete = self.autoComplete?[indexPath.row]
            return cell
            
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "POIViewCell", for: indexPath) as! POIViewCell
            cell.location = self.locations?[indexPath.row]
            return cell
            
        }
        
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if(tableView==self.tableView){
        //            let neabyBountiesViewController = NeabyBountiesViewController(nibName: "NeabyBountiesViewController", bundle: nil)
        //            neabyBountiesViewController.location = self.locations?[indexPath.row]
        //            self.navigationController?.pushViewController(neabyBountiesViewController, animated: true)
        //        }else{
        
        SVProgressHUD.show()
        let location = autoComplete?[indexPath.row]
        GooglePlacesServer.geocodeAddressString((location?.placeDescription)!, completion: { (placemark, error) -> Void in
            if (placemark?.location?.coordinate) != nil {
                
                self.autoCompleteTableView.isHidden = true
                self.searchTextField.text = location?.placeDescription
                self.view.endEditing(true)
                self.getPlaceDeatils(placeID: (location?.googlePlaceID)!)
                
            }else{
                //print(error?.description)
                SVProgressHUD.dismiss()
            }
        })
        //}
        
        
    }
    
    // MARK: - Search Bar delegate
    
    
    
    @IBAction func seachTextChanged(_ sender: UITextField) {
        autoCompleteTableView.isHidden = false
        fetchLocationsWithPlace(searchText: sender.text!)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        fetchLocationsWithPlace(searchText: textField.text!)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        autoCompleteTableView.isHidden = false
        fetchLocationsWithPlace(searchText: searchBar.text!)
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            //self.getNearbyLocations(geoPoint: currentLocation)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchLocationsWithPlace(searchText: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        self.getNearbyLocations(geoPoint: currentLocation)
        autoCompleteTableView.isHidden = true
        self.view.endEditing(true)
    }
    // MARK: - API calls
    func fetchLocationsWithPlace(searchText : String){
        
        
        
        GooglePlacesServer.sharedInstance.getSearchPlaces(placeName: searchText, success: { (locations :[POI]?) in
            if let locations = locations {
                
                if locations.count > 0{
                    self.autoCompleteTableView.isHidden = false
                    self.autoComplete = locations
                    self.autoCompleteTableView.reloadData()
                }else{
                    self.autoCompleteTableView.isHidden = true
                }
                
                
            }else{
                print("No result found")
                self.autoCompleteTableView.isHidden = true
            }
            
            
        }) { (error : Error?) in
            
        }
        
    }
    func getNearbyLocations(geoPoint : GeoPoint){
        
        SVProgressHUD.show()
        GooglePlacesServer.sharedInstance.getLocationBy(
            coordinates: geoPoint,radius: .nearby,
            success: { (contentsArray:[POI]?) in
                
                SVProgressHUD.dismiss()
                if let contentsArray = contentsArray {
                    
                    self.locations = contentsArray
                    self.collectionView.reloadData()
                    if((self.locations?.count)!>0){
                        let indexpath = IndexPath(row: 0, section: 0)
                        self.collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: false)
                    }
                    self.setUpMapView()
                }
        },
            failure: { (error:Error?) in
                
        })
    }
    func getPlaceDeatils(placeID:String){
        
        GooglePlacesServer.sharedInstance.getPlaceDetails(placeId: placeID, success: { (locationDetail : [POI]?) in
            
            
            if let locationDetail = locationDetail {
                
                
                
                self.getNearbyLocations(geoPoint: locationDetail[0].geoPoint!)
            }
            
            
        }) { (error : Error?) in
            print(error.debugDescription)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
