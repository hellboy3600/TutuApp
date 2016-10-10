//
//  CustomSearchBar.swift
//  TutuApp
//
//  Created by Сергей on 06/10/16.
//  Copyright © 2016 SM. All rights reserved.
//


import UIKit

class CustomSearchBar: UISearchBar {
  
  var preferredFont: UIFont!
  var preferredTextColor: UIColor!

  //Mark: Функция отрисовки search field

  override func draw(_ rect: CGRect) {
    if let index = indexOfSearchFieldInSubviews() {    //  Нахождение индекса search field в search bar subviews

      let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField

      searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 20.0, height: frame.size.height - 10.0)

      searchField.font = preferredFont
      searchField.textColor = preferredTextColor

      searchField.backgroundColor = barTintColor
    }
    
    let startPoint = CGPoint(x: 0.0, y: frame.size.height)
    let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
    let path = UIBezierPath()
    path.move(to: startPoint)
    path.addLine(to: endPoint)
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = preferredTextColor.cgColor
    shapeLayer.lineWidth = 2.5
    
    layer.addSublayer(shapeLayer)
    
    super.draw(rect)
  }
  
  //Mark: инициализация search field
  
  init(frame: CGRect, font: UIFont, textColor: UIColor) {
    super.init(frame: frame)
    
    self.frame = frame
    preferredFont = font
    preferredTextColor = textColor
    
    searchBarStyle = UISearchBarStyle.prominent
    isTranslucent = false
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  //Mark: Функция для нахождения индекса search field
  
  func indexOfSearchFieldInSubviews() -> Int! {

    var index: Int!
    let searchBarView = subviews[0]
    let per = searchBarView.subviews.count + 1
    for i in 0 ..<  per {
      if searchBarView.subviews[i].isKind(of: UITextField.self) {
        index = i
        break
      }
    }
    
    return index
  }
}
