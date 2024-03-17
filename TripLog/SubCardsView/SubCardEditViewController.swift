//
//  SubCardEditView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/11.
//

import UIKit

final class SubCardEditViewController: UIViewController {
    
    private let viewModel: SubCardsViewModel
    private let mainQueue = DispatchQueue.main
    private var selctedCardId: UUID?
    
    private lazy var scrollView = SubCardScrollView()
    
    init(viewModel: SubCardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(viewModel: SubCardsViewModel, selectedCardId: UUID) {
        self.init(viewModel: viewModel)
        self.selctedCardId = selectedCardId
        
        loadSubCard(selectedCardId: selectedCardId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        configureNavigationBar()
        configureScrollView()
    }
}

//MARK: - Method

extension SubCardEditViewController {
    
    private func loadSubCard(selectedCardId: UUID) {
        let index = viewModel.list.value.firstIndex { subCard in
            subCard.id == selectedCardId
        }
        guard let index = index else { return }
        
        let card = viewModel.list.value[index]
        scrollView.updateContent(card: card)
       
    }

}

//MARK: - objc

extension SubCardEditViewController {
    
    @objc private func doneAction() {
        
        if let cardId = selctedCardId {
            
            viewModel.updateContent(selectedCardId: cardId,
                                    title: scrollView.titleView.text,
                                    images: scrollView.imageView.images,
                                    starsState: scrollView.starRateView.starState,
                                    price: scrollView.priceView.price,
                                    script: scrollView.scriptTextView.text)
            
        } else {
            
            viewModel.appendSubCard(title: scrollView.titleView.text,
                                    images: scrollView.imageView.images,
                                    starsState: scrollView.starRateView.starState,
                                    price: scrollView.priceView.price,
                                    script: scrollView.scriptTextView.text)
        }
        
        navigationController?.popViewController(animated: true)
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
        scrollView.configureDelegate(delegate: self)

        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
    }

}

//MARK: - PresentViewDelegate

extension SubCardEditViewController: PresentViewDelegate {
    
    func presentViewController(where viewController: UIViewController) {
        self.present(viewController, animated: true)
    }
    
}
