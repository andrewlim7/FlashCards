//
//  FlashCardViewController.m
//  FlashCards
//
//  Created by Andrew Lim on 27/05/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

#import "FlashCardViewController.h"

@interface FlashCardViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionRemainingLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextField;
@property (weak, nonatomic) IBOutlet UITextView *answerTextField;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;



@property NSMutableArray *questionsList;
@property NSMutableArray *answersList;
@property NSString *aList;
@property NSUInteger currentIndex;
@property NSInteger noOfGuesses;
@property NSInteger seconds;
@property NSTimer *timer;
@property NSInteger minutes;
@property NSInteger currentTime;

@end

@implementation FlashCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.answerTextField.delegate = self;
    
    self.seconds = 0;
    
    self.noOfGuesses = 0;
    
    self.questionsList = [[NSMutableArray alloc] initWithObjects:@"How old is Andrew Lim this year?", @"Where am I now?", @"Is agumon part of a pokemon?", @"Is Andrew smart?",nil];
    
    self.answersList = [[NSMutableArray alloc] initWithObjects:@"23",@"NEXT academy",@"No",@"Yes", nil];
    
    [self toRandomQuestion];
    
    self.questionRemainingLabel.text =  [NSString stringWithFormat:@"Questions Remaining: %lu",[self.questionsList count]];
    
    [self startTimer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//hide the keyboard but cannot add new line...
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer) userInfo:nil repeats:YES];
}

-(void)myTimer{
    self.seconds ++;
    
    if(self.seconds == 60){
        
        self.seconds = 0;
        self.minutes ++;
    }
    
    //self.timerLabel.text = [NSString stringWithFormat:@"Time: %li",self.seconds];
    
    //Formate the time into 00:00
    self.timerLabel.text = [NSString stringWithFormat:@"Time: %02ld:%02ld", (long)self.minutes, (long)self.seconds];
}

- (IBAction)submitAnswerButton:(id)sender {
    
    if([self.answerTextField.text isEqualToString:@""]){
        [self emptyAlert];
        
        
    } else {
        
        if([self.answerTextField.text isEqualToString:self.aList]){
            
            [self removeQandA];
            
            self.questionRemainingLabel.text =  [NSString stringWithFormat:@"Questions Remaining: %lu",[self.questionsList count]];
            
            self.noOfGuesses += 1;
            NSLog(@"No of Guesses : %li",self.noOfGuesses);
            
            if(self.questionsList.count == 0) {
                
                [self victoryAlert];
                [self.timer invalidate];
                
            } else {
                
                [self toRandomQuestion];
            }
            
        } else {
            
            self.noOfGuesses += 1;
            NSLog(@"No of Guesses : %li",self.noOfGuesses);
            [self tryAgainAlert];
        }
        
    }
    
}

-(void)toRandomQuestion {
    
    self.currentIndex = arc4random() % [self.questionsList count];
    
    self.questionTextField.text = [self.questionsList objectAtIndex:self.currentIndex];
    
    self.aList = [self.answersList objectAtIndex:self.currentIndex];
    
    self.answerTextField.text = @"";
}

-(void)removeQandA {
    [self.questionsList removeObjectAtIndex:self.currentIndex];
    [self.answersList removeObjectAtIndex:self.currentIndex];
}


-(void)victoryAlert {
    
    UIAlertController *victoryAlert = [UIAlertController alertControllerWithTitle:@"VICTORY!" message:[NSString stringWithFormat:@"congratulations! You made %ld guesses!", (long)self.noOfGuesses] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartGame = [UIAlertAction actionWithTitle:@"Restart Game!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.seconds = 0;
        self.timerLabel.text = [NSString stringWithFormat:@"Time: %li",self.seconds];
        self.noOfGuesses = 0;
        
        self.questionsList = [[NSMutableArray alloc] initWithObjects:@"How old is Andrew Lim this year?", @"Where am I now?", @"Is agumon part of a pokemon?", @"Is Andrew smart?",nil];
        
        self.answersList = [[NSMutableArray alloc] initWithObjects:@"23",@"NEXT academy",@"Yes",@"Yes", nil];
        
        self.questionRemainingLabel.text = [NSString stringWithFormat:@"Questions Remaining: %lu",[self.questionsList count]];
        [self toRandomQuestion];
        [self startTimer];
        
        self.answerTextField.text = @"";
        
    }];
    
    [victoryAlert addAction:restartGame];
    
    [self presentViewController:victoryAlert animated:YES completion:nil];
    
}

-(void)emptyAlert {
    
    UIAlertController *emptyAlert = [UIAlertController alertControllerWithTitle:@"Opps!" message:@"Answer text field cannot be empty!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"okay" style:UIAlertActionStyleDefault handler:nil];
    
    [emptyAlert addAction:ok];
    
    [self presentViewController:emptyAlert animated:YES completion:nil];
    
}

-(void)tryAgainAlert {
    
    UIAlertController *tryAlert = [UIAlertController alertControllerWithTitle:@"Opps!" message:@"Please try again! Answer is case sensitive and space sensitive!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"okay" style:UIAlertActionStyleDefault handler:nil];
    
    [tryAlert addAction:ok];
    
    [self presentViewController:tryAlert animated:YES completion:nil];

}

- (IBAction)hintButtonTapped:(id)sender {
    
    [self hintAlert];
    
}

-(void)hintAlert {
    
    
    UIAlertController *hintAlert = [UIAlertController alertControllerWithTitle:@"HINT!" message:@"There are 4 hints!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *hint1 = [UIAlertAction actionWithTitle:@"23" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        self.answerTextField.text = @"23";
        
    }];
    
    UIAlertAction *hint2 = [UIAlertAction actionWithTitle:@"NEXT academy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.answerTextField.text = @"NEXT academy";
        
    }];
    
    UIAlertAction *hint3 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.answerTextField.text = @"No";
        
    }];
    
    UIAlertAction *hint4 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.answerTextField.text = @"Yes";
        
        
    }];
    
    [hintAlert addAction:hint1];
    [hintAlert addAction:hint2];
    [hintAlert addAction:hint3];
    [hintAlert addAction:hint4];
    
    [self presentViewController:hintAlert animated:YES completion:nil];
    
}


@end
