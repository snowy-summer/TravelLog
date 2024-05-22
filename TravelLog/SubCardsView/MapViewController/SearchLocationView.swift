//
//  SearchLocationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/27.
//

import UIKit

final class SearchLocationView: UIView {
    
    private let locationViewModel: SearchLocationViewModel
    private let grabberView = UIView()
    private let searchBar = UISearchBar()
    
    weak var delegate: SearchLocationViewDelegate?

    private lazy var collectionView = SearchListCollectionView(locationViewModel: locationViewModel)
    private lazy var informationView = SelectedLocationInformationView(locationViewModel: locationViewModel)
    
    init(locationViewModel: SearchLocationViewModel) {
        self.locationViewModel = locationViewModel
        super.init(frame: .zero)
        
        configureSearchBar()
        configureCollectionView()
        configureInformationView()
        configureView()
        configureGrabber()
        
        if locationViewModel.savedLocationMapItem == nil{
            isCollectionViewHidden(value: false)
        } else {
            isCollectionViewHidden(value: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func saveSnapshot(id: [UUID]) {
        collectionView.saveSnapshot(id: id)
    }
    
    func isCollectionViewHidden(value: Bool) {
        collectionView.isHidden = value
        searchBar.isHidden = value
        informationView.isHidden = !value
    }
    
    func configureInformationViewDelegate(who delegate: InformationViewDelegate) {
        informationView.delegate = delegate
    }
    
    func configureSearchBarDelegate(who delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func updateInformationView() {
        informationView.updateContent()
    }
    
}

extension SearchLocationView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        isCollectionViewHidden(value: true)
        guard let dataSource = collectionView.dataSource as?
                UICollectionViewDiffableDataSource<Section, UUID>,
              let id = dataSource.itemIdentifier(for: indexPath) else { return }
        
        delegate?.changeModalLowConstraint()
        locationViewModel.updateSavedLocation(location: locationViewModel.selectedLocation(id: id))
        informationView.updateContent()
        
        endEditing(true)

    }
    
}

//MARK: - Configuration

extension SearchLocationView {
    
    private func configureView() {
        self.backgroundColor = .basic
        self.layer.cornerRadius = 12
    }
    
    private func configureGrabber() {
        self.addSubview(grabberView)
        
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        
        grabberView.layer.cornerRadius = 4
        grabberView.backgroundColor = .lightGray
        
        let grabberConstraints = [
            grabberView.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: 8),
            grabberView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            grabberView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                               multiplier: 0.2),
            grabberView.heightAnchor.constraint(equalToConstant: 8)
        ]
        
        NSLayoutConstraint.activate(grabberConstraints)
    }
    
    private func configureSearchBar() {
        self.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.9697164893, green: 0.9697164893, blue: 0.9697164893, alpha: 1)
        
        let safeArea = self.safeAreaLayoutGuide
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                           constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                           constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                           constant: -16),
          
        ]

        NSLayoutConstraint.activate(searchBarConstraints)
    }
    
    private func configureCollectionView() {
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
      
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func configureInformationView() {
        self.addSubview(informationView)
        
        informationView.translatesAutoresizingMaskIntoConstraints = false
      
        let informationViewConstraints = [
            informationView.topAnchor.constraint(equalTo: self.topAnchor),
            informationView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            informationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(informationViewConstraints)
        
        informationView.isHidden = true
    }
}
