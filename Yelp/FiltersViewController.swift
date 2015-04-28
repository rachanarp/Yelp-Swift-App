//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Rachana Bedekar on 4/26/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController : FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, FiltersViewControllerDelegate {

    var sortOptions: [[String:String]]!
    var categories: [[String:String]]!
    var distances: [[String:String]]!
    var deals : [[String:String]]!

    var switchStatesForSections = NSMutableArray() //each element contains an array of bool
    
    var sectionNames = [["name" : "Sort By", "code": "sort"],
        ["name" : "Distance", "code": "radius_filter"],
        ["name" : "Deals", "code": "deals_filter"],
        ["name" : "Categories", "code": "category_filter"]]
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categories = yelpCategories()
        self.sortOptions = yelpSortByOptions()
        self.distances = yelpDistances()
        self.deals = yelpDeals()
        
        for var i = 0; i<self.sectionNames.count; ++i {
            self.switchStatesForSections.addObject(NSMutableArray())}
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        
        for var i = 0; i < sectionNames.count; ++i {
            if let sectionName : String = sectionNames[i]["code"] {
            
            switch sectionName {
            
            case "category_filter" :
                let switchStatesForSection: [Bool] = switchStatesForSections[i] as! [Bool]
        
                for var row = 0; row < switchStatesForSection.count; ++row {
                    let isSelected = switchStatesForSection[row]
                    if isSelected {
                        selectedCategories.append(categories[row]["code"]!)
                    }
                }
                if selectedCategories.count > 0 {
                    filters["categories"] = selectedCategories
                }
            case "sort":
                let switchStatesForSection: [Bool] = switchStatesForSections[i] as! [Bool]
                
                for var row = 0; row < switchStatesForSection.count; ++row {
                    let isSelected = switchStatesForSection[row]
                    if isSelected {
                        filters["sort"] = self.sortOptions[row]["code"]
                    }
                }
            case "radius_filter":
                let switchStatesForSection: [Bool] = switchStatesForSections[i] as! [Bool]
                
                for var row = 0; row < switchStatesForSection.count; ++row {
                    let isSelected = switchStatesForSection[row]
                    if isSelected {
                        filters["radius_filter"] = self.distances[row]["code"]
                    }
                }
            case "deals_filter":
                let switchStatesForSection: [Bool] = switchStatesForSections[i] as! [Bool]
                
                for var row = 0; row < switchStatesForSection.count; ++row {
                    let isSelected = switchStatesForSection[row]
                    if isSelected {
                        filters["deals_filter"] = "true"
                    }
                }
            default:
                println ("unknown filter")
                
            }
        }
        }
        
        println(filters)
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "American", "code": "newamerican"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Chinese", "code": "chinese"]
        ]
    }
    
    func yelpSortByOptions() -> [[String:String]] {
    return [["name" : "Best Match", "code": "0"],
    ["name" : "Distance", "code": "1"],
    ["name" : "Highest Rated", "code": "2"],
    ]
    }
    
    func yelpDistances() -> [[String:String]] {
    return [["name" : "Best Match", "code": ""],
    ["name" : "1 mile", "code": "2000"],
    ["name" : "5 miles", "code": "10000"],
    ]
    }

    func yelpDeals() -> [[String:String]] {
    return [["name" : "Offering a Deal", "code": "true"]
    ]
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        (switchStatesForSections[indexPath.section] as! NSMutableArray)[indexPath.row] = value
        println("filters view controller got the switch event")
        
        //Now validate the switch constraints & make the switches act like a radio button list
        if (value == true) {
        for var i=0; i<(switchStatesForSections[indexPath.section] as! NSMutableArray).count; ++i {
            if (i != indexPath.row) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: indexPath.section))
             (switchStatesForSections[indexPath.section] as! NSMutableArray)[i] = false
            cell?.setSelected(false, animated: true);
            }
        }
        }
        
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        switch indexPath.section {
        case 0: cell.switchLabel.text = self.sortOptions[indexPath.row]["name"]
        case 1: cell.switchLabel.text = self.distances[indexPath.row]["name"]
        case 2: cell.switchLabel.text = self.deals[indexPath.row]["name"]
        case 3: cell.switchLabel.text = self.categories[indexPath.row]["name"]
        default : println("Error: section is out of range")
        }

        cell.delegate = self
       /* if switchStates[indexPath.row] != nil {
            cell.onSwitch.on = switchStates[indexPath.row]!
        } else {
            cell.onSwitch.on = false
        }*/
        
        if  (switchStatesForSections[indexPath.section] as! NSMutableArray).count <= indexPath.row {
            (switchStatesForSections[indexPath.section] as! NSMutableArray).addObject(false)
        }
        
        cell.onSwitch.on = ((switchStatesForSections[indexPath.section] as! NSMutableArray)[indexPath.row] as! Bool) ?? false
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return yelpSortByOptions().count
        case 1 : return yelpDistances().count
        case 2: return yelpDeals().count
        case 3: return yelpCategories().count
        default : println("Error: section is out of range")
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]["name"]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
