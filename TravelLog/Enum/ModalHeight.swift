//
//  ModalHeight.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/27.
//

import UIKit

enum ModalHeight {
    case max
    case mideum
    case low
    case min
    
    func height(of view: UIView) -> CGFloat {
        switch self {
        case .max:
            return view.frame.height * 0.875
        case .mideum:
            return view.frame.height * 0.45
        case .low:
            return view.frame.height * 0.25
        case .min:
            return view.frame.height * 0.1
        }
    }
}
