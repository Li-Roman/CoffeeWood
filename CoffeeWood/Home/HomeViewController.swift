//
//  HomeViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.07.2023.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        label.text = "HOME PAGE"
        label.font = .boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.textColor = .AppColors.mainLabels
        
    }
    
}
