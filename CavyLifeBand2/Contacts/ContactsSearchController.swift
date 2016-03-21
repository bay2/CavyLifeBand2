//
//  ContactsSearchController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsSearchController: UISearchController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var contactsSearchBar: ContactsSearchBar?
    var isSearching = false

    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        configureSearchBar()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchBar() {

        contactsSearchBar = ContactsSearchBar(frame: CGRectMake(0, 0, ez.screenWidth, 44))
        contactsSearchBar?.delegate = self

    }

    func configureSearchController() {

        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = false
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if  searchController.active {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {

        searchBar.setBackgroundImage(UIImage.imageWithColor(UIColor(named: .HomeViewMainColor), size: CGSizeMake(ez.screenWidth, 44)), forBarPosition: .Any, barMetrics: .Default)

        searchBar.showsCancelButton = true
        isSearching = true
        
        self.searchResultsUpdater?.updateSearchResultsForSearchController(self)
        
        return true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {

        searchBar.setBackgroundImage(UIImage.imageWithColor(UIColor(named: .ContactsSearchBarColor), size: CGSizeMake(ez.screenWidth, 44)), forBarPosition: .Any, barMetrics: .Default)
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        isSearching = false
        
        self.searchResultsUpdater?.updateSearchResultsForSearchController(self)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
