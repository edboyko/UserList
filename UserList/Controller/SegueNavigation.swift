//
//  SegueNavigation.swift
//  UserList
//
//  Created by Edwin Boyko on 06/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

protocol SegueNavigation where Self: UIViewController {
    static var segueIdentifier: String { get }
}

extension UIViewController: SegueNavigation {
    static var segueIdentifier: String {
        return "show\(String(describing: self))"
    }
}
