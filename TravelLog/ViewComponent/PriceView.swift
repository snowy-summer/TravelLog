//
//  PriceView.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/12.
//

import UIKit
import SnapKit

protocol PriceViewDelegate: AnyObject {
    
    func updateViewModelValue(price: String?)
    func presentCurrencyList()
    
}

final class PriceView: UIView {
    
    private lazy var priceLabel = UILabel()
    private lazy var priceTextField = UITextField()
    private lazy var swapCurrencyButton = UIButton()
    
    weak var delegate: PriceViewDelegate?
    
    var price: Double {
        guard let priceText = priceTextField.text?.split(separator: ",").joined(),
              let price = Double(priceText) else { return 0}
        
        return price
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurePriceLabel()
        configureCurrencyButton()
        configurePriceTextField()
        DispatchQueue.main.async {
            self.configureUnderLine(size: 2,
                                    color: UIColor.lightGray.cgColor)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Method

extension PriceView {
    
    func updatePrice(price: Double?) {
        guard let price = price else { return }
        
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        let formattedNumber = numberFormmater.string(from: NSNumber(value: price))
        
        priceTextField.text = formattedNumber
    }
    
    func updatePriceView(rate: Double,
                         price: Double?,
                         buttonTitle: String) {
        
        guard var price = price else { return }
        price /= rate
        
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        
        let formattedNumber = numberFormmater.string(from: NSNumber(value: price))
        
        priceTextField.text = formattedNumber
        swapCurrencyButton.setTitle(buttonTitle,
                                    for: .normal)
    }
    
    @objc func didTextFieldChange() {
        let text = priceTextField.text?.split(separator: ",").joined()
        delegate?.updateViewModelValue(price: text)
    }
    
    @objc func presentCurrencyRateList() {
        delegate?.presentCurrencyList()
    }
}

//MARK: - Configuration

extension PriceView {
    
    private func configurePriceLabel() {
        self.addSubview(priceLabel)
        
        priceLabel.text = "금액"
        priceLabel.font = .preferredFont(forTextStyle: .callout)
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    private func configureCurrencyButton() {
        self.addSubview(swapCurrencyButton)
        
        swapCurrencyButton.configuration = buttonConfiguration()
        var currentCurrency = UserDefaults.standard.object(forKey: "currentCurrency") as? String
        if currentCurrency == nil {
            UserDefaults.standard.set("KRW", forKey: "currentCurrency")
            currentCurrency = UserDefaults.standard.object(forKey: "currentCurrency") as? String
        }
        swapCurrencyButton.setTitle(currentCurrency,
                                    for: .normal)
        swapCurrencyButton.setTitleColor(.black,
                                         for: .normal)
        swapCurrencyButton.setImage(UIImage(systemName: "chevron.down"),
                                    for: .normal)
        swapCurrencyButton.addTarget(self,
                                     action: #selector(presentCurrencyRateList),
                                     for: .touchUpInside)
        
        swapCurrencyButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private func buttonConfiguration() -> UIButton.Configuration {
        
        var configuration = UIButton.Configuration.bordered()
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .clear
        
        return configuration
    }
    
    private func configurePriceTextField() {
        self.addSubview(priceTextField)
        
        priceTextField.textAlignment = .left
        priceTextField.font = .preferredFont(forTextStyle: .title3)
        priceTextField.placeholder = "금액을 입력하세요"
        priceTextField.keyboardType = .decimalPad
        priceTextField.addTarget(self,
                                 action: #selector(didTextFieldChange),
                                 for: .editingChanged)
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview()
            make.trailing.equalTo(swapCurrencyButton.snp.leading).offset(-8)
        }
    }
    
    private func configureUnderLine(size: CGFloat, color: CGColor?) {
        let underLine = CALayer()
        self.layer.addSublayer(underLine)
        underLine.backgroundColor = color
        
        underLine.frame = CGRect(origin: CGPoint(x: priceTextField.frame.origin.x,
                                                 y: self.frame.height),
                                 size: CGSize(width: priceTextField.frame.width,
                                              height: size))
        
    }
}
