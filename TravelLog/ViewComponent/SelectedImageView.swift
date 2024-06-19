//
//  SelectedImageView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/14.
//

import UIKit
import PhotosUI
import SnapKit

protocol SelectedImageViewDelegate: AnyObject {
    
    func presentPicker(who: UIViewController)
    func updateViewModelValue(images: [UIImage]?)
    
}

final class SelectedImageView: UIView {
    
    private var imageView = UIImageView()
    private var addButton = UIButton()
    private lazy var pageControl = UIPageControl()
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
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(addImage)))
        imageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
    private func configurePageControl() {
        self.addSubview(pageControl)
        
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = true
        pageControl.currentPageIndicatorTintColor = .darkGray
        
        
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.directionalHorizontalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
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
        
        addButton.isUserInteractionEnabled = true
        
        addButton.setImage(UIImage(resource: .plusButton), for: .normal)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.addTarget(self,
                            action: #selector(addImage),
                            for: .touchUpInside)
        
        addButton.snp.makeConstraints { make in
            make.width.equalTo(imageView.snp.width).multipliedBy(0.2)
            make.height.equalTo(addButton.snp.width)
            make.center.equalTo(imageView)
        }
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
        
        delegate?.presentPicker(who: picker)
    }
    
}

//MARK: - PHPickerViewControllerDelegate

extension SelectedImageView: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
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
                        self.delegate?.updateViewModelValue(images: self.images)
                    }
                    
                }
            }
        }
        
        if imageView.image == nil  && results.isEmpty {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
    
}
