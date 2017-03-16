//
//  FWItemScrollItemModel.swift
//
//  Created by FantasyWei on 2016/10/23.
//  Copyright © 2016年 FantasyWei. All rights reserved.
//

import UIKit

/**
 "bubble": null,
 "gray_switch": 0,
 "sequence": 100,
 "name": "美食",
 "brand_type": -1,
 "method": 1664316,
 "first_tag_codes": [],
 "code": 910,
 "gray_url": "http://p1.meituan.net/jungle/f179f80507e5a4240371cb29835f2b857439.png",
 "url": "http://p1.meituan.net/jungle/29516bc3473dc531e574a3a74d795e3b5489.png",
 "second_tag_codes": [],
 "skip_protocol": "meituanwaimai
 */

class FWItemScrollItemModel: NSObject {
    
    var url : String?
    var name : String?
    
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
