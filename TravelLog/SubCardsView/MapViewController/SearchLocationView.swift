//
//  SearchLocationView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/27.
//

import UIKit
import SnapKit

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
        
        grabberView.layer.cornerRadius = 4
        grabberView.backgroundColor = .lightGray
        
        grabberView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(8)
        }
    }
    
    private func configureSearchBar() {
        self.addSubview(searchBar)
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.9697164893, green: 0.9697164893, blue: 0.9697164893, alpha: 1)
        
        let safeArea = self.safeAreaLayoutGuide
        searchBar.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func configureCollectionView() {
        self.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func configureInformationView() {
        self.addSubview(informationView)
        
        informationView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        informationView.isHidden = true
    }
}
