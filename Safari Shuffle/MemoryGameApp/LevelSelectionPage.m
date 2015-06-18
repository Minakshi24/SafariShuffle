//
//  LevelSelectionPage.m
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "LevelSelectionPage.h"
#import "GameLogicPage.h"
#import "GamePage.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsPage.h"
#import "RootViewController.h"
#import "ComingSoonPage.h"

#import "SBJSON.h"
#import "JSON.h"
#import "FbGraphFile.h"

@implementation LevelSelectionPage

@synthesize gameCenterManager;
@synthesize currentScore;
@synthesize currentLeaderBoard;
@synthesize currentScoreLabel;

@synthesize fbGraph;

#pragma mark - View lifecycle

-(void) viewWillAppear:(BOOL)animated
{
    [self getTotalScore];
    
    grantTotal.text = [NSString stringWithFormat:@"Total Score : %d", mainDelegate.totalScore];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:backgroundImageView];
    
    UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBack.png"]];
    navImage.frame = CGRectMake(0, 0, 320, 44);
    navImage.userInteractionEnabled = YES;
    [self.view addSubview:navImage];
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreBtn.frame = CGRectMake(235, 6, 73, 24);
    moreBtn.backgroundColor = [UIColor clearColor];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setTitle:@"More" forState:UIControlStateNormal];
    //[navImage addSubview:moreBtn];
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(10, 6, 72, 24);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [navImage addSubview:backBtn];
    
    UIButton *quitBtn = [[UIButton alloc] init];
    quitBtn.frame = CGRectMake(235, 6, 73, 24);
    quitBtn.backgroundColor = [UIColor clearColor];
    [quitBtn setImage:[UIImage imageNamed:@"quitBtn.png"] forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    //[navImage addSubview:quitBtn];

    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buttonClick.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error1;
    buttonClickMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
    [buttonClickMusic prepareToPlay];
    
    //self.title = [NSString stringWithFormat:@"Total Score : %d", mainDelegate.totalScore];
    
    grantTotal = [[UILabel alloc] init];
    grantTotal.frame = CGRectMake(80, 70, 200, 30);
    grantTotal.textColor = [UIColor colorWithRed:230.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0];
    grantTotal.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:24];
    grantTotal.text = [NSString stringWithFormat:@"Total Score : %d", mainDelegate.totalScore];
    grantTotal.backgroundColor = [UIColor clearColor];
    grantTotal.layer.shadowOpacity = 1.0;
    grantTotal.layer.shadowRadius = 0.0;
    grantTotal.layer.shadowColor = [UIColor blackColor].CGColor;
    grantTotal.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    [self.view addSubview:grantTotal];
    
    int totalLevels = 6;
    int cnt = 0;
    UIButton *levelButton;
    //UILabel *cardCountLabel, *levelNumLabel;
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    
    int xx = 15+frame.origin.x, yy = 130; 
    int pageNum = 0;
    
    int columnCount = 0;
    int rowCount = 0;
    
    for(int i = 1; i <= totalLevels; i++)
    {
//        levelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        levelButton.frame = CGRectMake(xx, yy, 85, 90);
//        levelButton.contentMode = UIViewContentModeScaleAspectFit;
//        levelButton.tag = i;
//        [levelButton addTarget:self action:@selector(levelAction:) forControlEvents:UIControlEventTouchUpInside];
//        [levelButton setImage:[UIImage imageNamed:@"DarkImage_Big.png"] forState:UIControlStateNormal];
//        
//        levelNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 85, 40)];
//        levelNumLabel.text = [NSString stringWithFormat:@"Level %d", i];
//        levelNumLabel.font = [UIFont boldSystemFontOfSize:14.0];
//        levelNumLabel.backgroundColor = [UIColor clearColor];
//        levelNumLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:63.0/255.0 blue:60.0/255.0 alpha:1.0];
//        levelNumLabel.textAlignment = UITextAlignmentCenter;
//        levelNumLabel.numberOfLines = 1;
//        [levelButton addSubview:levelNumLabel];
//        
//        cardCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 85, 14)];
//        cardCountLabel.text = [NSString stringWithFormat:@"%d Cards", i*2];
//        cardCountLabel.font = [UIFont systemFontOfSize:9.0];
//        cardCountLabel.backgroundColor = [UIColor clearColor];
//        cardCountLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:63.0/255.0 blue:60.0/255.0 alpha:1.0];
//        cardCountLabel.textAlignment = UITextAlignmentCenter;
//        cardCountLabel.contentMode = UIViewContentModeScaleAspectFit;
//        cardCountLabel.numberOfLines = 1;
//        [levelButton addSubview:cardCountLabel];
        
        levelButton = [[UIButton alloc] init];
        levelButton.frame = CGRectMake(xx, yy, 85, 90);
        levelButton.contentMode = UIViewContentModeScaleAspectFit;
        levelButton.tag = i;
        [levelButton addTarget:self action:@selector(levelAction:) forControlEvents:UIControlEventTouchUpInside];
        [levelButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%d", i]] forState:UIControlStateNormal];
        [levelButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%dPressed", i]] forState:UIControlStateSelected];
        levelButton.adjustsImageWhenHighlighted = NO;
        
        [self.view addSubview:levelButton];
        
        cnt += 1; // for array count
        
        columnCount += 1;
        
        if(columnCount == 3)
        {
            xx = 15+(frame.origin.x*pageNum);
            yy = yy + 130;
            rowCount += 1;
            columnCount = 0;
        }
        else
        {
            xx = xx + 100;
        }
        
        if(rowCount == 4)
        {
            pageNum+=1;
            xx = 15+(320*pageNum);
            yy = 50;
            frame.origin.x = frame.size.width;
            rowCount = 0;
        }
    }
    
    
//    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    settingsBtn.frame = CGRectMake(20, 380, 120, 35);
//    settingsBtn.backgroundColor = [UIColor clearColor];
//    [settingsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [settingsBtn addTarget:self action:@selector(settingsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [settingsBtn setTitle:@"Settings" forState:UIControlStateNormal];
//    [self.view addSubview:settingsBtn];
//    
//    achievementsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    achievementsBtn.frame = CGRectMake(20, 420, 120, 35);
//    achievementsBtn.backgroundColor = [UIColor clearColor];
//    [achievementsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [achievementsBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
//    [achievementsBtn setTitle:@"Achievements" forState:UIControlStateNormal];
//    [self.view addSubview:achievementsBtn];
//    
//    leaderboardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    leaderboardBtn.frame = CGRectMake(200, 420, 110, 35);
//    leaderboardBtn.backgroundColor = [UIColor clearColor];
//    [leaderboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [leaderboardBtn setTitle:@"Leaderboard" forState:UIControlStateNormal];
//    [leaderboardBtn addTarget:self action:@selector(showLeaderboard:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:leaderboardBtn];
    
    //Game center
    
    self.currentLeaderBoard = kLeaderboard1ID;
    self.currentScore = 0;
    
    if ([GameCenterManager isGameCenterAvailable]) {
        
        self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
        [self.gameCenterManager setDelegate:self];
        [self.gameCenterManager authenticateLocalUser];
        
    } 
    else {
        
        // The current device does not support Game Center.
        
    }
    
    moreBtn = [[UIButton alloc] init];
    moreBtn.tag = 104;
    moreBtn.frame = CGRectMake(125, 375, 81, 36);
    moreBtn.backgroundColor = [UIColor clearColor];
    [moreBtn setImage:[UIImage imageNamed:@"moreBtn.png"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"moreBtnPressed.png"] forState:UIControlStateSelected];
    [moreBtn addTarget:self action:@selector(newMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];

}


-(IBAction)newMoreBtnAction:(id)sender
{
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    UIButton *btnTapped = (UIButton *)sender;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    btnTapped.selected = NO;
    btnTapped.alpha = 1;
    btnTapped.frame = CGRectMake(btnTapped.frame.origin.x, btnTapped.frame.origin.y + 5, 81, 36);
    [UIView commitAnimations];
    
    [self performSelector:@selector(moreActionSecond:) withObject:[NSString stringWithFormat:@"%d", [sender tag]] afterDelay:0.1];


}

-(void) moreActionSecond :(NSString *)btnTag
{
    
    RootViewController *rootViewController = [[RootViewController alloc] init];
    [self.navigationController pushViewController:rootViewController animated:NO];
    
//    UIButton *btn = (UIButton *)[self.view viewWithTag:[btnTag intValue]];
//    btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y - 5, 81, 36);
//    btn.selected = NO;
//    
//    moreView = [[UIView alloc] init];
//    moreView.frame = CGRectMake(0, 0, 320, 480);
//    moreView.backgroundColor = [UIColor lightGrayColor];
//    moreView.layer.cornerRadius = 5.0;
//    [self.view addSubview:moreView];
//    
//    UIImageView *moreBack = [[UIImageView alloc] init];
//    moreBack.frame = CGRectMake(0, 0, 320, 480);
//    moreBack.image = [UIImage imageNamed:@"moreBack1.png"];
//    [moreView addSubview:moreBack];
//    
//    
//    UIButton *fbPhotosBtn = [[UIButton alloc] init];
//    fbPhotosBtn.tag = 105;
//    fbPhotosBtn.frame = CGRectMake(30, 140, 260, 66);
//    fbPhotosBtn.backgroundColor = [UIColor clearColor];
//    [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtn.png"] forState:UIControlStateNormal];
//    [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtnPressed.png"] forState:UIControlStateSelected];
//    //[fbPhotosBtn addTarget:self action:@selector(comingSoonPage:) forControlEvents:UIControlEventTouchUpInside];
//    [fbPhotosBtn addTarget:self action:@selector(fbPhotosBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [moreView addSubview:fbPhotosBtn];
//    
//    UIButton *yourPhotosBtn = [[UIButton alloc] init];
//    yourPhotosBtn.tag = 106;
//    yourPhotosBtn.frame = CGRectMake(30, 220, 260, 66);
//    yourPhotosBtn.backgroundColor = [UIColor clearColor];
//    [yourPhotosBtn setImage:[UIImage imageNamed:@"yourPhotoBtn.png"] forState:UIControlStateNormal];
//    [yourPhotosBtn setImage:[UIImage imageNamed:@"yourPhotoBtnPressed.png"] forState:UIControlStateSelected];
//    //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
//    [yourPhotosBtn addTarget:self action:@selector(comingSoonPage:) forControlEvents:UIControlEventTouchUpInside];
//    [moreView addSubview:yourPhotosBtn];
//    
//    UIButton *memoryMatchTableGame = [[UIButton alloc] init];
//    memoryMatchTableGame.tag = 107;
//    memoryMatchTableGame.frame = CGRectMake(30, 305, 260, 66);
//    memoryMatchTableGame.backgroundColor = [UIColor clearColor];
//    [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatch.png"] forState:UIControlStateNormal];
//    [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatchPressed.png"] forState:UIControlStateSelected];
//    [memoryMatchTableGame addTarget:self action:@selector(comingSoonPage:) forControlEvents:UIControlEventTouchUpInside];
//    [moreView addSubview:memoryMatchTableGame];
//    
//    UIButton *cancelBtn = [[UIButton alloc] init];
//    cancelBtn.tag = 108;
//    cancelBtn.frame = CGRectMake(30, 390, 260, 66);
//    cancelBtn.backgroundColor = [UIColor clearColor];
//    [cancelBtn setImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
//    [cancelBtn setImage:[UIImage imageNamed:@"cancelBtnPressed.png"] forState:UIControlStateSelected];
//    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    [moreView addSubview:cancelBtn];
    
}

-(IBAction)fbPhotosBtnAction:(id)sender
{
    
    NSString *client_id = @"339861892763980";
	
	//alloc and initalize our FbGraph instance
	self.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
	
    //	//begin the authentication process.....
    //	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
    //						 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins, user_birthday"];
    
    
    //begin the authentication process.....
	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
						 andExtendedPermissions:@"user_photos,email,user_birthday,user_online_presence"];

}

#pragma mark -
#pragma mark FbGraph Callback Function
/**
 * This function is called by FbGraph after it's finished the authentication process
 **/
- (void)fbGraphCallback:(id)sender {
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} else {
		//pop a message letting them know most of the info will be dumped in the log
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:@"For the simplest code, I've written all output to the 'Debugger Console'." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
		
		NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
        
        mainDelegate.facebookPhotoFlag = TRUE;
        
        if([mainDelegate.facebookPhotoUrl count] <= 0)
        {
        
            NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/albums?access_token=%@", fbGraph.accessToken]];
            
            NSLog(@"%@", url);
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            
            NSData *urlData;
            NSURLResponse *response;
            
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            
            NSString* newStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", newStr);
            
            NSMutableArray *tempArray = [(NSDictionary*)[newStr JSONValue] objectForKey:@"data"];	

            NSMutableArray *albumIdArray = [[NSMutableArray alloc] init];
            for(int i = 0; i < [tempArray count]; i++)
            {
            
                NSDictionary *dictionary = [tempArray objectAtIndex:i];
                NSLog(@"%@",[tempArray objectAtIndex:i]);
                
                NSString *albumId = [dictionary objectForKey:@"id"];
                NSLog(@"%@", albumId);
                
                [albumIdArray addObject:albumId];
                
                NSLog(@"%d", [albumIdArray count]);
                
            }
            
            for(int j = 0; j < [albumIdArray count];j++)
            {
                url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?access_token=%@", [albumIdArray objectAtIndex:j],fbGraph.accessToken]];
                
                NSLog(@"%@", url);
                
                urlRequest = [NSURLRequest requestWithURL:url];
                
                urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
                
                NSString* responseString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", responseString);
                
                NSMutableArray *dataArray = [(NSDictionary*)[responseString JSONValue] objectForKey:@"data"];	
                
                for(int p = 0; p < [dataArray count]; p++)
                {
                
                    NSDictionary *tempDic = [dataArray objectAtIndex:p];
                    
                    NSLog(@"%@", tempDic.description);
                    
                    NSArray *imgArray = [tempDic objectForKey:@"images"];
                    
                    NSLog(@"%d", [imgArray count]);
                    
                    NSLog(@"%@", [imgArray objectAtIndex:0]);
                    
                    for(int k = 0; k < [imgArray count]; k++)
                    {
                        
                        NSLog(@"%@", [imgArray objectAtIndex:k]);
                        
                        NSDictionary *dic = [imgArray objectAtIndex:k];
                        
                        NSLog(@"%@", dic.description);
                        
                        NSString *width = [dic objectForKey:@"width"];
                        NSString *height = [dic objectForKey:@"height"];
                        NSString *imgUrl = [dic objectForKey:@"source"];
                        
                        NSLog(@"%@  %@  %@", width, height, imgUrl);
                        
                        if([width intValue] <320 && [height intValue] < 500)
                        {
                            NSLog(@"%@", imgUrl);
                            [mainDelegate.facebookPhotoUrl addObject:imgUrl];
                            break;
                        
                        }
                    
                    }
                
                }
                 
            }
            
            NSLog(@"%d", [mainDelegate.facebookPhotoUrl count]);
        }
        
        [self.navigationController popViewControllerAnimated:NO];
        
        //To get the albums 
        //https://graph.facebook.com/me/albums?access_token=AAAFHZBXFW3ZC4BADYj9QZCkArTAKODcCdqrymmEWFYor95xPtZCE1W5mZAd7dDZAk1DZBBAzL2KwO4UoXO09unHGJPnW8AKS4AdSVlRZAj3aiAZDZD
        
        //to get the photos on the basis of album id
        //https://graph.facebook.com/171202463013994/photos?access_token=AAAFHZBXFW3ZC4BADYj9QZCkArTAKODcCdqrymmEWFYor95xPtZCE1W5mZAd7dDZAk1DZBBAzL2KwO4UoXO09unHGJPnW8AKS4AdSVlRZAj3aiAZDZD
        
	}
	
}

