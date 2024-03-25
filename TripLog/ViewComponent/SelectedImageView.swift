//
//  SelectedImageView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/14.
//

import UIKit
import PhotosUI

protocol SelectedImageViewDelegate: AnyObject {
    
    func presentPicker(where: UIViewController)
    func updateViewModelImages(images: [UIImage]?)
    
}

final class SelectedImageView: UIView {
    
    private lazy var imageView = UIImageView()
    private lazy var pageControl = UIPageControl()
    private lazy var addButton = UIButton()
    private var mainQueue = DispatchQueue.main
    var images = [UIImage]()
    
    weak var delegate: SelectedImageViewDelegate?
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
        configurePageControl()
        configureSwipeGesture()
        configureAddButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectedImageView {
    
    func updateImage(image: UIImage) {
        imageView.image = image
    }
    
    func isButtonHidden(value: Bool) {
        addButton.isHidden = value
    }
    
    func updateNumberOfPages(num: Int) {
        pageControl.numberOfPages = num
    }
    
    func removePageControl() {
        pageControl.removeFromSuperview()
    }
}

extension SelectedImageView {
    
    private func configureImageView() {
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(addImage)))
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configurePageControl() {
        self.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = true
        pageControl.currentPageIndicatorTintColor = .cyan
        
        
        let pageControlConstraints = [
            pageControl.heightAnchor.constraint(equalToConstant: 40),
            pageControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(pageControlConstraints)
        
    }
    
    private func configureSwipeGesture() {
         let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
         swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
         self.addGestureRecognizer(swipeLeft)
         
         let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
         swipeRight.direction = UISwipeGestureRecognizer.Direction.right
         self.addGestureRecognizer(swipeRight)
         
     }
    
    private func configureAddButton() {
        imageView.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.isUserInteractionEnabled = true
        
        addButton.setImage(UIImage(resource: .plusButton), for: .normal)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.addTarget(self,
                            action: #selector(addImage),
                            for: .touchUpInside)
       
        let addButtonConstraints = [
            addButton.widthAnchor.constraint(equalTo: imageView.widthAnchor,
                                             multiplier: 0.2),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            addButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(addButtonConstraints)
    }
    
    @objc func respondToSwipeGesture(_ sender: Any) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer{
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if pageControl.currentPage <= pageControl.numberOfPages {
                    pageControl.currentPage += 1
                }
                
                imageView.image = images[pageControl.currentPage]
            case UISwipeGestureRecognizer.Direction.right:
                if pageControl.currentPage <= pageControl.numberOfPages && 0 < pageControl.currentPage {
                    pageControl.currentPage -= 1
                }
                
                imageView.image = images[pageControl.currentPage]
            default:
                break
            }
        }
    }
    
    @objc private func addImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = .max
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        delegate?.presentPicker(where: picker)
    }
    
}

//MARK: - PHPickerViewControllerDelegate

extension SelectedImageView: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.count != 0 {
            images = [UIImage](repeating: UIImage(), count: results.count)
        }
        
        for index in 0..<results.count {
            let itemProvider = results[index].itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    
                    guard let image = image as? UIImage else { return }
                    guard let self = self else { return }
                    
                    self.images[index] = image
                    self.mainQueue.async {
                        self.imageView.image = self.images[0]
                        self.pageControl.numberOfPages = self.images.count
                    }
                }
            }
        }
        
        delegate?.updateViewModelImages(images: images)
        
        if imageView.image == nil  && results.isEmpty {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
    
}
