//
//  MainViewEditView.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/29.
//

import UIKit

final class EditOfVMainCardViewController: UIViewController {
    
    private lazy var titleTextField = UITextField()
    private lazy var titleView = UIView()
    private lazy var imageView = UIImageView()
    private let mainViewmodel: MainViewModel
    
    init(mainViewmodel: MainViewModel) {
        self.mainViewmodel = mainViewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    
        configureTitleView()
        configureTitleTextField()
        configureImageView()
        configureNavigationVar()
    }
    
}

extension EditOfVMainCardViewController {

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
    
    private func configureTitleTextField() {
        
        titleView.addSubview(titleTextField)
        titleTextField.placeholder = "제목"
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let titleTextFieldConstraints = [
            titleTextField.topAnchor.constraint(equalTo: titleView.topAnchor,
                                                constant: 4),
            titleTextField.bottomAnchor.constraint(equalTo: titleView.bottomAnchor,
                                                constant: -4),
            titleTextField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor,
                                                constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor,
                                                     constant: -8),
        ]
        
        NSLayoutConstraint.activate(titleTextFieldConstraints)
        
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(resource: .addImagePlaceHolder)
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
    
    private func configureNavigationVar() {
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
    
    @objc private func addImage() {
        print("이미지 추가")
    }
    
    @objc private func doneAction() {
      
        self.dismiss(animated: true) { [weak self] in
            guard let title = self?.titleTextField.text else { return }
            self?.mainViewmodel.list.value.append(MainCard(title: title,
                                                     subCard: []))
        }
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
}