-(IBAction)comingSoonPage:(id)sender
{
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    UIButton *btnTapped = (UIButton *)sender;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    btnTapped.selected = NO;
    btnTapped.alpha = 1;
    btnTapped.frame = CGRectMake(btnTapped.frame.origin.x, btnTapped.frame.origin.y + 5, 260, 66);
    [UIView commitAnimations];
    
    [self performSelector:@selector(comingSoonAction:) withObject:[NSString stringWithFormat:@"%d", [sender tag]] afterDelay:0.1];
    
    
}

-(void) comingSoonAction :(NSString *)btnTag
{
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:[btnTag intValue]];
    btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y - 5, 260, 66);
    btn.selected = NO;
    
    ComingSoonPage *comingSoonPage = [[ComingSoonPage alloc] initWithNibName:@"ComingSoonPage" bundle:nil];
    [self.navigationController pushViewController:comingSoonPage animated:NO];
    
}


-(IBAction)settingsBtnAction:(id)sender
{
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    SettingsPage *settingsPage = [[SettingsPage alloc] initWithNibName:@"SettingsPage" bundle:nil];
    [self.navigationController pushViewController:settingsPage animated:NO];

}

-(IBAction)moreBtnAction:(id)sender
{
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    RootViewController *rootViewController = [[RootViewController alloc] init];
    [self.navigationController pushViewController:rootViewController animated:NO];
    
    
//    moreView = [[UIView alloc] init];
//    moreView.frame = CGRectMake(30, 70, 260, 380);
//    moreView.backgroundColor = [UIColor lightGrayColor];
//    moreView.layer.cornerRadius = 5.0;
//    [self.view addSubview:moreView];
//    
//    UILabel *moreTitleLabel = [[UILabel alloc] init];
//    moreTitleLabel.frame = CGRectMake(80, 15, 100, 25);
//    moreTitleLabel.backgroundColor = [UIColor clearColor];
//    moreTitleLabel.textColor = [UIColor blackColor];
//    moreTitleLabel.textAlignment = UITextAlignmentCenter;
//    moreTitleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:22];
//    moreTitleLabel.text = @"More";
//    [moreView addSubview:moreTitleLabel];
//    
//    UIButton *yourPhotosBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    yourPhotosBtn.frame = CGRectMake(10, 60, 240, 30);
//    yourPhotosBtn.backgroundColor = [UIColor clearColor];
//    [yourPhotosBtn.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:14]];
//    [yourPhotosBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
//    [yourPhotosBtn setTitle:@"Play with your photos!" forState:UIControlStateNormal];
//    [moreView addSubview:yourPhotosBtn];
//    
//    UIButton *fbPhotosBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    fbPhotosBtn.frame = CGRectMake(10, 110, 240, 30);
//    fbPhotosBtn.backgroundColor = [UIColor clearColor];
//    [fbPhotosBtn.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:14]];
//    [fbPhotosBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
//    [fbPhotosBtn setTitle:@"Play with your facebook profile photos!" forState:UIControlStateNormal];
//    [moreView addSubview:fbPhotosBtn];
//    
//    UIButton *memoryMatchTableGame = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    memoryMatchTableGame.frame = CGRectMake(10, 160, 240, 30);
//    memoryMatchTableGame.backgroundColor = [UIColor clearColor];
//    [memoryMatchTableGame.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:14]];
//    [memoryMatchTableGame setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
//    [memoryMatchTableGame setTitle:@"Memory Match Times Tables (free)" forState:UIControlStateNormal];
//    [moreView addSubview:memoryMatchTableGame];
//
//    UIButton *removeAddsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    removeAddsBtn.frame = CGRectMake(10, 210, 240, 30);
//    removeAddsBtn.backgroundColor = [UIColor clearColor];
//    [removeAddsBtn.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:14]];
//    [removeAddsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
//    [removeAddsBtn setTitle:@"Remove Adds" forState:UIControlStateNormal];
//    [moreView addSubview:removeAddsBtn];
//
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cancelBtn.frame = CGRectMake(10, 260, 240, 30);
//    cancelBtn.backgroundColor = [UIColor clearColor];
//    [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:14]];
//    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//    [moreView addSubview:cancelBtn];
    

}

