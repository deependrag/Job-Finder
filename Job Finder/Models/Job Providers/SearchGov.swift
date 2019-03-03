//
//  SearchGov.swift
//  Job Finder
//
//  Created by Deependra Dhakal on 3/3/19.
//  Copyright © 2019 Deependra Dhakal. All rights reserved.
//

import Foundation

protocol JSONKeyProtocol {
    
    var jobTitleKey : String {get}
    
    var companyNameKey : String {get}
    
    var companyLocationKey : String {get}
    
    var jobPostedDateKey : String {get}
    
    var companyLogoKey : String {get}
    
    var jobDetailsKey : String {get}
}

class SearchGov: JSONKeyProtocol {
    
    let BASE_URL = "https://jobs.search.gov/jobs/search.json"
    
    let jobTitleKey : String = "position_title"
    
    let companyNameKey : String = "organization_name"
    
    let companyLocationKey : String = "locations"
    
    let jobPostedDateKey : String = "start_date"
    
    let companyLogoKey : String = ""
    
    let jobDetailsKey : String = "url"
    
    //JSON key for filter
    let filterKey : String = "query"
    
}
