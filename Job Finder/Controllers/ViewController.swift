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
    
    
    // Initial declaration of variable
    var jobsArray = [JobModel] ()
    let github = Github()
    let searchGov = SearchGov()
    
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
        
        //Registering Custom cell to my tableView
        jobListTableView.register(UINib(nibName: "CustomCellForJobList", bundle: nil), forCellReuseIdentifier: "customCellForJobList")
        jobListTableView.rowHeight = 120.0
        jobListTableView.separatorStyle = .none
        
        // Request for Jobs from all job provider
        requestForJobs(withURL: github.BASE_URL, jobProvider: github, parameter: [:])
        requestForJobs(withURL: searchGov.BASE_URL, jobProvider: searchGov, parameter: [:])
    }
    
    @IBAction func closePopupButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func applyFilterPressed(_ sender: UIButton) {
    }
    
    @IBAction func searchBarLocation(_ sender: UITextField) {
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    // MARK: - Request Data from server and update jobArray
    
    // Request Jobs From API Using Alamofire library
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
    
    
    // Update the jobsArray with list of jobs that we got from API
    func updateJobsModel(withData json: JSON, provider: JSONKeyProtocol) {
        for index in 0..<json.count {
            let job = JobModel()
            
            // Initializing JobModel() with data we got from JSON
            job.jobTitle = json[index][provider.jobTitleKey].stringValue
            job.companyName = json[index][provider.companyNameKey].stringValue
            job.companyLocation = json[index][provider.companyLocationKey].stringValue
            job.jobPostedDate = json[index][provider.jobPostedDateKey].stringValue
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
        jobListTableView.reloadData()
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsArray.count
    }
    
}

