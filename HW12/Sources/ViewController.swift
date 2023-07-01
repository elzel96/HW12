//
//  ViewController.swift
//  HW12
//
//  Created by Helena on 20.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private var isStarted = false // показывает запущен ли таймер или находится на паузе
    private var isWorkTime = true // показывает запущен ли таймер для рабочего времени или нет
    private var timer = Timer()
    private let workTimeDuration = 10.0
    private let restTimeDuration = 5.0
    private lazy var currentTime = workTimeDuration
    private lazy var speed = 0.0
    
    // MARK: - UI Elements
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = String(Int(workTimeDuration))
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 55)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGreen
        button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var circularProgressBarView: CircularProgressBarView = {
        let view = CircularProgressBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupHierarchy() {
        view.addSubview(timerLabel)
        view.addSubview(button)
        view.addSubview(circularProgressBarView)
    }
    
    private func setupLayout() {
        let height = view.bounds.height
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: height * 0.44),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: height * 0.02),
            
            circularProgressBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularProgressBarView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Action
    
    @objc private func buttonTapped() {
        isStarted.toggle()
        
        guard isStarted else {
            circularProgressBarView.pauseAnimation()
            timer.invalidate()
            button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
            return
        }
        
        circularProgressBarView.resumeAnimation()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerActivated), userInfo: nil, repeats: true)
        button.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
    }

    @objc private func timerActivated() {
        let formatter = DateFormatter()
        let rounded = speed.rounded(.up)
        let date = Date(timeIntervalSince1970: TimeInterval(rounded))

        formatter.dateFormat = "ss"
        timerLabel.text = formatter.string(from: date)

        guard rounded == 0 else {
            speed -= 0.01
            return
        }
        
        if isWorkTime {
            timerLabel.textColor = .systemGreen
            button.tintColor = .systemGreen
            currentTime = workTimeDuration
            speed = workTimeDuration
        } else {
            timerLabel.textColor = .systemRed
            button.tintColor = .systemRed
            currentTime = restTimeDuration
            speed = restTimeDuration
        }

        circularProgressBarView.progressAnimation(duration: currentTime, from: 1, to: 0, isWorkTime: &isWorkTime)
    }
}
