//
//  ThisCell.swift
//  BeltReview
//
//  Created by Lyla Vela on 7/18/18.
//  Copyright © 2018 Lyla Vela. All rights reserved.
//

import UIKit

protocol ThisCellDelegate{
    func buttonChecked(from sender: ThisCell, indexPath: IndexPath)
}
class ThisCell: UITableViewCell {

    @IBOutlet weak var buttonChecked: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: ThisCellDelegate!
    var indexPathThisCell: IndexPath!
    
    @IBAction func buttonChecked(_ sender: UIButton) {
        delegate.buttonChecked(from: self, indexPath: indexPathThisCell)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
