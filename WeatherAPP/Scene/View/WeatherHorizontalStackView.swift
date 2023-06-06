//
//  WeatherHorizontalStackView.swift
//  WeatherAPP
//
//  Created by Buğra Özuğurlu on 5.06.2023.
//

import UIKit

protocol WeatherHorizontalStackViewProtocol: AnyObject {
    func didFetchWeather(_ stackView: WeatherHorizontalStackView, weatherModel: Weather)
    func didFailWithError(_ stackView: WeatherHorizontalStackView, error: ErrorType)
    func updatingLocation(_ stackView: WeatherHorizontalStackView)
}
class WeatherHorizontalStackView: UIStackView {
    //MARK: - Properties:
    private let networkManager = NetworkManager()
    weak var delegate: WeatherHorizontalStackViewProtocol?
    
    private let weatherSelectedCityTextField: UITextField = {
        let tField = UITextField()
        tField.attributedPlaceholder = NSAttributedString(string: "Şehir ismi giriniz.", attributes: [.foregroundColor: UIColor.systemGray3])
        tField.textAlignment = .center
        tField.font = .boldSystemFont(ofSize: 20)
        tField.textColor = .systemBackground
        tField.backgroundColor = .label
        tField.borderStyle = .roundedRect
        return tField
    }()
    private lazy var weatherSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(weatherSearchButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var weatherLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(weatherLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
        weatherSelectedCityTextField.delegate = self
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers:
extension WeatherHorizontalStackView {
    private func setup() {
        [weatherLocationButton, weatherSelectedCityTextField, weatherSearchButton].forEach { stack in
            addArrangedSubview(stack)
        }
        axis = .horizontal
        spacing = 20
        distribution = .equalSpacing
    }
    private func layout() {
        weatherSelectedCityTextField.snp.makeConstraints { make in
            make.width.equalTo(250)
        }
    }
}
// MARK: - Textfield Delegate:
extension WeatherHorizontalStackView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.weatherSelectedCityTextField.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cityName = weatherSelectedCityTextField.text else {return}
        
        networkManager.fetchWeatherCityName(cityName: cityName) { [weak self] result in
            switch result {
            case.success(let result):
                self?.delegate?.didFetchWeather(self!, weatherModel: result)
            case.failure(let error):
                self?.delegate?.didFailWithError(self!, error: error)
            }
        }
        self.weatherSelectedCityTextField.text = ""
    }
}
// MARK: - Selectors:
extension WeatherHorizontalStackView {
    @objc private func weatherSearchButtonTapped() {
        weatherSelectedCityTextField.endEditing(true)
    }
    @objc private func weatherLocationButtonTapped() {
        self.delegate?.updatingLocation(self)
    }
}

