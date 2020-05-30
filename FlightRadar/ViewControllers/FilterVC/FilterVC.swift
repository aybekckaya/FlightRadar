//
//  FilterVC.swift
//  FlightRadar
//
//  Created by aybek can kaya on 29.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    fileprivate(set) var tableViewStates:Table!
    fileprivate var presenter:FilterVCPresenter!
}

//MARK: LifeCycle
extension FilterVC {
    override func viewDidLoad() {
           super.viewDidLoad()
           self.setUpUI()
           self.configureTableView()
           self.presenter.reloadItems()
       }
}

//MARK: TableView
extension FilterVC {
    fileprivate func configureTableView() {
        self.tableViewStates.tableCell { (indexPath, item) -> (UITableViewCell) in
            let cell:FilterCell = self.tableViewStates.dequeueReusableCell(withIdentifier: FilterCell.identifier) as! FilterCell
            let cellItem = item as! FilterVCCellItem
            cell.updateCell(countryName: cellItem.countryName, isSelected: cellItem.isSelected)
            return cell
        }.tableCellSelected { (indexPath, item) in
            self.tableViewItemSelected(item: item)
        }
    }
    
    private func tableViewItemSelected(item:ItemPresentable) {
        self.presenter.itemSelected(item: item)
     }
}

//MARK: Set Up UI
extension FilterVC {
    fileprivate func setUpUI() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1843137255, green: 0.5058823529, blue: 0.7176470588, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.5058823529, blue: 0.7176470588, alpha: 1)
        self.title = "Filter"
        
        self.tableViewStates = Table.view(items: [], cellIdentifiers: [FilterCell.identifier])
        self.tableViewStates.backgroundColor = UIColor.white
        self.view.addSubview(self.tableViewStates)
        self.tableViewStates.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewStates.fitIntoSuperView()

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self.presenter
        search.delegate = self.presenter
        search.searchBar.tintColor = UIColor.white
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "type country name"
        search.searchBar.searchTextField.font = Font.Museo300.font(size: 15)
        navigationItem.searchController = search
    }
}


// MARK: Dependency
extension FilterVC {
    func setDependency(arrCountries:[Country]) {
        if self.presenter == nil {
            self.presenter = FilterVCPresenter(delegate: self)
        }
        self.presenter.setDependencies(arrCountries: arrCountries)
    }
}

//MARK: FilterVCPresenter Delegate
extension FilterVC:FilterVCPresenterDelegate {
    func filterVCPresenterShouldReloadTable(presenter: FilterVCPresenter, items: [FilterVCCellItem]) {
        self.tableViewStates.reload(items: items)
    }
    
    
}
