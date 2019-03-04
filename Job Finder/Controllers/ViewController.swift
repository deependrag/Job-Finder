//
//  ViewController.swift
//  Job Finder
//
//  Created by Deependra Dhakal on 3/3/19.
//  Copyright © 2019 Deependra Dhakal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import GooglePlaces
import SVProgressHUD
import TOWebViewController

class ViewController: UIViewController {
    
    // Name of all Job Providers
    let jobProviders : [String] = ["All", "Github", "SearchGov"]
    
    // Initial declaration of variable
    var jobsArray = [JobModel] ()
    let github = Github()
    let searchGov = SearchGov()
    var selectedJobProvider : String = "All"
    var locationFilterText : String?
    var titleFilterText : String?
    var webViewController = TOWebViewController()
    let pickJobProvider = UIPickerView()
    let dimView = UIView()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // Connecting Views
    @IBOutlet weak var jobListTableView: UITableView!
    @IBOutlet var filterPopUpView: UIView!
    @IBOutlet weak var pickedJobProvider: UITextField!
    @IBOutlet weak var searchBarLocation: UITextField!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting TableView delegate and datasource here
        jobListTableView.delegate = self
        jobListTableView.dataSource = self
        
        // Setting UIPickerView delegate and datasource here
        pickJobProvider.dataSource = self
        pickJobProvider.delegate = self
        
        
        // Providing Picker View to Job Provider TextField
        pickedJobProvider.inputView = pickJobProvider
        pickedJobProvider.text = jobProviders[0]
        
        // Design for Apply Filter Button in Popup
        applyFilterButton.layer.cornerRadius = 10
        applyFilterButton.clipsToBounds = true
        
