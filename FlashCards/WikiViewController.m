//
//  WikiViewController.m
//  FlashCards
//
//  Created by Andrew Lim on 28/05/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

#import "WikiViewController.h"

@interface WikiViewController () <UIWebViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingCircle;

@end

@implementation WikiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.webView.delegate = self;
    self.inputURL.delegate = self;
    
    [self loadPage:@"https://en.wikipedia.org/wiki/Flashcard"];
    [self.loadingCircle setHidesWhenStopped:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPage: (NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.inputURL endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Return button tapped");
    //hide keyboard when done editing
    [textField endEditing:YES];
    
    
    NSString *currentURL = self.inputURL.text;
    NSURL *myURL;
    if ([currentURL hasPrefix:@"https://"]) {
        [self loadPage:currentURL];
    } else {
        myURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@",currentURL]];
        NSLog(@"%@", myURL);
        [self loadPage:myURL.absoluteString];
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.loadingCircle startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingCircle stopAnimating];
}

@end
