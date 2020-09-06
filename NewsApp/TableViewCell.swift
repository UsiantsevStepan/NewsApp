//
//  TableViewCell.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 06.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var sourceNameLabel: UILabel?
    @IBOutlet weak var newsTitleLabel: UILabel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.image = nil
    }
}
