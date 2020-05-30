//
//  Tabl.swift
//  ringtonemp3
//
//  Created by aybek can kaya on 25.09.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit


protocol ItemPresentable {}

class Table: UITableView , UITableViewDataSource , UITableViewDelegate , UIScrollViewDelegate {
   
    private var items:[ItemPresentable] = []
    
    private var tableCellHeightClosure:((IndexPath , ItemPresentable)->(CGFloat))? = nil
    private var tableCellHeight:CGFloat? = nil
    private var tableCellAtRow:((IndexPath , ItemPresentable)->(UITableViewCell))? = nil
    private var tableCellSelectedClosure:((IndexPath , ItemPresentable)->())? = nil
    private var tableViewDidScroll:((CGPoint)->())? = nil
    
    fileprivate init(items:[ItemPresentable] , cellIdentifiers:[String] ,  tableCellHeight:CGFloat? = nil ) {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain)
        self.items = items
        self.tableCellHeight = tableCellHeight
        
        self.separatorStyle = .singleLine
        self.separatorColor = UIColor.black.withAlphaComponent(0.4)
        cellIdentifiers.forEach{
            let nib:UINib = UINib(nibName: $0, bundle: nil)
            self.register(nib, forCellReuseIdentifier: $0)
        }
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView(frame: .zero)
        
    }
    
    func reload(items:[ItemPresentable]) {
        self.items = items
        DispatchQueue.main.async {
             self.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     @discardableResult
    func tableCellHeight(closure:@escaping (IndexPath , ItemPresentable)->(CGFloat))->Table {
        self.tableCellHeightClosure = closure
        return self
    }
    
    @discardableResult
    func tableCell(closure:@escaping (IndexPath , ItemPresentable)->(UITableViewCell))->Table {
        self.tableCellAtRow = closure
        return self
    }
    
    func tableCellSelected(closure:@escaping (IndexPath , ItemPresentable)->()) {
        self.tableCellSelectedClosure = closure
    }
    
    func tableDidScroll(closure : @escaping (CGPoint)->()) {
        self.tableViewDidScroll = closure
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeight = self.tableCellHeight {
            return cellHeight
        }
        else if let cellHeightClosure = self.tableCellHeightClosure {
            return cellHeightClosure(indexPath , self.items[indexPath.row])
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentElement:ItemPresentable = self.items[indexPath.row]
        guard let cellClosure = self.tableCellAtRow else { fatalError() }
        return cellClosure(indexPath , currentElement)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let closure = self.tableCellSelectedClosure else { return }
        let currentElement:ItemPresentable = self.items[indexPath.row]
        closure(indexPath , currentElement)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let closure = self.tableViewDidScroll else { return }
        closure(scrollView.contentOffset)
    }
    
    
    static func view(items:[ItemPresentable] , cellIdentifiers:[String])->Table {
        return Table(items: items ,cellIdentifiers: cellIdentifiers)
    }
    
    static func view(items:[ItemPresentable] , cellIdentifiers:[String] , cellHeight:CGFloat)->Table {
        return Table(items: items, cellIdentifiers: cellIdentifiers , tableCellHeight: cellHeight)
    }
    
}



