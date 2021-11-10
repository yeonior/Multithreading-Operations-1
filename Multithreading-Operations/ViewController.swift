//
//  ViewController.swift
//  Multithreading-Operations
//
//  Created by ruslan on 08.11.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let queue = OperationQueue()
    private let imageURLs: [URL] = [
        URL(string: "https://images.unsplash.com/photo-1635813782590-0f5d34934b9d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1287&q=80")!,
        URL(string: "https://images.unsplash.com/photo-1635372886281-4487e1e00904?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2274&q=80")!
    ]
    private var timer = Timer()
    private var timerCount = 3 {
        didSet {
            label.text = "You can cancel the downloading\n next image within \(timerCount) seconds"
        }
    }
    
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuringUI()
        
        setBlockOperation {
            self.image = self.getImage(from: self.imageURLs[0])
        }
    }
    
    // configuring UI
    private func configuringUI() {
        label.isHidden = true
        label.numberOfLines = 0
        label.text = "You can cancel the downloading\n next image within \(timerCount) seconds"
        downloadButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
    }
    
    // setting up the timer
    private func setUpTimer() {
        label.isHidden = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self] timer in
            print(timerCount)
            timerCount -= 1
            guard timerCount == 0 else { return }
            resetTimer()
        })
    }
    
    // reseting the timer
    private func resetTimer() {
        timer.invalidate()
        timerCount = 3
        label.isHidden = true
        cancelButton.isEnabled = false
    }
    
    // creation an operation block
    private func setBlockOperation(_ block: @escaping () -> Void) {
        let blockOperation = BlockOperation {
            block()
        }
        queue.addOperation(blockOperation)
    }
    
    // trying to get an image
    private func getImage(from URL: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: URL) else { return nil }
        let image = UIImage(data: data)
        
        return image
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
    }
}

