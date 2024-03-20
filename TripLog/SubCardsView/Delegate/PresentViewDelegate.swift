//
//  SubCardScrollViewDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/17.
//

import UIKit

protocol PresentViewDelegate: AnyObject {
    
    func presentViewController(where viewController: UIViewController)
    func pushViewController(where viewController: UIViewController)
    
}
