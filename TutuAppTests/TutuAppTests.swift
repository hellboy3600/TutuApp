//
//  TutuAppTests.swift
//  TutuAppTests
//
//  Created by Сергей on 05/10/16.
//  Copyright © 2016 SM. All rights reserved.
//

import XCTest
@testable import TutuApp

class TutuAppTests: XCTestCase {
  
  var viewController : ViewController!
  var tableViewController : TableViewControllerFrom!

  override func setUp() {
    super.setUp()
      
    viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    tableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableViewControllerFrom") as! TableViewControllerFrom

  }
    
  override func tearDown() {
      super.tearDown()
  }
  
  func testDateInFieldForViewController() {
    
    XCTAssertNotNil(viewController, "Should not be nil")
    
    let _ = viewController.view
    let s = viewController.scheduleView
    let kek = viewController.dateLabel
    let datePick = viewController.datePicker
    XCTAssertNotNil(s, "Should not be nil")
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    let date = formatter.string(from: (datePick?.date)!)
    XCTAssertEqual(kek?.text, date)
  }
  
  func TestCellTextAterLoading() {
    
    XCTAssertNotNil(tableViewController, "The table controller view should be set")
    
    tableViewController.searchFlag = true
    _ = tableViewController.view
    let tableView = tableViewController.tableView
    tableViewController.loadListOfFrom()
    let indexPath = IndexPath(row: 0, section: 0)
    tableView?.reloadData()
    
    let cell = tableView?.cellForRow(at: indexPath) as! TableViewCell
    XCTAssertNotNil(cell)

    let text = cell.cityText.text
    XCTAssertEqual(text, "Вена")
  }
}
