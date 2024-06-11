//
//  HUDView.swift
//  RoadFeatures
//
//  Created by Alex Gav on 07.06.2024.
//

import UIKit
import Lottie

final class HUDView: UIView {
    
    // MARK: - Private Static Properties
    
    private static let containerDelay: TimeInterval = 0.15
    private static let autoDismissDelay: TimeInterval = 1.3
    
    // MARK: - Private Properties
    
    private let type: HUDType
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .black.withAlphaComponent(0.9)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.alpha = 0
        return view
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: type.title)
        view.loopMode = type.isLoader ? .loop : .playOnce
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.text = type.message
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initialization
    
    init(type: HUDType) {
        self.type = type
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func present(
        from window: UIWindow,
        withDuration duration: TimeInterval = 1
    ) {
        window.addSubview(self)
        configureConstraints()
        
        animate(withDuration: duration) { [weak self] in
            self?.alpha = 1
            self?.animationView.play()
        } completion: { [weak self] in
            self?.isUserInteractionEnabled = true
            self?.dismissIfNeeded()
        }
        
        animate(
            withDuration: duration,
            delay: Self.containerDelay
        ) { [weak self] in
            self?.containerView.alpha = 1
            self?.containerView.transform = .identity
        } completion: {}
    }
    
    func dismiss(
        withDuration duration: TimeInterval = 0.65,
        completion: (() -> Void)? = nil
    ) {
        isUserInteractionEnabled = false
        
        animate(withDuration: duration) { [weak self] in
            self?.containerView.alpha = 0
            self?.containerView.transform = .init(translationX: 0, y: -100)
        }
        
        animate(
            withDuration: duration,
            delay: Self.containerDelay
        ) { [weak self] in
            self?.alpha = 0
        } completion: { [weak self] in
            self?.removeFromSuperview()
            completion?()
        }
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        backgroundColor = .black.withAlphaComponent(0.6)
        isUserInteractionEnabled = false
        alpha = 0
        configureTapGestureIfNeeded()
    }
    
    private func configureConstraints() {
        if let superview {
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                topAnchor.constraint(equalTo: superview.topAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
        
        // Container View
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.49)
        ])
        
        // Animation View
        containerView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 36),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -36),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
        
        // Label
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    private func dismissIfNeeded() {
        guard type.isAutoDismissable else {
            return
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + Self.autoDismissDelay
        ) { [weak self] in
            self?.dismiss()
        }
    }
    
    private func animate(
        withDuration duration: TimeInterval,
        delay: TimeInterval = 0,
        animations: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration, delay: delay,
            usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5,
            options: [.beginFromCurrentState, .curveEaseIn],
            animations: animations,
            completion:  { _ in completion?() }
        )
    }
    
    @objc private func didTapView() {
        dismiss()
    }
    
    private func configureTapGestureIfNeeded() {
        guard type.shouldDismissOnTap else {
            return
        }
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapView)
        )
        
        addGestureRecognizer(tapGesture)
    }
}
