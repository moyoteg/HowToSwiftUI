//
//  CurlPage.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/25/21.
//

import UIKit
import SwiftUI
import Utilities

struct CurlPage: View {
    
    @State var currentPage: Int = 0
    
    var pages = [
        Color(.systemRed),
        Color(.systemGreen),
        Color(.systemBlue),
    ]
    
    var body: some View {
        PageView(pages: pages, currentPage: $currentPage, transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }
    
}


struct PageView<Page: View>: UIViewControllerRepresentable {
    
    var pages: [Page]
    @Binding var currentPage: Int
    var transitionStyle: UIPageViewController.TransitionStyle
    var navigationOrientation: UIPageViewController.NavigationOrientation
    
    public init(pages: [Page],
                currentPage: Binding<Int>,
                transitionStyle: UIPageViewController.TransitionStyle = .scroll,
                navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal) {
        self.pages = pages
        self._currentPage = currentPage
        self.transitionStyle = transitionStyle
        self.navigationOrientation = navigationOrientation
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: nil)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        var direction: UIPageViewController.NavigationDirection = .forward
        var animated: Bool = false
        
        if let previousViewController = pageViewController.viewControllers?.first,
            let previousPage = context.coordinator.controllers.firstIndex(of: previousViewController) {
            direction = (currentPage >= previousPage) ? .forward : .reverse
            animated = (currentPage != previousPage)
        }
        
        let currentViewController = context.coordinator.controllers[currentPage]
        pageViewController.setViewControllers([currentViewController], direction: direction, animated: animated)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, pages: pages)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var parent: PageView
        var controllers: [UIViewController]

        init(parent: PageView, pages: [Page]) {
            self.parent = parent
            self.controllers = pages.map({
                let hostingController = UIHostingController(rootView: $0)
                hostingController.view.backgroundColor = .clear
                return hostingController
            })
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return nil
            }
            return controllers[safe: index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return nil
            }
            return controllers[safe: index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let currentViewController = pageViewController.viewControllers?.first,
                let currentIndex = controllers.firstIndex(of: currentViewController)
            {
                parent.currentPage = currentIndex
            }
        }
    }
}



//struct PageViewController: UIViewControllerRepresentable {
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UIPageViewControllerDataSource {
//        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//            guard let index = self.parent.controllers.firstIndex(of: viewController) else { return nil }
//            if index == 0 {
//                return self.parent.controllers.last
//            }
//            return self.parent.controllers[index - 1]
//        }
//
//        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//            guard let index = self.parent.controllers.firstIndex(of: viewController) else { return nil }
//            if index == self.parent.controllers.count - 1 {
//                return self.parent.controllers.first
//            }
//            return self.parent.controllers[index + 1]
//        }
//
//
//        let parent: PageViewController
//
//        init(_ parent: PageViewController) {
//            self.parent = parent
//        }
//    }
//
//    func makeUIViewController(context: Context) -> UIPageViewController {
//        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
//        pageViewController.dataSource = context.coordinator
//        return pageViewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
//        uiViewController.setViewControllers(controllers, direction: .forward, animated: true)
//    }
//
//    typealias UIViewControllerType = UIPageViewController
//
//    var controllers: [UIViewController] = []
//
//}
//
//struct TitlePage: View {
//    var title: String
//
//    var body: some View {
//        Text(title)
//    }
//}
//
//struct ContainerView: View {
//
//    var controllers: [UIHostingController<TitlePage>]
//
//    init(_ titles: [String]) {
//        self.controllers = titles.map { UIHostingController(rootView: TitlePage(title: $0)) }
//    }
//
//    var body: some View {
//        PageViewController(controllers: self.controllers)
//    }
//}
