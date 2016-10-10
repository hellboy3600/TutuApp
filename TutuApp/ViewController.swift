//
//  ViewController.swift
//  TutuApp
//
//  Created by Сергей on 05/10/16.
//  Copyright © 2016 SM. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

  @IBOutlet weak var changeButton: UIButton!    //кнопка "Изменить" для обновления даты в dateLabel
  @IBOutlet weak var dateLabel: UILabel!        //отображение заданной даты
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var departure: UITextField!    //textField "Отправление", по нажатию на него происходит переход в TableViewControllerFrom с загрузкой таблицы из "citiesFrom"
  @IBOutlet weak var destination: UITextField!  //textField "Прибытие", по нажатию на него происходит переход в TableViewControllerFrom с загрузкой таблицы из "citiesTo"
  @IBOutlet var scheduleView: UIView!   //View для отображения расписания
  @IBOutlet weak var aboutView: UIView!   //View для отображения информации о приложении
  @IBOutlet weak var segmentedControl: UISegmentedControl!    //Выбор scheduleView/aboutView
  let formatter = DateFormatter()   //Задание отображения даты

  //Mark: Функция для задания даты в dateLabel по кнопке "Изменить"
  
  @IBAction func setDate(_ sender: AnyObject) {
    dateLabel.text = formatter.string(from: datePicker.date)
  }
  
  //Mark: Функции для перехода в TableViewControllerFrom по нажатию на поля "Прибытие" и "Отправление"
  
  @IBAction func startEditingFrom(_ sender: AnyObject) {
    viewWillAppear(true)
    performSegue(withIdentifier: "showFrom", sender: self)
  }
  
  @IBAction func startEditingTo(_ sender: AnyObject) {
    performSegue(withIdentifier: "showTo", sender: self)
    
  }
  
  //Mark: Функция для перехода между view "Расписание" и "О приложении"
  
  @IBAction func indexChanged(_ sender: AnyObject) {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      aboutView.isHidden = true
      scheduleView.isHidden = false
    case 1:
      aboutView.isHidden = false
      scheduleView.isHidden = true
    default:
      break;
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    aboutView.isHidden = true
    segmentedControl.backgroundColor = UIColor.orange
    navigationController?.navigationBar.barTintColor = UIColor.orange
    datePicker.setValue(UIColor.orange, forKey: "textColor")
    
    changeButton.layer.masksToBounds = true
    changeButton.layer.cornerRadius = 5
    
    formatter.dateFormat = "dd/MM/YYYY"                         //Задание даты в формате дд/ММ/ГГГГ
    dateLabel.text = formatter.string(from: datePicker.date)    //Задание даты в формате дд/ММ/ГГГГ
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  //Mark: Задание флага searchFlag для TableViewControllerFrom (инфо о флаге в TableViewControllerFrom)
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if (segue.identifier == "showFrom") {
      let tC = segue.destination as! TableViewControllerFrom
      tC.searchFlag = false
    } else if (segue.identifier == "showTo") {
      let tC = segue.destination as! TableViewControllerFrom
      tC.searchFlag = true
    }
  }
}

