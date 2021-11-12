//
//  ViewController.swift
//  Multithreading-Operations
//
//  Created by ruslan on 08.11.2021.
//

import UIKit

// practicing with the operation queues

final class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let mainQueue = OperationQueue.main
    private let concurrentQueue = OperationQueue()
    private var firstOperation = BlockOperation()
    private var secondOperation = BlockOperation()
        
    private var timer = Timer()
    private var timerCount = 3 {
        didSet {
            label.text = "You can cancel the downloading\n next image within \(timerCount) seconds"
        }
    }
    
    private let imageURLs: [URL] = [
        URL(string: "https://images.unsplash.com/photo-1635813782590-0f5d34934b9d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1287&q=80")!,
        URL(string: "https://images.unsplash.com/photo-1635372886281-4487e1e00904?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2274&q=80")!
    ]
    private var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuringUI()
    }
    
    // configuring UI
    private func configuringUI() {
        label.isHidden = true
        label.numberOfLines = 0
        label.text = "You can cancel the downloading\n next image within \(timerCount) seconds"
        downloadButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
    }
    
    // setting up the operations
    private func setUpOperations(first: @escaping () -> Void,
                                 second: @escaping () -> Void) {
        
        firstOperation = BlockOperation(block: first)
        secondOperation = BlockOperation(block: second)
        performOperations(withAsyncBlock: firstOperation, andCompletionBlock: secondOperation)
    }
    
    private func performOperations(withAsyncBlock asyncBlock: BlockOperation,
                                   andCompletionBlock completionBlock: BlockOperation) {
        
        completionBlock.addDependency(asyncBlock)
        concurrentQueue.addOperation(asyncBlock)
        mainQueue.addOperation(completionBlock)
    }
    
    // trying to get an image
    private func getImage(from URL: URL) -> UIImage {
        guard let data = try? Data(contentsOf: URL), let image = UIImage(data: data) else {
            return UIImage(systemName: "nosign")!
        }
        return image
    }
        
    // setting up the timer
    private func setUpTimer(completionBlock: (() -> Void)? = nil) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self] timer in
            timerCount -= 1
            guard timerCount == 0 else { return }
            resetTimer()
            guard let completion = completionBlock else { return }
            completion()
        })
    }
    
    // reseting the timer
    private func resetTimer() {
        timer.invalidate()
        timerCount = 3
        label.isHidden = true
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        imageView.image = nil
        
        setUpOperations {
            self.image = self.getImage(from: self.imageURLs[0])
        } second: {
            self.imageView.image = self.image
            self.label.isHidden = false
            self.setUpTimer {
                self.setUpOperations {
                    self.image = self.getImage(from: self.imageURLs[1])
                } second: {
                    self.imageView.image = self.image
                }
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        resetTimer()
    }
}

