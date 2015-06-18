//
//  ComingSoonPage.m
//  MemoryGameApp
//
//  Created by Ankita Chordia on 7/26/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "ComingSoonPage.h"

@implementation ComingSoonPage



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buttonClick.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error1;
    buttonClickMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
    [buttonClickMusic prepareToPlay];

    
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comingSoonBg.png"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:backgroundImageView];
    
    UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBack.png"]];
    navImage.frame = CGRectMake(0, 0, 320, 44);
    navImage.userInteractionEnabled = YES;
    [self.view addSubview:navImage];
    
    backBtn = [[UIButton alloc] init];
    backBtn.tag = 1000;
    backBtn.frame = CGRectMake(10, 6, 72, 24);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [navImage addSubview:backBtn];
    

}

-(IBAction)goBack:(id)sender
{

    UIButton *tappedBtn = (UIButton *)sender;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    tappedBtn.selected = YES;
    tappedBtn.alpha = 1;
    tappedBtn.frame = CGRectMake(tappedBtn.frame.origin.x, tappedBtn.frame.origin.y + 4, 72, 24);
    [UIView commitAnimations];
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    [self performSelector:@selector(back) withObject:nil afterDelay:0.1];
    
}

-(void) back
{
    backBtn.frame = CGRectMake(backBtn.frame.origin.x, backBtn.frame.origin.y - 4, 72, 24);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
