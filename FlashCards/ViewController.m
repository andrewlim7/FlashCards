//
//  ViewController.m
//  FlashCards
//
//  Created by Andrew Lim on 27/05/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self.navigationController setNavigationBarHidden:YES];
}

//stackoverflow.com/questions/23412756/how-to-hide-navigation-bar-on-a-particular-view-controller-inside-of-navigation
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wikiVCButton:(id)sender {
    
    [self performSegueWithIdentifier:@"WikiVC" sender:self];
}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}



@end
