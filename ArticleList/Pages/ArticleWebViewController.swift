//
//  ArticleWebViewController.swift
//  ArticleList
//
//  Created by KuanWei on 2020/2/1.
//  Copyright © 2020 hayasilin. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController {
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        return webView
    }()

    lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progressTintColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var observation: NSKeyValueObservation?

    var viewModel: ArticleWebViewModel

    deinit {
        observation = nil
    }

    init(viewModel: ArticleWebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !progressView.isHidden {
            progressView.isHidden = true
        }
    }

    func setupViews() {
        title = viewModel.title

        setupProgressView()
        setupEstimatedProgressObserver()

        view.addSubview(webView)
        webView.navigationDelegate = self
        loadWebView()
    }

    func setupProgressView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.addSubview(progressView)
        progressView.isHidden = true
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0),
            ])
    }

    func setupEstimatedProgressObserver() {
        observation = webView.observe(\WKWebView.estimatedProgress, options: .new, changeHandler: { [weak self] (webView, change) in
            self?.progressView.progress = Float(webView.estimatedProgress)
        })
    }

    func loadWebView() {
        if let url = viewModel.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension ArticleWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if progressView.isHidden {
            progressView.isHidden = false
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
}
