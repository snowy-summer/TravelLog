//
//  SearchLocationViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/15.
//

import MapKit

final class SearchLocationViewController: UIViewController {

    private let locationViewModel = SearchLocationViewModel()
    private let searchBar = UISearchBar()

    private lazy var collectionView = SearchListCollectionView(viewModel: locationViewModel)
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion = MKCoordinateRegion(MKMapRect.world)
    private var completerResults: [MKLocalSearchCompletion]?

    private var places: [MKMapItem?]? {
        didSet {
            
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        configureSearchBar()
        configureCollectionView()
        configureSearchCompleter()
        bind()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchCompleter = nil
    }
    
}

//MARK: - Configuration

extension SearchLocationViewController {
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.9697164893, green: 0.9697164893, blue: 0.9697164893, alpha: 1)
        
        let safeArea = view.safeAreaLayoutGuide
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
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
      
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func configureSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }
    
}

extension SearchLocationViewController {
    
    private func bind() {
        locationViewModel.list.observe { [weak self] locationModels in
            self?.collectionView.saveSnapshot(id: locationModels.map{ $0.id })
        }
    }
    
    private func highlightedText(text: String,
                                 ranges: [NSValue],
                                 size: CGFloat) -> NSMutableAttributedString {
        
        let attributedText = NSMutableAttributedString(string: text)
        let normalFont = UIFont.systemFont(ofSize: size)
        
        attributedText.addAttribute(.font,
                                    value: normalFont,
                                    range: NSRange(location: 0,
                                                   length: text.count))
        
        for range in ranges {
            let boldFont = UIFont.boldSystemFont(ofSize: size)
            
            let nsRange = range.rangeValue
            attributedText.addAttribute(.font,
                                        value: boldFont,
                                        range: nsRange)
        }
        
        return attributedText
    }
}

//MARK: - CollectionViewDelegate

extension SearchLocationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let completerResults = completerResults else { return }
        
        let result = completerResults[indexPath.row]
        search(for: result)
    }
    
}

extension SearchLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText == "" {
            completerResults = nil
        }

        searchCompleter?.queryFragment = searchText
        search(for: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search(for: searchBar.text)
    }
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
 
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationViewModel.list.value.removeAll()
        completerResults = completer.results
      
    }
    
    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        if let error = error as NSError? {
            print("위치 가져오기 에러 발생: \(error.localizedDescription)")
        }
    }
    
}

//MARK: - Search

extension SearchLocationViewController {
    
    //completion 기반 검색 실행
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    //문자 기반 검색 실행
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.travelPointsOfInterest)
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    //들어온 request를 기반으로 검색을 실행한다.
    private func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [weak self] response, error in
    
            guard let self = self,
                  let mapItems = response?.mapItems else { return }
            
            self.places = mapItems
            
            guard let results = completerResults else { return }
            for i in 0..<results.count {
                locationViewModel.appendLocationModel(completion: results[i], mapitem: self.places?[i])
                
            }

        }
    }
}
