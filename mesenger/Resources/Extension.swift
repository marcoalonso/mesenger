//
//  Extension.swift
//  mesenger
//
//  Created by marco alonso on 01/12/20.
//

import Foundation
import UIKit

extension UIView{
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    public var heiht: CGFloat {
        return self.frame.size.height
    }
    public var top: CGFloat {
        return self.frame.origin.y
    }
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    public var left: CGFloat {
        return self.frame.origin.x
    }
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}