-(IBAction)rateBtnAction:(id)sender
{
    
    NSString *str = @"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=546977811&type=Purple+Software";
    
    NSURL *url = [[NSURL alloc] initWithString:str];
    [[UIApplication sharedApplication] openURL:url];

}

-(IBAction)cancelAction:(id)sender
{
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    UIButton *btnTapped = (UIButton *)sender;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    btnTapped.selected = NO;
    btnTapped.alpha = 1;
    btnTapped.frame = CGRectMake(btnTapped.frame.origin.x, btnTapped.frame.origin.y + 5, 260, 66);
    [UIView commitAnimations];
    
    
    [self performSelector:@selector(cancelActionSecond:) withObject:[NSString stringWithFormat:@"%d", [sender tag]] afterDelay:0.1];
    
}

-(void) cancelActionSecond :(NSString *)btnTag
{
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:[btnTag intValue]];
    btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y - 5, 260, 66);
    btn.selected = NO;
    
    
    [moreView removeFromSuperview];
    moreView = nil;
    
}  

-(IBAction)showAchievements:(id)sender
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL)
    {
        achievements.achievementDelegate = self;
        [self presentModalViewController: achievements animated: YES];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
    [self dismissModalViewControllerAnimated: YES];
    [viewController release];
}

-(IBAction)showLeaderboard:(id)sender
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL) 
    {
        leaderboardController.category = nil;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self; 
        [self presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
    [viewController release];
}

-(void) getTotalScore
{
    
    mainDelegate.totalScore = 0;
    
    [self initDatabase];
    
    sqlite3_stmt *selectStmt = nil;
    
    if(sqlite3_open(dbpath, &memoryappDB) == SQLITE_OK){
        
        NSString *selectQuery = @"select score from ScoreTbl";
        
        const char *query_stmt = [selectQuery UTF8String];
        
        selectQuery = nil;
        
        if (sqlite3_prepare_v2(memoryappDB, query_stmt, -1, &selectStmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                
                NSString *levelScore = [[ NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
                NSLog(@"%@", levelScore);
                
                mainDelegate.totalScore = mainDelegate.totalScore + [levelScore intValue];
                
                NSLog(@"%d", mainDelegate.totalScore);
                
             }
            sqlite3_finalize(selectStmt);
        }
        sqlite3_close(memoryappDB);
        
    }
    else 
	{
        NSLog(@"Error : %s", sqlite3_errmsg(memoryappDB));
		sqlite3_close(memoryappDB);
	}	

}

-(IBAction)goBack:(id)sender
{
    
    //[self dismissModalViewControllerAnimated:YES];
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }

    
    [self.navigationController popViewControllerAnimated:NO];

}

-(IBAction)quitAction:(id)sender
{
    
    UIAlertView *quitAlertView = [[UIAlertView alloc] initWithTitle:@"Quite to menu?" message:@"Are you sure you want to quit ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quit", nil];
    quitAlertView.tag = 300;
    [quitAlertView show];

}

-(IBAction)levelAction : (id)sender
{
    
    UIButton *tappedBtn = (UIButton *)sender;
    
    if(tappedBtn.selected)
    {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:[UIApplication sharedApplication]];
        [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
        tappedBtn.selected = NO;
        tappedBtn.alpha = 1;
        tappedBtn.frame = CGRectMake(tappedBtn.frame.origin.x, tappedBtn.frame.origin.y - 5, 85, 90);
        [UIView commitAnimations];
        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:1.0];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
//                               forView:tappedBtn 
//                                 cache:YES];
//        [UIView commitAnimations];

    
    }
    else if(!tappedBtn.selected)
    {
        
        [buttonClickMusic play];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:[UIApplication sharedApplication]];
        [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
        tappedBtn.selected = YES;
        tappedBtn.alpha = 1;
        tappedBtn.frame = CGRectMake(tappedBtn.frame.origin.x, tappedBtn.frame.origin.y + 5, 85, 90);
        [UIView commitAnimations];

        
        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:1.0];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
//                               forView:tappedBtn 
//                                 cache:YES];
//        [UIView commitAnimations];

    
    }
    
    [self performSelector:@selector(showGamePage:) withObject:[NSString stringWithFormat:@"%d", [sender tag]] afterDelay:0.1];
    
}

