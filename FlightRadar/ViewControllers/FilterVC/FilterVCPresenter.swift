//
//  FilterVCPresenter.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit

//MARK: FilterVC Presenter Delegate
protocol FilterVCPresenterDelegate {
    func filterVCPresenterShouldReloadTable(presenter:FilterVCPresenter , items:[FilterVCCellItem])
}

//MARK: FilterVC Cell Item {Struct}
struct FilterVCCellItem:ItemPresentable {
    let countryName:String
    let isSelected:Bool
    
    init(countryName:String , isSelected:Bool) {
        self.countryName = countryName
        self.isSelected = isSelected
    }
}

//MARK: FilterVC Presenter {Class}
class FilterVCPresenter: NSObject {
    fileprivate var arrCountries:[Country] = []
    fileprivate var arrFilterTableItems:[FilterVCCellItem] = []
    fileprivate var delegate:FilterVCPresenterDelegate!
    fileprivate(set) var searchKeyword:String?
    
    init(delegate:FilterVCPresenterDelegate) {
        self.delegate = delegate
    }
    
}

//MARK: Public Functions
extension FilterVCPresenter {
    func reloadItems() {
        self.arrFilterTableItems = self.arrCountries.filter { country -> Bool in
            guard let keyword = self.searchKeyword , keyword != "" else { return true }
            return country.name.lowercased().contains(keyword.lowercased())
        }.map { FilterVCCellItem(countryName: $0.name, isSelected: FILTER.arrSelectedCountries.contains($0.name)) }
        
        self.delegate.filterVCPresenterShouldReloadTable(presenter: self, items: self.arrFilterTableItems)
    }
    
    func itemSelected(item:ItemPresentable) {
        guard let cellItem:FilterVCCellItem = item as? FilterVCCellItem else { return }
        if FILTER.arrSelectedCountries.contains(cellItem.countryName) {
            FILTER.removeCountry(countryName: cellItem.countryName)
        }
        else {
            FILTER.addCountryToSelectedItems(countryName: cellItem.countryName)
        }
        self.reloadItems()
    }
}

//MARK: Search
extension FilterVCPresenter:UISearchResultsUpdating , UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchKeyword = searchController.searchBar.text
        self.reloadItems()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.reloadItems()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.reloadItems()
    }
    
}

//MARK: Dependency
extension FilterVCPresenter {
    func setDependencies(arrCountries:[Country]) {
        self.arrCountries = arrCountries
    }
}
