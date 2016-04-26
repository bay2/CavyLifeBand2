//
//  ContactsAddFriendVC_ExtSearch.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit

// MARK: - 搜索功能代理
extension ContactsAddFriendVC: UISearchResultsUpdating, ContactsSearchControllerDelegate {
    
    /**
     隐藏按钮视图
     
     - parameter hidden: 是否隐藏
     */
    func setButtonViewHidden(hidden: Bool) {
        
        self.navigationController?.setNavigationBarHidden(hidden, animated: true)
        
        if hidden {
            
            self.scrollView.snp_remakeConstraints { make -> Void in
                make.top.equalTo(buttonView.snp_bottom).offset(20)
            }
            
            self.buttonView.snp_remakeConstraints { make -> Void in
                make.top.equalTo(self.view).offset(-100)
            }
            
            
        } else {
            
            self.scrollView.snp_remakeConstraints { make -> Void in
                make.top.equalTo(buttonView.snp_bottom)
            }
            
            self.buttonView.snp_remakeConstraints { make -> Void in
                make.top.equalTo(self.view)
            }
            
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    /**
     刷新搜索结果
     
     - parameter searchController:
     */
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if self.searchController.isSearching {
            
            beginSearch()
            
        } else {
            
            cancelSearch()
            
        }
        
    }
    
    /**
     点击搜索按钮
     */
    func didTapOnSearchButton() {
        
        loadSearchData(self.searchController.contactsSearchBar?.text ?? "")
        
    }
    
    /**
     加载搜索返回结果数据
     
     - parameter searchText: 搜索文本
     */
    func loadSearchData(searchText: String) {
        
        guard let searchViewModel = tableDictionary[searchTableView] as? ContactsSearchFriendData else {
            return
        }
        
        searchViewModel.searchText = searchText
        searchViewModel.loadData()
        
    }
    
    /**
     取消搜索
     */
    func cancelSearch() {
        
        guard let searchViewModel = tableDictionary[searchTableView] as? ContactsSearchFriendData else {
            return
        }
        
        searchViewModel.items.removeAll()
        
        setButtonViewHidden(false)
        self.scrollView.scrollEnabled = true
        self.searchController.contactsSearchBar?.text = ""
        recommendView.tableView.hidden = false
        searchTableView.hidden = true
        
    }
    
    /**
     开始搜索
     */
    func beginSearch() {
        
        setButtonViewHidden(true)
        self.scrollView.scrollEnabled = false
        searchTableView.hidden = false
        recommendView.tableView.hidden = true
        
        searchTableView.reloadData()
        
    }
    
}
