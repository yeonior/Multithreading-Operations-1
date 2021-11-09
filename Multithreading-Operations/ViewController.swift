//
//  ViewController.swift
//  Multithreading-Operations
//
//  Created by ruslan on 08.11.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
    }
}

