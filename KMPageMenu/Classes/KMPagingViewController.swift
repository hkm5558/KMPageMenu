//
//  KMPagingViewController.swift
//  KMPagingViewControllerDemo
//
//  Created by KM on 2018/3/16.
//  Copyright © 2018年 KM. All rights reserved.
//

import UIKit

// MARK:- 代理协议
public protocol KMPagingViewControllerDelegate: NSObjectProtocol {
    // MARK: 当前子控制器的下标
    func pagingController(_ pagingController: KMPagingViewController,
                        didFinish currentViewController: UIViewController,
                        currentIndex: Int)
}

public class KMPagingViewController: UIViewController {

    public typealias DidFinishPagingCallBack = ((_ currentViewController: UIViewController, _ currentIndex: Int) -> Void)
    // MARK:- 代理
    public weak var delegate: KMPagingViewControllerDelegate?
    
    public var didFinishPagingCallBack : DidFinishPagingCallBack?
    
    // MARK:- 定义属性
    /// 所有子控制器
    public var viewControllers: [UIViewController] = [UIViewController]()

    /// 是否开启滚动
    public var isScrollEnable: Bool = true {
        didSet {
            if let page = pageVc { page.setScrollEnable(isScrollEnable) }
        }
    }
    
    fileprivate var currentIndex: Int = 0 {
        didSet {
            let vc = viewControllers[currentIndex]
            if let delegate = delegate {
                delegate.pagingController(self, didFinish: vc, currentIndex: currentIndex)
            }
            
            if let callBack = didFinishPagingCallBack {
                callBack(vc, currentIndex)
            }
        }
    }
    
    fileprivate var pageVc: UIPageViewController!
    
    // MARK:- init
    public init(viewControllers: [UIViewController]) {
        
        super.init(nibName: nil, bundle: nil)
        // 存储
        self.viewControllers = viewControllers
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK:- 生命周期
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 初始化
        setup()
    }
}

// MARK:- 初始化
fileprivate extension KMPagingViewController {
    
    /// 初始化page控制器
    fileprivate func setup() {
        
        guard   viewControllers.isEmpty == false,
                let firstVC = viewControllers.first
        else    { return }
        
        let options: [String : Any] = [UIPageViewControllerOptionSpineLocationKey : NSNumber(integerLiteral: UIPageViewControllerSpineLocation.none.rawValue)]
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        page.delegate = self
        page.dataSource = self
        page.setViewControllers([firstVC],
                                direction: .forward,
                                animated: false,
                                completion: nil)
        page.view.frame = self.view.bounds
        pageVc = page

        self.view.addSubview(page.view)
        self.addChildViewController(pageVc)
        pageVc.didMove(toParentViewController: self)
    }
}

// MARK:- 向外提供的方法
public extension KMPagingViewController {
    // MARK: 设置当前子控制器
    public func pagingToViewController(at index: NSInteger, animated: Bool = true) {
        
        guard currentIndex != index else { return }
        
        let direction: UIPageViewControllerNavigationDirection = index > currentIndex ? .forward : .reverse
        // 避免在切换动画进行中又进行反复切换
        pageVc.view.isUserInteractionEnabled = false
        pageVc.setViewControllers([viewControllers[index]],
                                  direction: direction,
                                  animated: animated,
                                  completion: { [weak self] (_) in
            self?.currentIndex = index
            // 切换完成重新开启交互
            self?.pageVc.view.isUserInteractionEnabled = true
        })
    }
    /// 获取当前子控制器的角标
    func indexForViewController(controller: UIViewController) -> NSInteger {
        return viewControllers.index(of: controller)!
    }
}

// MARK: 代理与数据源
extension KMPagingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    /// 前一个控制器
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewControllers.index(of: viewController) else {return nil}
        let beforeIndex = index - 1
        if beforeIndex < 0 { return nil }
        return viewControllers[beforeIndex]
    }
    
    /// 后一个控制器
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.index(of: viewController) else {return nil}
        let afterIndex = index + 1
        if afterIndex > viewControllers.count - 1 { return nil }
        return viewControllers[afterIndex]
    }
    
    /// 返回控制器数量
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    /// 切换到另一个控制器
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.first else {return}
        let index = indexForViewController(controller: vc)
        currentIndex = index
    }
}


fileprivate extension UIPageViewController {
    
    /// UIPageViewController 是否开启滚动
    ///
    /// - Parameter enable: 是否开启滚动
    func setScrollEnable(_ enable: Bool) {
        for aView in self.view.subviews {
            if let aClass = NSClassFromString("UIScrollView"),
                aView.isKind(of: aClass) {
                if let scroll = aView as? UIScrollView {
                    scroll.isScrollEnabled = enable
                    break;
                }
            }
        }
    }
}
