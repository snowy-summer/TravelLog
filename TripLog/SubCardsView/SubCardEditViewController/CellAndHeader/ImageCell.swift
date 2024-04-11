//
//  ImageCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/05.
//

import UIKit
import PhotosUI

final class ImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let addButton = UIButton()
    private let mainQueue = DispatchQueue.main
    private let group = DispatchGroup()
    var images = [UIImage]()
    
    weak var delegate: SelectedImageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
        configureAddButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage(_ image: UIImage) {
        
        if image.size == .zero{
            addButton.isHidden = false
            backgroundColor = .viewBackground
        } else {
            addButton.isHidden = true
            backgroundColor = .clear
        }
        
        imageView.image = image
    }
    
    func isButtonHidden(value: Bool) {
        addButton.isHidden = value
    }
    
    private func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(addImage)))
        
        let titleConstraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(titleConstraints)
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

extension ImageCell: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.count != 0 {
            images = [UIImage](repeating: UIImage(), count: results.count)
        }
        
        for index in 0..<results.count {
            let itemProvider = results[index].itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    
                    guard let image = image as? UIImage else { return }
                    guard let self = self else { return }
                    
                    images[index] = image
                    group.leave()
                        
                    
                   
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            delegate?.updateViewModelValue(images: images)
            
        }
        
        
    }
    
}
