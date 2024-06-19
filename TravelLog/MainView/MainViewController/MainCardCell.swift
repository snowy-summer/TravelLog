//
//  MainCardCell.swift
//  TripLog
//
//  Created by 최승범 on 2024/02/28.
//

import UIKit

final class MainCardCell: UICollectionViewCell {
    
    private var id: UUID?
    weak var delegate: CellDelegate?
    
    private lazy var titleLabel = UILabel()
    private lazy var thumbnailImageView = UIImageView()
    private lazy var dateLabel = UILabel()
    private lazy var menuButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
        configureThumbnailImageView()
        configureTitlLabel()
        configureDateLabel()
        configureMenuButton()
        configureMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainCardCell {
    
    func updateContent(title: String?,
                       image: UIImage?,
                       date: Date,
                       id: UUID) {
        titleLabel.text = title
        self.id = id
        
        if let thumbnailImage = image {
            thumbnailImageView.image = thumbnailImage
        } else {
            thumbnailImageView.image = UIImage(resource: .skyBlue)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd"
        dateLabel.text = formatter.string(from: date)
    }
    
}

//MARK: - Configuration

extension MainCardCell {
    
    private func configureContentView() {
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(resource: .baseOfCell)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
        }
    }
    
    private func configureThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.contentMode = .scaleAspectFill
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.lessThanOrEqualTo(thumbnailImageView.snp.width).multipliedBy(0.75)
        }
    }
    
    private func configureTitlLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.5)
        }
    }
    
    private func configureDateLabel() {
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-8)
        }
    }
    
    private func configureMenuButton() {
        contentView.addSubview(menuButton)
        
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(dateLabel)
            make.width.equalTo(contentView).multipliedBy(0.1)
            make.height.equalTo(menuButton.snp.width)
        }
    }
    
    private func configureMenu() {
        
        let edit = UIAction(title: "편집",
                            image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
            guard let id = self?.id else { return }
            self?.delegate?.editCard(id: id)
        }
        
        let bookMark = UIAction(title: "즐겨찾기",
                                image: UIImage(systemName: "bookmark")) { [weak self] _ in
            guard let id = self?.id else { return }
            self?.delegate?.bookmarkCard(id: id)
            
        }
        
        let delete = UIAction(title: "삭제",
                              image: UIImage(systemName: "trash"),
                              attributes: .destructive) { [weak self] _ in
            guard let id = self?.id else { return }
            self?.delegate?.deleteCard(id: id)
        }
        
        let items = [
            edit,
            bookMark,
            delete
        ]
        
        menuButton.menu = UIMenu(children: items)
        menuButton.showsMenuAsPrimaryAction = true
        
    }
}
