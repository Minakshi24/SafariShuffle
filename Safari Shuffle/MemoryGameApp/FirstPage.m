//
//  ViewController.m
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "FirstPage.h"
#import "LevelSelectionPage.h"
#import "SettingsPage.h"
#import "RootViewController.h"
#import "ComingSoonPage.h"
#import <StoreKit/StoreKit.h>
#import "GamePage.h"
#import "HighScorePage.h"

@implementation FirstPage

@synthesize w, h;

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *tempEasyBtn = (UIButton *)[self.view viewWithTag:100];
    UIButton *tempHardBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *tempHighScoreBtn = (UIButton *)[self.view viewWithTag:102];
    
    if(tempEasyBtn.selected)
    {
        tempEasyBtn.selected = NO;
    }
    if(tempHardBtn.selected)
    {
        tempHardBtn.selected = NO;
    }
    if(tempHighScoreBtn.selected)
    {
        tempHighScoreBtn.selected = NO;
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    w  = mainDelegate.window.frame.size.width;
    h = mainDelegate.window.frame.size.height;
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_iPad.png"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320*w/320, 480*h/480);
    [self.view addSubview:backgroundImageView];
    
    UIButton *easyBtn  = [[UIButton alloc] init];
    easyBtn.tag = 100;
    easyBtn.frame = CGRectMake(57*w/320, 302*h/480, 100*w/320, 56*h/480);
    [easyBtn setImage:[UIImage imageNamed:@"easyBtn_iPad.png"] forState:UIControlStateNormal];
    [easyBtn setImage:[UIImage imageNamed:@"easyPressed_iPad.png"] forState:UIControlStateSelected];
    [easyBtn addTarget:self action:@selector(levelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:easyBtn];
    [easyBtn release];
    
    UIButton *hardBtn  = [[UIButton alloc] init];
    hardBtn.tag = 101;
    hardBtn.frame = CGRectMake(169*w/320, 302*h/480, 100*w/320, 59*h/480);
    [hardBtn setImage:[UIImage imageNamed:@"hardBtn_iPad.png"] forState:UIControlStateNormal];
    [hardBtn setImage:[UIImage imageNamed:@"hardBtnPressed_iPad.png"] forState:UIControlStateSelected];
    [hardBtn addTarget:self action:@selector(levelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hardBtn];
    [hardBtn release];
    
    UIButton *highScoreBtn  = [[UIButton alloc] init];
    highScoreBtn.tag = 102;
    highScoreBtn.frame = CGRectMake(60*w/320, 360*h/480, 202*w/320, 67*h/480);
    [highScoreBtn setImage:[UIImage imageNamed:@"highScoreBtn_iPad.png"] forState:UIControlStateNormal];
    [highScoreBtn setImage:[UIImage imageNamed:@"highScoreBtnPressed_iPad.png"] forState:UIControlStateSelected];
    [highScoreBtn addTarget:self action:@selector(highScoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:highScoreBtn];
    [highScoreBtn release];

    //Music
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buttonClick.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error1;
    buttonClickMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
    [buttonClickMusic prepareToPlay];
}

-(IBAction)levelAction:(id)sender
{
    UIButton *tappedBtn = (UIButton *)sender;
    
    [buttonClickMusic play];
    
    tappedBtn.selected = YES;
    
    GamePage *gamePage = [[GamePage alloc] initWithNibName:@"GamePage" bundle:nil];
    gamePage.selectedLevel = [tappedBtn tag];
    [self.navigationController pushViewController:gamePage animated:YES];
}

-(IBAction)highScoreAction:(id)sender
{
    UIButton *tappedBtn = (UIButton *)sender;
    
    [buttonClickMusic play];
    
    tappedBtn.selected = YES;
    
    HighScorePage *highScorePage = [[HighScorePage alloc] initWithNibName:@"HighScorePage" bundle:nil];
    [self.navigationController pushViewController:highScorePage animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else 
        return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
