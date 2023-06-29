//
//  ViewController.swift
//  HW12
//
//  Created by Helena on 20.06.2023.
//

import UIKit

var isStarted = false // показывает запущен ли таймер или находится на паузе
var isWorkTime = true // показывает запущен ли таймер для рабочего времени или нет

class ViewController: UIViewController {
    
    private var timer = Timer()
    private let workTimeDuration = 10
    private let restTimeDuration = 5
    private lazy var currentTime = workTimeDuration
    
    // MARK: - UI Elements
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = String(workTimeDuration)
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
        
        switch (isStarted, isWorkTime) {
        case (true, true):
            if timerLabel.text == String(workTimeDuration) {
                circularProgressBarView.progressAnimation(duration: TimeInterval(Int(timerLabel.text!)!), from: 1, to: 0)
            } else {
                circularProgressBarView.resumeAnimation()
            }
            button.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
            button.tintColor = .systemGreen
            timerLabel.textColor = .systemGreen
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in self.timerLabel.text = String(Int(self.timerLabel.text!)! - 1)
                
                if self.timerLabel.text == "0" {
                    timer.invalidate()
                    isStarted.toggle()
                    isWorkTime.toggle()
                    self.currentTime = self.restTimeDuration
                    self.timerLabel.text = String(self.currentTime)
                    self.timerLabel.textColor = .systemRed
                    self.button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
                    self.button.tintColor = .systemRed
                    self.circularProgressBarView.resetAnimation()
                }
            }
        case (true, false):
            if timerLabel.text == String(restTimeDuration) {
                circularProgressBarView.progressAnimation(duration: TimeInterval(Int(timerLabel.text!)!), from: 1, to: 0)
            } else {
                circularProgressBarView.resumeAnimation()
            }
            button.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
            button.tintColor = .systemRed
            timerLabel.textColor = .systemRed
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in self.timerLabel.text = String(Int(self.timerLabel.text!)! - 1)
                
                if self.timerLabel.text == "0" {
                    timer.invalidate()
                    isStarted.toggle()
                    isWorkTime.toggle()
                    self.currentTime = self.workTimeDuration
                    self.timerLabel.text = String(self.currentTime)
                    self.timerLabel.textColor = .systemGreen
                    self.button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
                    self.button.tintColor = .systemGreen
                    self.circularProgressBarView.resetAnimation()
                }
            }
        case (false, false):
            circularProgressBarView.pauseAnimation()
            button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
            button.tintColor = .systemRed
            timerLabel.textColor = .systemRed
            timer.invalidate()
        case (false, true):
            circularProgressBarView.pauseAnimation()
            button.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
            button.tintColor = .systemGreen
            timerLabel.textColor = .systemGreen
            timer.invalidate()
        }
    }
}
