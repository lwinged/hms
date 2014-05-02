//
//  HMSWebViewController.m
//  HMS
//
//  Created by flav on 06/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSWebViewController.h"

@interface HMSWebViewController ()
{
    BOOL _deleteWhiteBar;
}

@end

#define TAG 222

@implementation HMSWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;

    //fix under top bar
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height,0,self.tabBarController.tabBar.frame.size.height,0);
    
    // fix black bar -> result contentinset
    _deleteWhiteBar = YES;
    CGRect whiteBarFrame = CGRectMake(0, 0, self.tabBarController.tabBar.frame.size.width, self.webView.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:whiteBarFrame];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.tag = TAG;
    [self.webView addSubview:view];
    

    NSString *fullURL = @"http://www.booking.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_deleteWhiteBar)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %ld", @"tag", TAG];
        NSArray *filteredArray = [self.webView.subviews filteredArrayUsingPredicate:predicate];
        
        if (filteredArray.count > 0)
            [[filteredArray firstObject] removeFromSuperview];

        _deleteWhiteBar = NO;
    }
    
}

@end
