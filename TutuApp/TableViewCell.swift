//
//  TableViewCell.swift
//  TutuApp
//
//  Created by Сергей on 07/10/16.
//  Copyright © 2016 SM. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {      //Cell для TableViewFrom

  @IBOutlet weak var cityText: UILabel!   //текст города
  @IBOutlet weak var labelText: UILabel!  //текст станции
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
