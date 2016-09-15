//
//  SearchPageViewController.swift
//  Yelperizer
//
//  Created by ishansaksena on 9/5/16.
//  Copyright © 2016 ishansaksena. All rights reserved.
//

/*
 Manages all the pages to collect search parameters that may include
 1. SearchTerm
 2. Location
 3. Limit on number of options
 
 It instantiates the relevant view controllers for the above
 */

import UIKit

class SearchPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        
        // Start on the first view controller in the array
        if let SearchPageVC = orderedViewControllers.first {
            self.setViewControllers([SearchPageVC],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
        // Receive notification from SearchTermViewController to go to the next page
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(SearchPageViewController.secondPage),
                                                         name: "enteredSearchTerm",
                                                         object: nil)
        
        // Receive notification from SearchTermViewController to go to the next page
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(SearchPageViewController.thirdPage),
                                                         name: "enteredLimit",
                                                         object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sets the current page to the second page in the array
    func secondPage() {
        self.setViewControllers([orderedViewControllers[1]],
                           direction: .Forward,
                           animated: true,
                           completion: nil)
    }
    
    // Sets the current page to the third page in the array
    func thirdPage(){
        self.setViewControllers([orderedViewControllers[2]],
                           direction: .Forward,
                           animated: true,
                           completion: nil)
    }
    
    // Returns the view controllers for the page view controller
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newSearchViewController("SearchTerm"),
                self.newSearchViewController("Limit"),
                self.newSearchViewController("Location")]
    }()
    
    // Helper method to instantiate view controllers
    private func newSearchViewController(page: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(page)ViewController")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Data Source
extension SearchPageViewController: UIPageViewControllerDataSource {
    
    // Returns the previous page
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        // Check if the viewController is supposed to be in this page view controller
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        // Hasn't reached the end of all the pages
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    // Returns the next page
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        // Check if the viewController is supposed to be in this page view controller
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // For progress dots
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            firstViewControllerIndex = orderedViewControllers.indexOf(firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
}




