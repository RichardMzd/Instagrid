//
//  ViewController.swift
//  P4-Instagrid
//
//  Created by Richard Arif Mazid on 07/01/2022.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var frameView: UIView!
    @IBOutlet var layoutStackView: UIStackView!
    @IBOutlet var swipeStackView: UIStackView!
    @IBOutlet var plusButtons: [UIButton]!
    @IBOutlet var layoutButtons: [UIButton]!
    
    private var swipeGestureRecognizer : UISwipeGestureRecognizer?
    
    var indexButtons = Int()
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(displayActivityController(_:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name:UIDevice.orientationDidChangeNotification,object: nil)
        
        guard let swipeGestureRecognizer = swipeGestureRecognizer else { return }
        frameView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //     Handle swipe direction whether up or left
    @objc func setupSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGestureRecognizer?.direction = .left
        } else {
            swipeGestureRecognizer?.direction = .up
        }
    }
    
    @objc func displayActivityController(_ sender: UIActivityItemSource) {
        print("ActivityController opened")
        let imageView = imageConvert(frameView)
        let activityController = UIActivityViewController(activityItems: [imageView as Any], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        self.shareView()
        
        //Completion handler
        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                print("share completed")
                self.cancelShareView()
                return
            } else {
                print("cancel")
                self.cancelShareView()
            }
        }
    }
    
    // Method in order to convert UIview as UImage
    func imageConvert(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    // MARK: - IBActions to select between the three different layout and add pictures to the selected layout
    
    @IBAction func LayoutSelected(_ sender: UIButton) {
        layoutButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        switch sender.tag {
        case 0:
            plusButtons[0].isHidden = true
            plusButtons[3].isHidden = false
        case 1:
            plusButtons[0].isHidden = false
            plusButtons[3].isHidden = true
        case 2:
            plusButtons[0].isHidden = false
            plusButtons[3].isHidden = false
        default:
            break
        }
    }
    
    @IBAction func addPhotos(_ sender: UIButton) {
        indexButtons = sender.tag
        showImagePickerController()
    }
    
    
    // MARK: - Animation
    
    // Gridview & Swipe label disappear
    func shareView () {
        if UIDevice.current.orientation.isLandscape {
            let screenWidth = UIScreen.main.bounds.width
            let translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
            UIView.animate(withDuration: 0.5) {
                self.frameView.transform = translationTransform
                self.swipeStackView.transform = translationTransform
            }
        } else {
            let screenHeight = UIScreen.main.bounds.height
            let translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
            UIView.animate(withDuration: 0.5) {
                self.swipeStackView.transform = translationTransform
                self.frameView.transform = translationTransform
            }
        }
    }
    
    // Gridview & Swipe label reappear
    func cancelShareView() {
        let translationTransform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.3) {
            self.swipeStackView.transform = .identity
            self.frameView.transform = translationTransform
        }
    }
}


