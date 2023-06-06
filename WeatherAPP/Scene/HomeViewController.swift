//
//  ViewController.swift
//  WeatherAPP
//
//  Created by Buğra Özuğurlu on 5.06.2023.
//

import UIKit
import SnapKit
import CoreLocation
import SkeletonView

class HomeViewController: UIViewController {
    //MARK: - Properties:
    private var viewModel: HomeViewModel? {
        didSet {
            configure()
        }
    }
    private lazy var weatherHorizontalStackView = WeatherHorizontalStackView()
    private let locationManager = CLLocationManager()
    private let networkManager = NetworkManager()
    
    private lazy var weatherVerticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weatherTemperatureLabel, weatherCityNameLabel])
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    private let weatherImageView: UIImageView = {
        let iView = UIImageView()
        iView.tintColor = .label
        iView.contentMode = .scaleAspectFit
        iView.layer.cornerRadius = 100
        iView.isSkeletonable = true
        return iView
    }()
    private let weatherCityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        label.isSkeletonable = true
        return label
    }()
    private let weatherTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.isSkeletonable = true
        return label
    }()
    //MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        configureLocation()
        weatherHorizontalStackView.delegate = self
    }
}
//MARK: - Helpers:
extension HomeViewController {
    private func setup() {
        backGraoundGradientLayer()
        view.addSubviews(weatherHorizontalStackView, weatherImageView, weatherVerticalStackView)
        
    }
    private func layout() {
        weatherHorizontalStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view.center)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.left.right.equalToSuperview().inset(24)
        }
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(weatherHorizontalStackView.snp.bottom).offset(100)
            make.centerX.equalTo(view.center)
            make.height.width.equalTo(150)
        }
        weatherVerticalStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view.center)
            make.top.equalTo(weatherImageView.snp.bottom).offset(16)
        }
    }
    private func configureLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    private func configure() {
        guard let viewModel = self.viewModel else {return}
        DispatchQueue.main.async {
            self.hideAnimation()
            self.weatherCityNameLabel.text = viewModel.cityName
            self.weatherTemperatureLabel.text = viewModel.temperatureString?.appending("°C")
            self.weatherImageView.image = UIImage(systemName: viewModel.statusImageName)
        }
    }
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Hata!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(alert, animated: true)
    }
    private func parseError(error: ErrorType) {
        switch error {
        case .invalidData:
            showErrorAlert(error.rawValue)
        case .invalidUrl:
            showErrorAlert(error.rawValue)
        case .decodingError:
            showErrorAlert(error.rawValue)
        }
    }
    private func showSkeletionView() {
        weatherImageView.showAnimatedGradientSkeleton()
        weatherCityNameLabel.showAnimatedSkeleton()
        weatherTemperatureLabel.showAnimatedSkeleton()
    }
    private func hideAnimation() {
        weatherImageView.stopSkeletonAnimation()
        weatherCityNameLabel.stopSkeletonAnimation()
        weatherTemperatureLabel.stopSkeletonAnimation()
    }
}
// MARK: - Location Delegate:
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        locationManager.stopUpdatingLocation()
        self.networkManager.fetchWeatherLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
            
            switch result {
            case .success(let result):
                
                self.viewModel = HomeViewModel(weatherModel: result)
            case .failure(let error):
                self.parseError(error: error)
            }
        }
    }
}
// MARK: - HorizontalStackView Delegate:
extension HomeViewController: WeatherHorizontalStackViewProtocol {
    func updatingLocation(_ stackView: WeatherHorizontalStackView) {
        self.locationManager.startUpdatingLocation()
    }
    func didFetchWeather(_ stackView: WeatherHorizontalStackView, weatherModel: Weather) {
        self.viewModel = HomeViewModel(weatherModel: weatherModel)
    }
    func didFailWithError(_ stackView: WeatherHorizontalStackView, error: ErrorType) {
        print(error)
    }
}