-(void) showGamePage : (NSString *)btnTag
{
    
//    GameLogicPage *gameLogicPage = [[GameLogicPage alloc] initWithNibName:@"GameLogicPage" bundle:nil];
//    gameLogicPage.selectedLevel = [btnTag intValue];
//    gameLogicPage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentModalViewController:gameLogicPage animated:YES];

    GamePage *gameLogicPage = [[GamePage alloc] initWithNibName:@"GamePage" bundle:nil];
    gameLogicPage.selectedLevel = [btnTag intValue];
    //gameLogicPage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentModalViewController:gameLogicPage animated:NO];
    [self.navigationController pushViewController:gameLogicPage animated:YES];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:[btnTag intValue]];
    btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y - 5, 85, 90);
    btn.selected = NO;
    
}


-(void) alertView:(UIAlertView *)AlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(AlertView.tag == 300)
    {
        
        if(buttonIndex == 1)
        {
            //[self dismissModalViewControllerAnimated:NO];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if(buttonIndex == 0)
        {
            
        }
        
    }

}

- (void) initDatabase
{	
	BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    NSError *error; 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MemoryAppDb.sqlite"]; 
    success = [fileManager fileExistsAtPath:writableDBPath];
	dbpath = [writableDBPath UTF8String];
	
	NSLog(@"path : %@", writableDBPath); 
    if (success) return;
	
	// The writable database does not exist, so copy the default to the appropriate location. 
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MemoryAppDb.sqlite"];
	
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error]; 
	if (!success)  
	{ 
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]); 
	} 
	
	dbpath = [writableDBPath UTF8String];
	NSLog(@"path : %@", writableDBPath); 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else 
        return NO;

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
