//
//  SubscrollViewDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/17.
//

import UIKit

protocol SubscrollViewDelegate: AnyObject {
    
    func presentViewController(who viewController: UIViewController)
    func pushMapViewController()
    
}
