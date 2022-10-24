//
//  InitableView.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 25.01.2022.
//

import UIKit

class InitableUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init(fromCodeWithFrame frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }

    func initSetup() { }
}
