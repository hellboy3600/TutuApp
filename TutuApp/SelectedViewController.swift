//
//  SelectedViewController.swift
//  TutuApp
//
//  Created by Сергей on 07/10/16.
//  Copyright © 2016 SM. All rights reserved.
//

import UIKit

//Mark: класс для отображения точного адреса станции (переход по тапу на cell)

class SelectedViewController: UIViewController {

  var station : Station!  //информация о данной станции
  var searchFlag : Bool!  //флаг определяет, в какое поле записать name в ViewController (Отправление или Прибытие)

  @IBOutlet weak var chooseButton: UIButton!  //кнопка выбора данной станции для передачи в ViewController
  @IBOutlet weak var infoLabel: UILabel!    //отображает подробную информацию о станции
  
  //Mark: по нажатию на кнопку "Выбрать" перенаправляет на ViewController и в зависимости от значения флага заполняет нужное поле
  
  @IBAction func chooseButton(_ sender: AnyObject) {
    let VC = self.navigationController?.viewControllers[0] as! ViewController
    if (!searchFlag) {
      VC.departure.text = station.name
    } else {
      VC.destination.text = station.name
    }
    
    navigationController!.popToRootViewController(animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.tintColor = UIColor.black

    infoLabel.layer.masksToBounds = true
    infoLabel.layer.cornerRadius = 5
    
    chooseButton.layer.masksToBounds = true
    chooseButton.layer.cornerRadius = 5
    
    if (station.region=="") {   //Отображение подробной информации в зависимости от того, указан ли регион, или нет
      infoLabel.text = station.name + "\n" + station.city + "\n" + station.country
    } else {
      infoLabel.text = station.name + "\n" + station.city + "\n" + station.region + "\n" + station.country
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

}
