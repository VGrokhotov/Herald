//
//  SideMenuVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 28.06.2021.
//

import UIKit

protocol SideMenuVCDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuVC: UIViewController {
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!

    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: Strings.profileSideMenuTitle),
        SideMenuModel(icon: UIImage(systemName: "slider.horizontal.3")!, title: Strings.settingsSideMenuTitle),
        SideMenuModel(icon: UIImage(systemName: "return")!, title: Strings.logoutSideMenuTitle)
    ]
    
    var delegate: SideMenuVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.sideMenuTableView.separatorStyle = .none

        self.footerLabel.textColor = UIColor.black
        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.footerLabel.text = Strings.developedByTitle

        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)

        self.sideMenuTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}

// MARK: - UITableViewDataSource

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        
        cell.configure(with: menu[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.selectedCell(indexPath.row)
    }
}
