//
//  SubCardEditView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/11.
//

import UIKit

final class SubCardEditViewController: UIViewController {
    
    private let viewModel: SubCardsViewModel
    private var selctedCardId: UUID?
    
    private lazy var scrollView = SubCardScrollView(viewModel: viewModel,
                                                    selctedCardId: selctedCardId)
    
    init(viewModel: SubCardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(viewModel: SubCardsViewModel,
                     selectedCardId: UUID) {
        self.init(viewModel: viewModel)
        self.selctedCardId = selectedCardId
        
        loadSubCard(selectedCardId: selectedCardId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        bind()
        configureNavigationBar()
        configureScrollView()
    }
    
}

//MARK: - Method

extension SubCardEditViewController {
    
    private func loadSubCard(selectedCardId: UUID) {
        guard let card = viewModel.selectCard(id: selectedCardId) else { return }
        
        viewModel.editingSubCard.value = card
    }
    
    private func bind() {
        viewModel.editingSubCard.observe{ [weak self] subCard in
            self?.scrollView.updateContent(card: subCard)
        }
    }

}

//MARK: - objc

extension SubCardEditViewController {
    
    @objc private func doneAction() {
        
        if let cardId = selctedCardId {
            viewModel.updateSubCard(id: cardId,
                                    card: viewModel.editingSubCard.value)
        } else {
            viewModel.list.value.append(viewModel.editingSubCard.value)
        }
        
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - SubscrollViewDelegate

extension SubCardEditViewController: SubscrollViewDelegate {
    
    func pushMapViewController() {
        self.navigationController?.pushViewController(MapViewController(delegate: self,
                                                                        location: viewModel.editingSubCard.value.location),
                                                      animated: true)
    }
    
    
    func presentViewController(where viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
    
}

//MARK: - MapViewControllerDelegate

extension SubCardEditViewController: MapViewControllerDelegate {
   
    func updateLocation(location: LocationModel) {
        viewModel.updateEditingCardLocation(location: location)
    }
    
}

//MARK: - Configuration

extension SubCardEditViewController {
    
    private func configureNavigationBar() {
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .plain,
                                         target: self,
                                         action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.subCardScrollViewDelegate = self

        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
    }

}