        //Registering Custom cell to my tableView
        jobListTableView.register(UINib(nibName: "CustomCellForJobList", bundle: nil), forCellReuseIdentifier: "customCellForJobList")
        jobListTableView.rowHeight = 120.0
        jobListTableView.separatorStyle = .none
        
        
        // Navigation bar Setup with search bar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Job Position"
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        
        //Request Jobs From All Providers
        requestJobsFromAllProviders()
        
        
    }
    
    
    /// Requesting Jobs from all providers
    func requestJobsFromAllProviders() {
        requestJobListFromGithub()
        requestJobListFromSearchGov()
    }
    
    
    //MARK: - Job Filter Section
    
    /**
     Check if Specific Job Providers is selected in picker view
     
     If the job provider is selected as all then it will request all job provider for jobs
     */
    
    func filterJobListWithParameter() {
        // Clears the jobArray
        jobsArray = [JobModel]()
        
        if selectedJobProvider == jobProviders[1] {
            // Request Jobs from only Github
            requestJobListFromGithub()
            
        }else if selectedJobProvider == jobProviders[2] {
            //Request Job from only Search Gov
            requestJobListFromSearchGov()
            
        }else {
            //Request Job From all provider
            requestJobsFromAllProviders()
        }
        
    }
    
    
    /**
     Request Jobs from Github with or without any parameter
     
     It check if there is any value in Global variable **locationFilterText** and **titleFilterText**.
     if value is available then it add that value into url and request API for a job with that paramater
     */
    func requestJobListFromGithub() {
        var params : [String : String] = [:]
        
        // Checks if user search with Job position
        if titleFilterText != nil && titleFilterText != "" {
            params[github.titleFilterKey] = titleFilterText
        }
        
        // Checks if user search with Job Location
        if locationFilterText != nil && locationFilterText != "" {
            params[github.locationFilterKey] = locationFilterText
        }
        
        // Make a request to API with URL and Parameters
        requestForJobs(withURL: github.BASE_URL, jobProvider: github, parameter: params)
        
    }
    
    /**
     Request Jobs from Search Gov with or without any parameter
     
     It check if there is any value in Global variable **locationFilterText** and **titleFilterText**.
     if value is available then it add that value into url and request API for a job with that paramater
    */
    func requestJobListFromSearchGov() {
        var params : [String : String] = [:]
        
        // Checks if user search with Job position
        if titleFilterText != nil && titleFilterText != "" {
            params[searchGov.filterKey] = titleFilterText
        }
        
        // Checks if user search with Job Location and Job Title
        if locationFilterText != nil && locationFilterText != "" {
            params[searchGov.filterKey] = titleFilterText == nil ?  "" : titleFilterText! + " in \(locationFilterText ?? "")"
        }
        
        // Make a request to API with URL and Parameters
        requestForJobs(withURL: searchGov.BASE_URL, jobProvider: searchGov, parameter: params)
        
    }
    
    
    // Opens google autocomplete location search View Controller
    @IBAction func searchBarLocation(_ sender: UITextField) {
        searchBarLocation.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        dismissPopUpFilterView()
    }
    
    
    // calls showPopUpFilterView() to show popup to apply filters
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        showPopUpFilterView()
    }
    
    
    // Closes the popup view
    @IBAction func closePopupButtonPressed(_ sender: UIButton) {
        
        //Assign popup model views with already selected value
        searchBarLocation.text = locationFilterText
        pickedJobProvider.text = selectedJobProvider
        
        dimView.removeFromSuperview()
        filterPopUpView.removeFromSuperview()
    }
    
    
    // Assigns location filter text and Job provider to apply filter in Job list table view
    @IBAction func applyFilterPressed(_ sender: UIButton) {
        locationFilterText = searchBarLocation.text
        
        if let filteredJobProvider = pickedJobProvider.text {
            selectedJobProvider = filteredJobProvider
        }
        
        dismissPopUpFilterView()
        filterJobListWithParameter()
    }
    
    
    /// Shows popup for location and job provider filter
    func showPopUpFilterView() {
        
        // Adds dim background behind the popup
        dimView.frame = UIApplication.shared.keyWindow!.frame
        dimView.backgroundColor = UIColor.black
        dimView.alpha = 0.8
        UIApplication.shared.keyWindow!.addSubview(dimView)
        
        // Shows popup in center of the parent view with corner radius
        filterPopUpView.center = view.center
        filterPopUpView.layer.cornerRadius = 10
        filterPopUpView.clipsToBounds = true
        UIApplication.shared.keyWindow!.addSubview(filterPopUpView)
        
    }
    
    
    /// Dismiss the popup filter view
    func dismissPopUpFilterView() {
        // remove views from parent view
        dimView.removeFromSuperview()
        filterPopUpView.removeFromSuperview()
    }
    
    
    
    //MARK: - Present Job Details with URL
    
    /**
     When user click on Jobs in Table View then it will load the Job Details URL in Webview
     
     It takes Url of Job details as a string value and load that URL using TOWebViewController library.
     - Parameter url: string Url which loads up in webView
     
     ## Usage Example ##
     ````
     showJobDetails(url: "www.google.com")
     ````
     */
    func showJobDetails(url: String) {
        if let jobDetailsUrl = URL(string: url) {
            webViewController = TOWebViewController(url: jobDetailsUrl)
        }
        let navigationController = UINavigationController(rootViewController: webViewController)
        present(navigationController, animated: true)
        
    }
    
    
    // MARK: - Request Data from server and update jobArray
    
    /**
     Request Jobs From API Using Alamofire library
     
    It takes Url and Parameter to send request to API and API will return list of jobs depending on the Url and Job Filter Parameter
     - parameters:
        - url: API BASE Url
        - jobProvider: Job Provider Class
        - params: Parameter to filter Job
     ## Important Note ##
     + Job Filter Paramter should be passed in dictionary i.e. [String: String]
     
     */
    func requestForJobs(withURL url: String, jobProvider: JSONKeyProtocol, parameter params: [String: String] ) {
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: params ).responseJSON { (response) in
            if response.result.isSuccess {
                self.updateJobsModel(withData: JSON(response.result.value!), provider: jobProvider)
            }else {
                print("Error occured parsing data")
            }
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    /**
     Updates the jobsArray with list of jobs that we got from API.
     
     It takes JSON Data and Job Provier Class as parameter and extract the data value from JSON using the key defined in Job Provider class.
     - parameters:
        - json: Data of type JSON
        - provider: Job provider that conforms JSONKeyProtocol
     
     ## Important Note ##
     + Key in Job Provider class must match the JSON Key.
     
     ## Usage Example ##
        ````
        updateJobModel(withData: JSONDataWeGotFromAPI, provider: Github())
        ````
     */
    func updateJobsModel(withData json: JSON, provider: JSONKeyProtocol) {
        for index in 0..<json.count {
            let job = JobModel()
            
            // Initializing JobModel() with data we got from JSON
            job.jobTitle = json[index][provider.jobTitleKey].stringValue
            job.companyName = json[index][provider.companyNameKey].stringValue
            job.jobPostedDate = dateFormatter(format: json[index][provider.jobPostedDateKey].stringValue)
            job.companyLogoUrl = json[index][provider.companyLogoKey].stringValue
            job.jobDetailsUrl = json[index][provider.jobDetailsKey].stringValue
            
            // Checks if CompanyLocation is in array
            let location = json[index][provider.companyLocationKey].stringValue
            if location.isEmpty {
                job.companyLocation = json[index][provider.companyLocationKey][0].stringValue
            }else {
                job.companyLocation = location
            }
            
            jobsArray.append(job)
        }
        
        // Checks if job list is empty or not. If it is empty then table view shows "No job available"
        noDataInTableViewLabel()
        
        jobListTableView.reloadData()
    }
    
    
    /// Checks if job list is empty or not. If it is empty then table view shows "No job available"
    func noDataInTableViewLabel() {
        if jobsArray.count == 0 {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: jobListTableView.bounds.size.width, height: jobListTableView.bounds.size.height))
            noDataLabel.text          = "No job available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            jobListTableView.backgroundView  = noDataLabel
            
        }else{
            jobListTableView.backgroundView = nil
        }
    }
    
    
    
    //MARK: - Date formatter
    
    /**
     It takes string date as input and format the date into **dd/MM/yyyy** and returns date in string value.
     
     - Parameter date: String that should be in format **"EEE MMM dd HH:mm:ss Z yyyy"** or **"yyyy-MM-dd"**
     - Returns: Date in **dd/MM/yyyy** format as string value.
     - Precondition: Parameter date should be in format either "EEE MMM dd HH:mm:ss Z yyyy" or "yyyy-MM-dd"
     
     ## Important Notes ##
     + passed date string must be in one of the two formats **"EEE MMM dd HH:mm:ss Z yyyy"** or **"yyyy-MM-dd"**
    */
    func dateFormatter(format date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        if let dateFromString = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: dateFromString)
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let dateFromText = dateFormatter.date(from: date) {
                dateFormatter.dateFormat = "dd/MM/yyyy"
                return dateFormatter.string(from: dateFromText)
            }
        }
        return ""
    }
    
    
}

