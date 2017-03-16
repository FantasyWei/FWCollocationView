//
//  FWHomeGuideCollectionViewCell.swift
//
//  Created by FantasyWei on 2016/10/23.
//  Copyright © 2016年 FantasyWei. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class FWHomeGuideCollectionViewCell: UICollectionViewCell {
    
        let margin = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        addSubview(imageViews)
        addSubview(label)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViews.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(margin)
            make.trailing.equalTo(self).offset(-margin)
            make.height.equalTo(imageViews.snp.width)
        }
        label.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(imageViews)
            make.bottom.equalTo(self)
            make.top.equalTo(imageViews.snp.bottom).offset(3)
        }
    }
    // set 方法
    var model: FWItemScrollItemModel? {
        didSet{
            let url:URL = URL(string: (model?.url)!)!
            imageViews.sd_setImage(with: url, completed: nil)
            
            let text = model?.name
            
            label.text = text
            
        }
    }
    // 懒加载
    private lazy var imageViews: UIImageView = {
        return UIImageView()
    }()
    private lazy var label:UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}
