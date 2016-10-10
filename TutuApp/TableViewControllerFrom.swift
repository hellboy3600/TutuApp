//
//  TableViewControllerFrom.swift
//  TutuApp
//
//  Created by Сергей on 07/10/16.
//  Copyright © 2016 SM. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableViewControllerFrom: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate {

  var json : JSON = []                      //объект класса JSON из библиотеки SwiftyJSON
  var arrayOfStations : [Stations] = []     //массив класса Stations (инфо о нем в соответствующем файле)
  var searchFlag : Bool!      //Флаг для определения группы поиска элементов (если false, то для пункта отправки, иначе для пунка прибытия)
  var filteredArray : [Stations] = []   //массив Stations, отфильтрованных по поиску
  var shouldShowSearchResults = false   //флаг для определения того, что нужно отображать данные из filteredArray
  var customSearchController: CustomSearchController!   //определение кастомного класса SearchController'а
  var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)    //индикатор для ожидания загрузки информации в tableView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = UIColor.black
    
    if (!searchFlag) {
      self.navigationItem.title = "Отправление"
    } else {
      self.navigationItem.title = "Прибытие"
    }
    configureCustomSearchController()       //Вызов функции инициализации CustomSearchController'а
    
    activityIndicatorView.center = self.view.center
    tableView.backgroundView = activityIndicatorView
    self.activityIndicatorView.startAnimating()       //Вызов индикатора активности
    self.activityIndicatorView.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    self.activityIndicatorView.color = UIColor.orange

    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

    DispatchQueue.main.async {      //Асинхронное выполнение обработки json-массива "citiesTo" или "citiesFrom" по флагу searchFlag, по завершении обновляются данные таблицы и исчезает индикатор активности
      if (!self.searchFlag) {
        self.loadListOfFrom()
      } else {
        self.loadListOfTo()
      }
      self.tableView.reloadData()
      self.activityIndicatorView.stopAnimating()
      self.activityIndicatorView.hidesWhenStopped = true
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

  // MARK: Функции UITableViewDelegate и DataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    if shouldShowSearchResults {
      return filteredArray.count
    }
    else {
      return arrayOfStations.count
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if shouldShowSearchResults {
      return filteredArray[section].stationsArray.count
    }
    else {
      return arrayOfStations[section].stationsArray.count
    }
  }
  
  // MARK: Задание текста для секции
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String{
    if shouldShowSearchResults {
      return filteredArray[section].country
    }
    else {
      return arrayOfStations[section].country
    }
  }
  
   // MARK: Задание цета текста для секции
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let v = view as? UITableViewHeaderFooterView {
      v.textLabel?.textColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    }
  }
  
  // MARK: инициализация cell от данных поиска или данных с json обработчика в зависимости от флага shouldShowSearchResults
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! TableViewCell
  
    if shouldShowSearchResults {
      
      cell.cityText.text = filteredArray[(indexPath as NSIndexPath).section].city
      cell.labelText.text = filteredArray[(indexPath as NSIndexPath).section].stationsArray[(indexPath as NSIndexPath).row].name
    }
    else {
      cell.cityText.text = arrayOfStations[(indexPath as NSIndexPath).section].city
      cell.labelText.text = arrayOfStations[(indexPath as NSIndexPath).section].stationsArray[(indexPath as NSIndexPath).row].name
    }
    
    return cell
  }

  // MARK: Функция для перехода к описанию станции по тапу на соответствующую cell
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let detailVC = segue.destination as! SelectedViewController
    
    if let selectedCell = sender as? TableViewCell {
      let indexPath = tableView.indexPath(for: selectedCell)!
      var selectedStation : Station
      if shouldShowSearchResults {
        
        selectedStation = filteredArray[(indexPath as NSIndexPath).section].stationsArray[(indexPath as NSIndexPath).row]
      }
      else {
        selectedStation = arrayOfStations[(indexPath as NSIndexPath).section].stationsArray[(indexPath as NSIndexPath).row]
      }
      detailVC.station = selectedStation
      detailVC.searchFlag = self.searchFlag
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
  
  // Mark: Функции для обработки формата json для станций отправления (loadListOfFrom), прибытия (loadListOfTo), сортировки по принципу Страна->Город->Станция
  
  func loadListOfFrom() {
    let filePath = Bundle.main.path(forResource: "allStations", ofType:"json") as String!
    let data = NSData(contentsOfFile: filePath!) as NSData!
    
    json = JSON(data: data as! Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
    
    for value in json["citiesFrom"].array!
    {
      var stat = Stations(country: value["countryTitle"].stringValue, city: value["cityTitle"].stringValue, stationsArray: [])
      
      for station in value["stations"].array! {
        
        let newStation = Station(country: station["countryTitle"].stringValue, city: station["cityTitle"].stringValue, region: station["regionTitle"].stringValue, name: station["stationTitle"].stringValue)
        stat.stationsArray.append(newStation)
      }
      arrayOfStations.append(stat)
    }
    for (index,stations) in arrayOfStations.enumerated() {
      let st = stations.stationsArray
      arrayOfStations[index].stationsArray = st.sorted(by: stationSort)
    }
    arrayOfStations.sort(by: sortByCountryAndCity)
  }
  
  func loadListOfTo() {
    let filePath = Bundle.main.path(forResource: "allStations", ofType:"json") as String!
    let data = NSData(contentsOfFile: filePath!) as NSData!
    
    json = JSON(data: data as! Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
    
    for value in json["citiesTo"].array!
    {
      var stat = Stations(country: value["countryTitle"].stringValue, city: value["cityTitle"].stringValue, stationsArray: [])
      
      for station in value["stations"].array! {
        
        let newStation = Station(country: station["countryTitle"].stringValue, city: station["cityTitle"].stringValue, region: station["regionTitle"].stringValue, name: station["stationTitle"].stringValue)
        stat.stationsArray.append(newStation)
      }
      arrayOfStations.append(stat)
    }
    for (index,stations) in arrayOfStations.enumerated() {
      let st = stations.stationsArray
      arrayOfStations[index].stationsArray = st.sorted(by: stationSort)
    }
    arrayOfStations.sort(by: sortByCountryAndCity)
  }
  
  // MARK: Функции сортировки
  
  func stationSort(_ s1: Station, _ s2: Station) -> Bool {
    return s1.name as String! < s2.name as String!
  }
  
  func sortByCountryAndCity(_ s1: Stations, _ s2: Stations) -> Bool {
    return s1.country == s2.country ? (s1.city < s2.city) : (s1.country < s2.country)
  }
  
  // Mark: Функция для инициализации CustomSearchController'а
  
  func configureCustomSearchController() {
    customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 50.0, width: tableView.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orange, searchBarTintColor: UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1))

    customSearchController.customSearchBar.placeholder = "Введите название станции..."

    tableView.tableHeaderView = customSearchController.customSearchBar
    
    customSearchController.customDelegate = self
  }
  
  // MARK: Функция UISearchResultsUpdating delegate
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchString = searchController.searchBar.text else {
      return
    }

    self.filteredArray.removeAll()
      
    for stations in self.arrayOfStations {
      var stat = Stations(country: stations.country, city: stations.city, stationsArray: [])
      stat.stationsArray.append(contentsOf:
        stations.stationsArray.filter({ (station) -> Bool in
          let stationText: NSString = station.name as NSString
            
          return (stationText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
      }))
      self.filteredArray.append(stat)
    }
    self.tableView.reloadData()
  }
  
  
  // MARK: Функции CustomSearchControllerDelegate
  
  func didStartSearching() {
    self.viewWillAppear(true)
    shouldShowSearchResults = true
    tableView.reloadData()
  }
  
  
  func didTapOnSearchButton() {
    if !shouldShowSearchResults {
      shouldShowSearchResults = true
      tableView.reloadData()
    }
  }
  
  
  func didTapOnCancelButton() {
    self.viewWillDisappear(true)
    shouldShowSearchResults = false
    tableView.reloadData()
  }
  
  
  func didChangeSearchText(_ searchText: String) {
    self.activityIndicatorView.startAnimating()
    
    DispatchQueue.main.async {  //поиск и обновление tableView происходит асинхронно
      self.filteredArray.removeAll()
      
      for stations in self.arrayOfStations {
        
        var stat = Stations(country: stations.country, city: stations.city, stationsArray: [])
         stat.stationsArray.append(contentsOf:
          stations.stationsArray.filter({ (station) -> Bool in
          let stationText: NSString = station.name as NSString
          
          return (stationText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        }))
        if (stat.stationsArray.count != 0) {
          self.filteredArray.append(stat)
        }
      }
      self.tableView.reloadData()
    }
    self.activityIndicatorView.stopAnimating()
  }

}
