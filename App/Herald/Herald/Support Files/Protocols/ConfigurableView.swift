//
//  ConfigurableView.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import Foundation

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
