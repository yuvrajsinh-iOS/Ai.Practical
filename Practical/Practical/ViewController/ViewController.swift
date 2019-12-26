//
//  ViewController.swift
//  Practical
//
//  Created by MAC103 on 26/12/19.
//  Copyright © 2019 MAC103. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    // MARK: - IBOutlet -
    @IBOutlet private var collectionUserList: UICollectionView!

    // MARK: - Variables -
    private var nextOffset                  = 0
    private var hasMore                     = false
    private var arrayUserList:[UserModel]   = []

    //Mark:- Refresh controller
    lazy var refreshController:UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.collectionUserList.addSubview(refreshControl)
        return refreshControl
    }()

    // MARK: - Lifecycle Method -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }

    // MARK: - Custom Function -
    private func prepareView() {
        self.nextOffset = 0
        self.callUserListAPI()
        self.collectionUserList.register(UINib(nibName: ReuseIdentifier.userCollectionviewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.userCollectionviewCell.identifier)
        self.collectionUserList.register(UINib(nibName: ReuseIdentifier.headerCollectionViewCell.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCollectionViewCell.identifier)
        self.collectionUserList.register(UINib(nibName: ReuseIdentifier.footerCollectionViewCell.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReuseIdentifier.footerCollectionViewCell.identifier)
    }

    // MARK: - Action Method -
    @objc private func pullToRefresh(){
        self.nextOffset = 0
        self.callUserListAPI()
    }

    // MARK: - Webservice Method -
    private func callUserListAPI(){
        Web.sendRequest(.userList, query: "\(nextOffset)") { (result) in
            switch result {
            case .success(let response):
                if let data = response.data as? JSON {
                    self.hasMore = data["data"]["has_more"].boolValue
                    let userData = data["data"]["users"].arrayValue

                    if self.nextOffset == 0 {
                        self.arrayUserList.removeAll()
                        self.refreshController.endRefreshing()
                    }

                    for object in userData {
                        let userObject = UserModel.init(pareameter: object)
                        self.arrayUserList.append(userObject)
                    }
                    self.collectionUserList.reloadData()
                }
                
            case .failure(let error):
                var message = ""
                switch error {
                case .noInternet:
                    message = "No internet connection"
                default :
                    message = error.localizedDescription
                }
                Util.showAlet(message: message, view: self)
            }
        }
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.arrayUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayUserList[section].userItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.userCollectionviewCell.identifier, for: indexPath) as! UserCollectionviewCell
        cell.items = self.arrayUserList[indexPath.section].userItem[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.section == self.arrayUserList.count - 1) && hasMore && (indexPath.item == self.arrayUserList[indexPath.section].userItem.count - 1) {
            self.nextOffset += 10
            self.callUserListAPI()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifier.headerCollectionViewCell.identifier, for: indexPath) as! HeaderCollectionViewCell
            headerView.user = self.arrayUserList[indexPath.section]
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifier.footerCollectionViewCell.identifier, for: indexPath) as! FooterCollectionViewCell
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let arrayCount = self.arrayUserList[indexPath.section].userItem.count
        let width = collectionView.frame.width
        
        if arrayCount % 2 == 0 {
            let cellWidth = (width - 30)/2
            return CGSize(width: cellWidth, height: cellWidth)
        } else {
            if indexPath.item == 0{
                return CGSize(width: width - 20, height: width - 20)
            } else {
                let cellWidth = (width - 30)/2
                return CGSize(width: cellWidth, height: cellWidth)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        if (section == self.arrayUserList.count - 1) && hasMore {
            return CGSize(width: width, height: 70.0)
        }
        return CGSize(width: width, height: 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 70.0)
    }
    
}

