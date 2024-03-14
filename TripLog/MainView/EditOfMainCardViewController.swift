//
//  MainViewEditView.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/29.
//

import UIKit
import PhotosUI

final class EditOfMainCardViewController: UIViewController {
    
    private lazy var titleView = TitleView()
    private lazy var imageView = UIImageView()
    private lazy var addButton = UIButton()
    private let mainViewModel: MainViewModelProtocol
    private var selectedCardId: UUID?
    private var mainQueue = DispatchQueue.main
    
    init(mainViewmodel: MainViewModelProtocol) {
        self.mainViewModel = mainViewmodel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    convenience init(mainViewModel: MainViewModelProtocol, id: UUID) {
        self.init(mainViewmodel: mainViewModel)
        self.selectedCardId = id
        
        loadMainCard(selectedCardID: id)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
    
        configureTitleView()
        configureImageView()
        configureNavigationBar()
        configureAddButton()
    }
    
}

extension EditOfMainCardViewController {
    
    private func loadMainCard(selectedCardID: UUID) {
        let index = mainViewModel.list.value.firstIndex { mainCard in
            mainCard.id == selectedCardID
        }
        guard let index = index else { return }
        let card = mainViewModel.list.value[index]
        
        titleView.updateText(card.title)
        
        if let sumbnailImage = card.image {
            imageView.image = sumbnailImage
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
}

//MARK: - Configuration

extension EditOfMainCardViewController {

    private func configureTitleView() {
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.layer.borderWidth = 1
        
        let safeArea = view.safeAreaLayoutGuide
        let titleViewConstraints = [
            titleView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                           constant: 8),
            titleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                               constant: 16),
            titleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                constant: -16),
            titleView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ]
        
        titleView.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate(titleViewConstraints)
        
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(addImage)))
        imageView.isUserInteractionEnabled = true
        
        let safeArea = view.safeAreaLayoutGuide
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                           constant: 16),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                               constant: 16),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                constant: -16),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor,
                                              multiplier: 0.3)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureNavigationBar() {
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneAction))
        let cancelButton = UIBarButtonItem(title: "취소",
                                           style: .done,
                                           target: self,
                                           action: #selector(cancelAction))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureAddButton() {
        imageView.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
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

}

//MARK: - PHPickerViewControllerDelegate

extension EditOfMainCardViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                self?.mainQueue.async {
                    self?.imageView.image = image as? UIImage
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

//MARK: - objc Method
 
extension EditOfMainCardViewController{

    @objc private func addImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc private func doneAction() {
      
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            guard let title = self.titleView.text else { return }
            
            let sumbnailImage = imageView.image
            
            guard let cardId = self.selectedCardId else {
                
                if sumbnailImage == nil {
                    self.mainViewModel.appendMainCard(title: title, image: nil)
                } else {
                    self.mainViewModel.appendMainCard(title: title, image: sumbnailImage)
                }
                
                return
            }
            
            self.mainViewModel.editMainCardTitle(id: cardId, title: title)
            self.mainViewModel.editMainCardImage(id: cardId, image: imageView.image)
            self.mainViewModel.editMainCardDate(id: cardId, date: .now)
        }
        
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
    
}
