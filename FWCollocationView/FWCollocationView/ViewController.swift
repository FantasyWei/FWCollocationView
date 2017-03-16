//
//  ViewController.swift
//  FWCollocationView
//
//  Created by FantasyWei on 2017/3/16.
//  Copyright © 2017年 FantasyWei. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collection: FWItemScrollView = FWItemScrollView()
        
        let urlString = "http://ofermdgmf.bkt.clouddn.com/collection.json"
        
        collection.requestItems(urlString: urlString, parameters: nil)
        
        collection.callBack = { (index:Int,model:FWItemScrollItemModel) ->Void in
            print(index,model.name!)
        }
        
        
        view.addSubview(collection)
        
        collection.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(kItemScrollViewHeight)
        }
        
    }
    
    
    
    
}


