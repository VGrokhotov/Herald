//
//  BaseEmptyDataView.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 25.01.2022.
//

import UIKit

class BaseEmptyDataView: InitableUIView, EmptyDataView {
    
    var messageTitle: String = Strings.defaultEmptyDataMessage { didSet { updateMessageLabel() } }
    var noteTitle: String = Strings.defaultEmptyDataNote { didSet { updateNoteLabel() } }
    var outerInsets: LayoutInsets { .insets(top: nil, left: 36, bottom: nil, right: 36) }
    
    private let messageLabel = UILabel()
    private let noteLabel = UILabel()
    
    override func initSetup() {
        super.initSetup()
        
        backgroundColor = .clear
        
        setupView()
        
        updateMessageLabel()
        updateNoteLabel()
    }
    
    private func setupView() {
        setupMessageLabel()
        setupNoteLabel()
        setupStackView()
    }
    
    private func setupMessageLabel() {
        messageLabel.font = .mySystemFont(ofSize: 28)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
    }
    
    private func setupNoteLabel() {
        noteLabel.font = .mySystemFont(ofSize: 16)
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [messageLabel, noteLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        
        layoutSubview(stackView, with: .zero)
    }
    
    private func updateMessageLabel() {
        messageLabel.text = messageTitle
    }
    
    private func updateNoteLabel() {
        noteLabel.text = noteTitle
    }
}
