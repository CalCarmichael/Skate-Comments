//
//  SearchViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 22/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
   
        //Search Bar UI
        
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search Skaters!"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    //Handle search requests after search button clicked (self explanitory)
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
        
    }
    
    //Register what users type in so I can query it later on
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
    
}
