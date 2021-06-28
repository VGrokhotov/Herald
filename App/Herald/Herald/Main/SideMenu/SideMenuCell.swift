//
//  SideMenuCell.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 28.06.2021.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.iconImageView.tintColor = .black
        self.titleLabel.textColor = .black
    }
}

extension SideMenuCell: ConfigurableView {
    typealias ConfigurationModel = SideMenuModel
    
    func configure(with model: SideMenuModel) {
        iconImageView.image = model.icon
        titleLabel.text = model.title
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9882436395, green: 0.5888276696, blue: 0.2538208663, alpha: 1)
        selectedBackgroundView = view
    }
}
