//
//  LoginButton.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        tintColor = UIColor.white
    }
    

}
