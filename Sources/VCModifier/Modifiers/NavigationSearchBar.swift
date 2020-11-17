//
//  NavigationSearchBar.swift
//
//  Модификатор для добавления SearchBar в NavigationBar
//
//  Created by Дмитрий Папков on 17.11.2020.
//

import SwiftUI

public class NavigationSearchBar: NSObject, VCModifier, UISearchResultsUpdating {
    @Binding var searchBarText: String?
    @Binding var isSearching: Bool
    var placeholder: String?
    var hidesWhenScrolling: Bool
    
    public init(
        _ text: Binding<String?>,
        isSearching: Binding<Bool> = .constant(false),
        placeholder: String? = nil,
        hidesWhenScrolling: Bool = true
    ) {
        self._searchBarText = text
        self._isSearching = isSearching
        self.placeholder = placeholder
        self.hidesWhenScrolling = hidesWhenScrolling
    }
    
    public func make(_ vc: UIViewController) {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = placeholder
        searchController.obscuresBackgroundDuringPresentation = false
        
        vc.navigationItem.hidesSearchBarWhenScrolling = hidesWhenScrolling
        vc.navigationItem.searchController = searchController
    }
    
    public func update(_ vc: UIViewController) {}
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.searchBarText = searchController.searchBar.text
        self.isSearching = searchController.isActive
    }
}
