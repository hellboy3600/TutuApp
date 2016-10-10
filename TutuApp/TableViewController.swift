//
//  TableViewController.swift
//  TutuApp
//
//  Created by Сергей on 05/10/16.
//  Copyright © 2016 SM. All rights reserved.
//


import UIKit

class TableViewController: UITableViewController {
  
  var searchBar : UISearchBar!
  var resultsController = UITableViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //self.searchController = UISearchController(searchResultsController: self.resultsController)
    self.searchBar = UISearchBar()
    self.navigationItem.titleView = self.searchBar
    
    //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: UIBarButtonItemStyle.plain, target: self, action: selector(back)
    //self.tableView.tableHeaderView = self.searchController.searchBar
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
  }
  
}
