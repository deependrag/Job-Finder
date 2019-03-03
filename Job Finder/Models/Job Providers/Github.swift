//
//  Github.swift
//  Job Finder
//
//  Created by Deependra Dhakal on 3/3/19.
//  Copyright © 2019 Deependra Dhakal. All rights reserved.
//

import Foundation

class Github: JSONKeyProtocol {
    
    let BASE_URL = "https://jobs.github.com/positions.json"
    
    let jobTitleKey : String = "title"
    
    let companyNameKey : String = "company"
    
    let companyLocationKey : String = "location"
    
    let jobPostedDateKey : String = "created_at"
    
    let companyLogoKey : String = "company_logo"
    
    let jobDetailsKey : String = "url"
    
    //Parameter
    let locationFilterKey : String = "location"
    let titleFilterKey : String = "description"
    
}
