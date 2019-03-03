//
//  ViewController.swift
//  Job Finder
//
//  Created by Deependra Dhakal on 3/3/19.
//  Copyright © 2019 Deependra Dhakal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var jobListTableView: UITableView!
    @IBOutlet var filterPopUpView: UIView!
    @IBOutlet weak var pickedJobProvider: UITextField!
    @IBOutlet weak var searchBarLocation: UITextField!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func closePopupButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func applyFilterPressed(_ sender: UIButton) {
    }
    
    @IBAction func searchBarLocation(_ sender: UITextField) {
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}

