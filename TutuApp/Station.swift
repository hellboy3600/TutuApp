//
//  Station.swift
//  TutuApp
//
//  Created by Сергей on 07/10/16.
//  Copyright © 2016 SM. All rights reserved.
//

import Foundation

struct Station {    //структура для хранения значений объекта json-массива stations []
  var country : String
  var city : String
  var region : String
  var name : String
}

struct Stations {   //структура для хранения значений объекта json-массива citiesFrom [] или citiesTo []
  var country : String
  var city : String
  var stationsArray : [Station]
}
