//
//  RecordAndPlayView.swift
//  VoiceRecorder
//
//  Created by Mac on 2022/06/29.
//

import AVFoundation
import UIKit

class RecordControllerView: UIView {
    private let networkManager =  RecordNetworkManager.shared
    private let recordManager: RecordService!
    var delegate: RecordControllerDelegate?

    var viewModel: RecordControllerViewModel!

    private let recordButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "circle.fill", state: .normal)
        button.setImage(systemName: "square.fill", state: .selected)
        button.tintColor = .red
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true

        button.addTarget(self, action: #selector(didTapRecordButton(sender:)), for: .touchUpInside)
        return button
    }()

    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "arrow.down.circle", state: .normal)
        button.tintColor = .label
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true

        button.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        return button
    }()
    
    init(_ recordManager: RecordService) {
        self.recordManager = recordManager
        
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action
    @objc func didTapRecordButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            recordManager.startRecord()
        } else {
            recordManager.endRecord()
            delegate?.endRecord()
        }
    }
    
    @objc func didTapDownloadButton() {
        let file = recordManager.dateToFileName(Date()) + "+" + viewModel.duration()
        // 저장 후 dismiss
        networkManager.saveRecord(filename: file)
    }
}

extension RecordControllerView {
    func bind(_ viewModel: RecordControllerViewModel) {
        self.viewModel = viewModel
    }

    private func layout() {
        [
            recordButton,
            downloadButton,
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        recordButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        recordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true

        downloadButton.bottomAnchor.constraint(equalTo: recordButton.bottomAnchor).isActive = true
        downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
    }
}
