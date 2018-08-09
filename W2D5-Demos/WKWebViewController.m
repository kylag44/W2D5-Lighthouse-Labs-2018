//
//  WKWebViewController.m
//  W2D5-Demos
//
//  Created by steve on 2017-01-19.
//  Copyright © 2017 steve. All rights reserved.
//

#import "WKWebViewController.h"

// Required for WKWebView
@import WebKit;

@interface WKWebViewController ()<WKNavigationDelegate>
@property (nonatomic) UIView *containerView;
@property (nonatomic) WKWebView *webView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@end

#define tag 200

@implementation WKWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupWKWebView];
  [self setupActivityIndicator];
}

- (void)setupWKWebView {
  // using viewWithTag
  self.containerView = [self.view viewWithTag:tag];
  self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
  self.webView.navigationDelegate = self;
  [self.containerView addSubview:self.webView];
  
  // Adding outselves as an observer for KVO
  
  [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupActivityIndicator {
  self.activityIndicator = [[UIActivityIndicatorView alloc] init];
  self.activityIndicator.hidesWhenStopped = YES;
  [self.activityIndicator startAnimating];
  self.activityIndicator.color = [UIColor redColor];
  [self.webView addSubview:self.activityIndicator];
}

- (void)viewDidLayoutSubviews {
  // seting up webView's frame once AL has setup everything
  self.webView.frame = self.containerView.frame;
  self.activityIndicator.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSURL *url = [NSURL URLWithString:@"https://stackoverflow.com"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [self.webView loadRequest:request];
}

#pragma mark - KVO

// Observing KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if ([keyPath isEqualToString:@"loading"]) {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, change);
    if ([change[@"new"] isEqualToNumber:@1]) {
      [self.activityIndicator startAnimating];
    } else {
      [self.activityIndicator stopAnimating];
    }
  }
}

// Removing KVO observer

- (void)dealloc {
  [self.webView removeObserver:self forKeyPath:@"loading"];
}

@end
