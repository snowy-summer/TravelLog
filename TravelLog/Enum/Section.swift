//
//  Section.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/20.
//

import UIKit

enum Section: Int, CaseIterable {
    case main
}

enum SubCardSection: Int, CaseIterable {
    case title
    case image
    case starRate
    case price
    case location
    case category
    case script
    
    
    var title: String {
        switch self {
        case .title:
            return "제목"
        case .image:
            return "사진"
        case .starRate:
            return "평점"
        case .price:
            return "금액"
        case .location:
            return "위치"
        case .category:
            return "테마"
        case .script:
            return "내용"
        }
    }
    
    var layoutSection: NSCollectionLayoutSection? {
        switch self {
        case .title:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                         subitems: [item])
            group.contentInsets = .init(top: 16,
                                        leading: 16,
                                        bottom: 0,
                                        trailing: 16)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        case .image:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .fractionalWidth(0.75))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = .init(top: 16,
                                        leading: 8,
                                        bottom: 0,
                                        trailing: 8)
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = .init(top: 0,
                                          leading: 16,
                                          bottom: 16,
                                          trailing: 16)
            
            return section
            
        case .starRate:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = .init(top: 0,
                                        leading: 8,
                                        bottom: 0,
                                        trailing: 8)
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0,
                                          leading: 16,
                                          bottom: 16,
                                          trailing: 16)
            
            return section
            
        case .price:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.08))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = .init(top: 0,
                                        leading: 0,
                                        bottom: 16,
                                        trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = .init(top: 0,
                                          leading: 16,
                                          bottom: 24,
                                          trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .topLeading)
            section.boundarySupplementaryItems = [header]
            
            return section
            
        case .location:
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.08))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = .init(top: 0,
                                        leading: 0,
                                        bottom: 16,
                                        trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = .init(top: 0,
                                          leading: 16,
                                          bottom: 24,
                                          trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .topLeading)
            section.boundarySupplementaryItems = [header]
            
            return section
            
        case .category:
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = .init(top: 0,
                                        leading: 0,
                                        bottom: 0,
                                        trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = .init(top: 0,
                                          leading: 16,
                                          bottom: 24,
                                          trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .topLeading)
            
            section.boundarySupplementaryItems = [header]
            
            return section
            
        case .script:
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.8))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            group.contentInsets = .init(top: 16,
                                        leading: 0,
                                        bottom: 0,
                                        trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = .init(top: 0,
                                          leading: 16,
                                          bottom: 0,
                                          trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .topLeading)
            
            section.boundarySupplementaryItems = [header]
            
            return section
        default:
            return nil
        }
        
    }
}

