//
//  SearchLocationViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/15.
//

import MapKit

final class SearchLocationViewController: UIViewController {

    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion = MKCoordinateRegion(MKMapRect.world)
    private var completerResults: [MKLocalSearchCompletion]?

    private var place: MKMapItem? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            place = nil
            localSearch?.cancel()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        configureSearchBar()
        configureCollectionView()
        cellRegister()
        configureSearchCompleter()
       
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createBasicLayout()
      
        let safeArea = view.safeAreaLayoutGuide
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    private func createBasicLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        layoutConfiguration.backgroundColor = .basic
        
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        
        return layout
    }
    
    private func cellRegister() {
        collectionView.register(LocationListCell.self,
                                forCellWithReuseIdentifier: LocationListCell.identifier)
    }
    
    private func configureSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .query
        searchCompleter?.region = searchRegion
  
    }
    
}

extension SearchLocationViewController {
    
    private func highlightedText(text: String, ranges: [NSValue], size: CGFloat) -> NSMutableAttributedString {
        
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

extension SearchLocationViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return completerResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationListCell.identifier,
                                                            for: indexPath) as? LocationListCell else { return LocationListCell() }
        
        if let suggestion = completerResults?[indexPath.row] {
            cell.title.attributedText = highlightedText(text: suggestion.title,
                                                        ranges: suggestion.titleHighlightRanges,
                                                        size: 20)
            cell.subTitle.text = suggestion.subtitle
            
            let symbolIcon = place?.pointOfInterestCategory?.symbolName ?? MKPointOfInterestCategory.defaultPointsOfInterestSymbolName
            cell.icon.image = UIImage(systemName: symbolIcon)
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let completerResults = completerResults else { return }
        
        let result = completerResults[indexPath.row]
        
        search(for: result)
        
    }
    

}

extension SearchLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            completerResults = nil
        }

        searchCompleter?.queryFragment = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search(for: searchBar.text)
    }
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
 
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        
        collectionView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
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
                  let mapItem = response?.mapItems[0] else { return }
            
            self.place = mapItem
            
            if let updatedRegion = response?.boundingRegion {
                self.searchRegion = updatedRegion
            }
            
        }
    }
}