//MARK: - Extension for other Class

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GMSAutocompleteViewControllerDelegate {
    
    //MARK: - Google Location AutoComplete Delegate Methods
    
    // Triggers when location is loaded and selected
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        searchBarLocation.text = place.name
        dismiss(animated: true, completion: nil)
        showPopUpFilterView()
    }
    
    // Triggers when somthing went wrong while searching location
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        showPopUpFilterView()
    }
    
    // Triggers when user click cancel button
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        showPopUpFilterView()
    }
    
    // MARK: - Job Postion Search Bar Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        searchBar.setShowsCancelButton(false, animated: true)
        if let filterText = searchBar.text {
            titleFilterText = filterText
            filterJobListWithParameter()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        titleFilterText = ""
        dismiss(animated: true, completion: nil)
        filterJobListWithParameter()
    }
    
    
    //MARK: - Table view Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellForJobList", for: indexPath) as! CustomCellForJobList
        if jobsArray.count != 0 {
            cell.jobTitleLabel.text = jobsArray[indexPath.row].jobTitle
            cell.companyNameLabel.text = jobsArray[indexPath.row].companyName
            cell.companyLocationLabel.text = jobsArray[indexPath.row].companyLocation
            cell.jobPostDateLabel.text = jobsArray[indexPath.row].jobPostedDate
            cell.companyLogoImageView.sd_setImage(with: URL(string: jobsArray[indexPath.row].companyLogoUrl), placeholderImage: UIImage(named: "logo-placeholder.png"))
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showJobDetails(url: jobsArray[indexPath.row].jobDetailsUrl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsArray.count
    }
    
    
    
    //MARK: - Picker View Delegate Methods
    
    // Specifying the total number of job providers
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jobProviders.count
    }
    
    // Specifying the number of components in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Provides Title For Picker View in each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return jobProviders[row]
    }
    
    // When User Picked the Job Provider then this function is triggered
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedJobProvider.text = jobProviders[row]
        pickedJobProvider.endEditing(true)
    }
    
}

