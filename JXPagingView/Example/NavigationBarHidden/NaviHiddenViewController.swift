//
//  NaviHiddenViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class NaviHiddenViewController: BaseViewController {
    var naviBGView: UIView?
    var pinHeaderViewInsetTop: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.automaticallyAdjustsScrollViewInsets = false

        var topSafeMargin: CGFloat = 20
        if #available(iOS 11.0, *) {
            if UIScreen.main.bounds.size.height == 812 {
                topSafeMargin = UIApplication.shared.keyWindow!.safeAreaInsets.top
            }
        }
        let naviHeight = topSafeMargin + 44
        pinHeaderViewInsetTop = naviHeight

        //自定义导航栏
        naviBGView = UIView()
        naviBGView?.alpha = 0
        naviBGView?.backgroundColor = UIColor.white
        naviBGView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight)
        self.view.addSubview(naviBGView!)

        let naviTitleLabel = UILabel()
        naviTitleLabel.text = "导航栏隐藏"
        naviTitleLabel.textAlignment = .center
        naviTitleLabel.frame = CGRect(x: 0, y: topSafeMargin, width: self.view.bounds.size.width, height: 44)
        naviBGView?.addSubview(naviTitleLabel)

        let back = UIButton(type: .system)
        back.setTitle("返回", for: .normal)
        back.frame = CGRect(x: 12, y: topSafeMargin, width: 44, height: 44)
        back.addTarget(self, action: #selector(naviBack), for: .touchUpInside)
        naviBGView?.addSubview(back)

        //让mainTableView可以显示范围外
        self.pagingView.mainTableView.clipsToBounds = false
        //让头图的布局往上移动naviHeight高度，填充导航栏下面的内容
        self.userHeaderView.imageView.frame = CGRect(x: 0, y: -naviHeight, width: self.view.bounds.size.width, height: naviHeight + JXTableHeaderViewHeight)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //pagingView依然是从导航栏下面开始布局的
        self.pagingView.frame = CGRect(x: 0, y: pinHeaderViewInsetTop, width: self.view.bounds.size.width, height: self.view.bounds.size.height - pinHeaderViewInsetTop)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc func naviBack(){
        self.navigationController?.popViewController(animated: true)
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        let thresholdDistance: CGFloat = 100
        var percent = scrollView.contentOffset.y/thresholdDistance
        percent = max(0, min(1, percent))
        naviBGView?.alpha = percent
    }

}
