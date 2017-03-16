//
//  FWCollectionView.swift
//
//  Created by FantasyWei on 2016/10/23.
//  Copyright © 2016年 FantasyWei. All rights reserved.
//

import UIKit
import SnapKit

let itemCountPreline:CGFloat = 4     // 每一行几个 item
let itemcount:Int = Int(itemCountPreline) * 2
let kMargin : CGFloat = 10           // 间距 自己设置

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kColloctionItemWidth :CGFloat = ((kScreenWidth - itemCountPreline * 2 * kMargin) / itemCountPreline)
let kItemScrollViewHeight :CGFloat = 5 * kMargin + 2 * kColloctionItemWidth

class FWItemScrollView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    typealias scrollViewCallBack = (_ index:Int,_ model:FWItemScrollItemModel)->()
    
    var callBack:scrollViewCallBack?
    
    private static let CollectionCellID = "FWHomeGuideCollectionViewCell"

    func requestItems(method: FWRequestMethod? = .GET,urlString :String,parameters :[String:AnyObject]?){
        
        FWNetWorkTools.sharedTools.request(method: method, urlString: urlString, parameters: parameters) { (responsed, error) in
            if responsed != nil{
                let dataDict = responsed as! [String:AnyObject]
                let dataInnerDict = dataDict["data"] as! [String:AnyObject]
                //保证 dataArray 中 存放的是需要的数据
                let dataArr = dataInnerDict["primary_filter"] as! [AnyObject]
                for dataList in dataArr{
                    let listDict = dataList as! [String:AnyObject]
                    let itemModel = FWItemScrollItemModel(dict:listDict)
                    self.dataArray.append(itemModel)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.setupScrollView()
                    self?.setCollectionView()
                    self?.setPageControll()
                }
            }
        }
    }
    
    private func setupScrollView(){

        let count : Int = dataArray.count / itemcount
        
        collectionCount = dataArray.count % itemcount == 0 ? count : count + 1
        
        scrollView.contentSize = CGSize(width: CGFloat(collectionCount) * kScreenWidth, height: 0)
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        scrollView.contentOffset = CGPoint.zero
        
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.isPagingEnabled = true
        
        scrollView.delegate = self
        
        scrollView.isScrollEnabled = true
        
        scrollView.bounces = true
        
    }
    private func setPageControll(){
        
        pageControll.numberOfPages = collectionArrar.count

        pageControll.currentPage = 0
        
        pageControll.currentPageIndicatorTintColor = UIColor.orange
        
        pageControll.pageIndicatorTintColor = UIColor.gray
        
        addSubview(pageControll)
        
        bringSubview(toFront: pageControll)
        
        pageControll.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp.bottom).offset(-20)
            make.width.equalTo(100)
        }

    }
    
    // 动态改变 pageControll
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offX:CGFloat = scrollView.contentOffset.x
        var index:Int = 0
        if offX >= kScreenWidth * 0.5{
            index = index + 1
        }else if offX < kScreenWidth * 0.5 {
            index = index - 1
        }
        pageControll.currentPage = index
    }
    
    private func setCollectionView(){
        for i in 0..<collectionCount {
            let offX = CGFloat(i) * scrollView.frame.size.width
            
            let collection = UICollectionView(frame: CGRect(x: offX, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height), collectionViewLayout: collectionFlowLayout)
            
            collection.register(FWHomeGuideCollectionViewCell.self, forCellWithReuseIdentifier: FWItemScrollView.CollectionCellID)
            collection.backgroundColor = UIColor.white
            collection.layer.cornerRadius = 20
            collection.layer.masksToBounds = true
            scrollView.addSubview(collection)
            collection.delegate = self
            collection.dataSource = self
            
            collectionArrar.append(collection)
        }
    }
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemcount
    }
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FWItemScrollView.CollectionCellID, for: indexPath) as! FWHomeGuideCollectionViewCell

            for index in 0..<collectionArrar.count{ //0--1
                if indexPath.item + index * itemcount < dataArray.count{
                if collectionView == collectionArrar[index]{
                    cell.model = dataArray[indexPath.item + index * itemcount]
                }
            }
        }
        
        
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for index in 0..<collectionArrar.count{ //0--1
            if indexPath.item + index * itemcount < dataArray.count{
                if collectionView == collectionArrar[index]{
                    let model = dataArray[indexPath.item + index * itemcount]
                    
                    if callBack != nil {
                        callBack!(indexPath.item + index * itemcount,model)
                    }
                }
            }
        }

    }
    
    // 懒加载控件
    private var dataArray = [FWItemScrollItemModel]()
    private var collectionArrar = [UICollectionView]()
    private var collectionCount : Int = 0
    private lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor(red: 253 / 255.0, green: 246 / 255.0, blue: 228 / 255.0, alpha: 1)
        scroll.layer.cornerRadius = 20
        scroll.layer.masksToBounds = true
        scroll.delegate = self
        self.backgroundColor = UIColor.lightGray
        self.addSubview(scroll)
        return scroll
    }()
    private lazy var collectionFlowLayout : UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kColloctionItemWidth, height: kColloctionItemWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        
        return flowLayout
    }()
    private lazy var pageControll : UIPageControl={
        let page = UIPageControl()
        return page
    }()
    // 设置 frame
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(-kMargin)
        }
        
    }
    
}
