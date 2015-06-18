//
//  GamePage.m
//  MemoryGameApp
//
//  Created by Ankita Chordia on 7/3/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "GamePage.h"
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "InAppRageIAPHelper.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "ComingSoonPage.h"
#import "JSON.h"
#import "HighScorePage.h"

@implementation GamePage

@synthesize width, height;

@synthesize selectedLevel;

@synthesize gameCenterManager;
@synthesize currentScore;
@synthesize currentLeaderBoard;

@synthesize hud = _hud;
@synthesize fbGraph;
@synthesize assetGroups;

//Achievement Identifiers

#define kAchievementEasyLevels @"M_1"
#define kAchievementLevel5 @"M_2"
#define kAchievementLevel6 @"M_3"
#define kAchievementHardLevels @"M_4"
#define kAchievementLuckyGuess @"M_5"
#define kAchievementLucky6 @"M_6"
#define kAchievementLuckyMatch @"M_7"
#define kAchievementRollx2 @"M_8"
#define kAchievementRollx3 @"M_9"
#define kAchievementRollx4 @"M_10"
#define kAchievementRollx5 @"M_11"
#define kAchievementRollx6 @"M_12"
#define kAchievementRollx7 @"M_13"
#define kAchievementRollx8 @"M_14"
#define kAchievementRollx9 @"M_15"
#define kAchievementStrikex10 @"M_16"
#define kAchievementAlbumMania @"M_17"
#define kAchievementFacebook @"M_18"
#define kAchievementLevel1Master @"M_19"
#define kAchievementLevel2Master @"M_20"
#define kAchievementLevel3Master @"M_21"
#define kAchievementLevel4Master @"M_22"
#define kAchievementLevel5Master @"M_23"
#define kAchievementLevel6Master @"M_24"

//Leaderboard Idetifiers

#define kLeaderboard1ID @"1"
#define kLeaderboard2ID @"2"
#define kLeaderboard3ID @"3"
#define kLeaderboard4ID @"4"
#define kLeaderboard5ID @"5"
#define kLeaderboard6ID @"6"

#pragma mark - View lifecycle

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    prevTag = 0;
    score = 0;
    minute = 0;
    second = 0;
    pairCounter = 0;
    totalImages = 0;
    
    firstImage = nil;
    secondImage = nil;
    checkFlag = FALSE;
    firstBtn = nil;
    secondBtn = nil;
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buttonClick.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error1;
    buttonClickMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
    [buttonClickMusic prepareToPlay];
    
//    switch (selectedLevel) {
//        case 1:
//            self.currentLeaderBoard = kLeaderboard1ID;
//            break;
//            
//        case 2:
//            self.currentLeaderBoard = kLeaderboard2ID;
//            break;
//
//        case 3:
//            self.currentLeaderBoard = kLeaderboard3ID;
//            break;
//
//        case 4:
//            self.currentLeaderBoard = kLeaderboard4ID;
//            break;
//        case 5:
//            self.currentLeaderBoard = kLeaderboard5ID;
//            break;
//
//        case 6:
//            self.currentLeaderBoard = kLeaderboard6ID;
//            break;
//
//        default:
//            break;
//    }
    
    //self.currentLeaderBoard = kLeaderboardID;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    width = mainDelegate.window.frame.size.width;
    height = mainDelegate.window.frame.size.height;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levelBack_iPad.png"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320*width/320, 480*height/480);
    [self.view addSubview:backgroundImageView];
    
//    UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBack.png"]];
//    navImage.frame = CGRectMake(0, 0, 320, 44);
//    navImage.userInteractionEnabled = YES;
//    [self.view addSubview:navImage];
    
    backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(19*width/320, 14*height/480, 95*width/320, 49*height/480);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"backBtn_iPad.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"backBtnPressed_iPad.png"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
//    quitBtn = [[UIButton alloc] init];
//    quitBtn.tag = 1001;
//    quitBtn.frame = CGRectMake(235, 6, 73, 24);
//    quitBtn.backgroundColor = [UIColor clearColor];
//    [quitBtn setImage:[UIImage imageNamed:@"quitBtn.png"] forState:UIControlStateNormal];
//    [quitBtn addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navImage addSubview:quitBtn];
    
    imagesArray = [[NSMutableArray alloc] init];
    
    
//    if(mainDelegate.facebookPhotoFlag && [mainDelegate.facebookPhotoUrl count] > 0)
//    {
//        
//        //imagesArray = [mainDelegate.facebookPhotoUrl mutableCopy];
//        
//        
//        
//        for(int i = 0; i < [mainDelegate.facebookPhotoUrl count]; i++)
//        {
//        
//            switch (selectedLevel) {
//                case 1:
//                {
//                    UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(133, 119)];
//                    
//                    UIImage *img = [self mergeTwoImages:baseImage :[mainDelegate.facebookPhotoUrl objectAtIndex:i] :CGRectMake(10, 6, 112, 97)];         
//                    
//                    [imagesArray addObject:img];
//                    break;
//                }
//                    
//                case 2:
//                {
//                    
//                    UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(100, 90)];
//                    
//                    UIImage *img = [self mergeTwoImages:baseImage :[mainDelegate.facebookPhotoUrl objectAtIndex:i] :CGRectMake(8, 5, 84, 73)];         
//                    
//                    [imagesArray addObject:img];
//                    break;
//                }
//                    
//                case 3:
//                {
//                    
//                    UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(94, 84)];
//                    
//                    UIImage *img = [self mergeTwoImages:baseImage :[mainDelegate.facebookPhotoUrl objectAtIndex:i] :CGRectMake(6, 4, 80, 69)];         
//                    
//                    [imagesArray addObject:img];
//                    break;
//                }
//
//                case 4:
//                {
//                    
//                    UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(71, 66)];
//                    
//                    UIImage *img = [self mergeTwoImages:baseImage :[mainDelegate.facebookPhotoUrl objectAtIndex:i] :CGRectMake(6, 4, 59, 53)];         
//                    
//                    [imagesArray addObject:img];
//                    break;
//                }
//
//                case 5:
//                {
//                    
//                    UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(77, 69)];
//                    
//                    UIImage *img = [self mergeTwoImages:baseImage :[mainDelegate.facebookPhotoUrl objectAtIndex:i] :CGRectMake(5, 4, 65, 55)];         
//                    
//                    [imagesArray addObject:img];
//                    break;
//                }
//
//                case 6:
//                {
//                    
//                    UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(62, 55)];
//                    
//                    UIImage *img = [self mergeTwoImages:baseImage :[mainDelegate.facebookPhotoUrl objectAtIndex:i] :CGRectMake(5, 3, 51, 44)];         
//                    
//                    [imagesArray addObject:img];
//                    break;
//                }
//                    
//                default:
//                    break;
//            }
//           
//        
//        }
//        
//        
//        
////        for(int  i = 0; i < [mainDelegate.facebookPhotoUrl count]; i++)
////        {
////            NSURL *url = [[NSURL alloc] initWithString:[mainDelegate.facebookPhotoUrl objectAtIndex:i]];
////            
////            NSLog(@"%@", url);
////            
////            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
////            
////            NSData *urlData;
////            NSURLResponse *response;
////            
////            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
////            
////            UIImage *image = [UIImage imageWithData:urlData];
////            
////            [imagesArray addObject:image];
////        }
//    
//    }
//    else if(mainDelegate.yourPhotoFlag && [mainDelegate.assets count] > 0)
//    {
//        
//        NSMutableArray *usedNumberArray = [[NSMutableArray alloc] init];
//        
//        BOOL flag = FALSE;
//        
//        int tempCount = 0;
//        for(int  i = 0; i < [mainDelegate.assets count]; i++)
//        {
//            
//            int randomNoForImage = arc4random() % [mainDelegate.assets count];
//            
//            for(int j = 0; j < [usedNumberArray count]; j++)
//            {
//                if([[usedNumberArray objectAtIndex:j] intValue] == randomNoForImage)
//                {
//                    flag = TRUE;
//                    break;
//                
//                }
//            }
//            
//            if(!flag)
//            {
//                
//                CGImageRef cgImage = [[mainDelegate.assets objectAtIndex:randomNoForImage] thumbnail];
//                
//                switch (selectedLevel) {
//                    case 1:
//                    {
//                        UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(133, 119)];
//                        
//                        UIImage *img = [self mergeTwoImages:baseImage :[UIImage imageWithCGImage:cgImage] :CGRectMake(10, 6, 112, 97)];         
//                        
//                        [imagesArray addObject:img];
//                        break;
//                    }
//                        
//                    case 2:
//                    {
//                        
//                        UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(100, 90)];
//                        
//                        UIImage *img = [self mergeTwoImages:baseImage :[UIImage imageWithCGImage:cgImage] :CGRectMake(8, 5, 84, 73)];         
//                        
//                        [imagesArray addObject:img];
//                        break;
//                    }
//                        
//                    case 3:
//                    {
//                        
//                        UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(94, 84)];
//                        
//                        UIImage *img = [self mergeTwoImages:baseImage :[UIImage imageWithCGImage:cgImage] :CGRectMake(6, 4, 80, 69)];         
//                        
//                        [imagesArray addObject:img];
//                        break;
//                    }
//                        
//                    case 4:
//                    {
//                        
//                        UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(71, 66)];
//                        
//                        UIImage *img = [self mergeTwoImages:baseImage :[UIImage imageWithCGImage:cgImage] :CGRectMake(6, 4, 59, 53)];         
//                        
//                        [imagesArray addObject:img];
//                        break;
//                    }
//                        
//                    case 5:
//                    {
//                        
//                        UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(77, 69)];
//                        
//                        UIImage *img = [self mergeTwoImages:baseImage :[UIImage imageWithCGImage:cgImage] :CGRectMake(5, 4, 65, 55)];         
//                        
//                        [imagesArray addObject:img];
//                        break;
//                    }
//                        
//                    case 6:
//                    {
//                        
//                        UIImage *baseImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(62, 55)];
//                        
//                        UIImage *img = [self mergeTwoImages:baseImage :[UIImage imageWithCGImage:cgImage] :CGRectMake(5, 3, 51, 44)];         
//                        
//                        [imagesArray addObject:img];
//                        break;
//                    }
//                        
//                    default:
//                        break;
//                }
//
//                
//                
//                //[imagesArray addObject:[UIImage imageWithCGImage:cgImage]];
//                tempCount++;
//                [usedNumberArray addObject:[NSString stringWithFormat:@"%d",randomNoForImage]];
//            
//            }
//            else
//            {
//                flag = FALSE;
//            
//            }
//            
//            if(tempCount == 32)
//            {
//                
//                break;
//            
//            }
//        
//        }
//        
//    
//    }
//    else
//    {
//        for(int i = 1; i < 47; i++)
//        {
//            [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"smiley%d.png", i]]];
//        }
//    }
//    NSLog(@"%d", [imagesArray count]);
    
//    UIImageView *scoreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score.png"]];
//    scoreImage.frame = CGRectMake(10, 430, 70, 15);
//    [self.view addSubview:scoreImage];
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(234*width/320, 18*height/480, 130*width/320, 35*height/480)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:230.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0];
    if(width>640)
    {
        scoreLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:72];
    }
    else
    {
        scoreLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:42];//[UIFont systemFontOfSize:20];
    }
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
//    scoreLabel.layer.shadowOpacity = 1.0;
//    scoreLabel.layer.shadowRadius = 0.0;
//    scoreLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    scoreLabel.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    [self.view addSubview:scoreLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 433*height/480, 320*width/320, 30*height/480)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:230.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0];
    if(width>640)
    {
        timeLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:54];
    }
    else
    {
        timeLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:28];
    }
    timeLabel.textAlignment = UITextAlignmentCenter;
    timeLabel.text = [NSString stringWithFormat:@"%02d : %02d", minute, second];
//    timeLabel.layer.shadowOpacity = 1.0;
//    timeLabel.layer.shadowRadius = 0.0;
//    timeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    timeLabel.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    [self.view addSubview:timeLabel];
    
    if(mainDelegate.soundFlag)
    {
        NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/newCorrect.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSError *error1;
        correctMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
        [correctMusic prepareToPlay];
        
        NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/wrong.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSError *error2;
        wrongMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error2];
        [wrongMusic prepareToPlay];
    }
    
//    if ([GameCenterManager isGameCenterAvailable]) {
//        
//        self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
//        [self.gameCenterManager setDelegate:self];
//        [self.gameCenterManager authenticateLocalUser];
//        
//        
//    } else {
//        
//        // The current device does not support Game Center.
//        
//    }
    
    int noOfImagesRequired = 0;
    switch (selectedLevel) {
        case 100:
            noOfImagesRequired = 6;
            for(int i = 1; i < 7; i++)
            {
                [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Easy%d.png", i]]];
            }
            break;
            
        case 101:
            noOfImagesRequired = 10;
            for(int i = 1; i < 11; i++)
            {
                [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Hard%d.png", i]]];
            }
            break;
            
        default:
            break;
    }
    
    if([imagesArray count] >= noOfImagesRequired)
    {
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [self generateTheGameLogic];
    }
    else 
    {
        UIAlertView *pictureAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry you don't have enough pictures" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [pictureAlert show];
    
    }
    
    
}

-(IBAction)enterInitialAction:(id)sender
{
    
    UIButton *tappedBtn = (UIButton *)sender;
    tappedBtn.selected = YES;
    
    initialBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enterInitialBg1.png"]];
    initialBg.frame = CGRectMake(0, 0, 320*width/320, 480*height/480);
    initialBg.backgroundColor = [UIColor clearColor];
    initialBg.userInteractionEnabled = YES;
    [scoreBoard addSubview:initialBg];
    
    UIButton *doneBtn = [[UIButton alloc] init];
    doneBtn.frame = CGRectMake(69*width/320, 214*height/480, 85*width/320, 35*height/480);
    [doneBtn setImage:[UIImage imageNamed:@"doneBtn.png"] forState:UIControlStateNormal];
    [doneBtn setImage:[UIImage imageNamed:@"doneBtnPressed.png"] forState:UIControlStateSelected];
    [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.adjustsImageWhenHighlighted = NO;
    [initialBg addSubview:doneBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(159*width/320, 214*height/480, 85*width/320, 35*height/480);
    [cancelBtn setImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"cancelBtnPressed.png"] forState:UIControlStateSelected];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.adjustsImageWhenHighlighted = NO;
    [initialBg addSubview:cancelBtn];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.tag = 103;
    tf.delegate = self;
    tf.frame = CGRectMake(69*width/320, 151*height/480, 175*width/320, 34*height/480);
    tf.backgroundColor = [UIColor clearColor];
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    if(width > 640)
    {
        tf.font = [UIFont fontWithName:@"GoodDog Cool" size:46];
    }
    else
    {
        tf.font = [UIFont fontWithName:@"GoodDog Cool" size:34];
    }
    tf.textColor = [UIColor colorWithRed:112.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0];
    tf.textAlignment = UITextAlignmentCenter;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [initialBg addSubview:tf];
    [tf becomeFirstResponder];
    
}

-(IBAction)doneAction:(id)sender
{
    
    UITextField *tempTf = (UITextField *)[scoreBoard viewWithTag:103];
    
    [self enterNameInDb : tempTf.text];
    
    [buttonClickMusic play];
    
    [scoreBoard removeFromSuperview];
    scoreBoard = nil;
    
    HighScorePage *highScorePage = [[HighScorePage alloc] initWithNibName:@"HighScorePage" bundle:nil];
    [self.navigationController pushViewController:highScorePage animated:YES];
}

-(void) enterNameInDb : (NSString *)name
{
    
    int res = SQLITE_ERROR;
    
	[self initDatabase];
    
    res = sqlite3_open(dbpath, &memoryappDB);
	
    //int res = SQLITE_ERROR;
    sqlite3_stmt *insertStmt =nil; 
    
    const char *sql = "insert into UserTable(Name, Score, Level) values(?, ?, ?)";
    
    NSString *tempScore = [NSString stringWithFormat:@"%d", score];
    NSString *level = @"";
    
    if(selectedLevel == 100)
    {
        level = @"Easy";
    }
    else if(selectedLevel == 101)
    {
        level = @"Hard";
    }
	
	res = sqlite3_prepare_v2(memoryappDB, sql, -1, &insertStmt, NULL);
    
    sqlite3_bind_text(insertStmt, 1, [name UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStmt, 2, [tempScore UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStmt, 3, [level UTF8String],-1, SQLITE_TRANSIENT);
	
    if(res!= SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement:%s", sqlite3_errmsg(memoryappDB));
    }
    
    if((res = sqlite3_step(insertStmt)) != SQLITE_DONE)
    {
        NSLog(@"Error - %s",sqlite3_errmsg(memoryappDB));
    }
    else
    {
        NSLog(@"No Error - %s",sqlite3_errmsg(memoryappDB));
        
    }
    
    res = sqlite3_reset(insertStmt);
    res = sqlite3_close(memoryappDB);
}

-(IBAction)cancelAction:(id)sender
{
    
    [buttonClickMusic play];
    
    [initialBg removeFromSuperview];
    initialBg = nil;

}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField 
//{
//    
//    [textField resignFirstResponder];
//    
//    return YES;
//}

-(IBAction)noThanksAction:(id)sender
{
    
    [buttonClickMusic play];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImage *) mergeTwoImages: (UIImage *)bottomImage :(UIImage *)upperImage : (CGRect)rect
{
    
    //UIImage *bottomImage1 = bottomImage;
    UIImage *image = upperImage;
    
    // CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity
    [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 230.0/255.0, 105.0/255.0, 0.0/255.0, 1.0); 
    CGContextStrokeRect(context, rect);
    //CGContextSetLineWidth(context, 10.0);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

-(UIImage *) mergePin: (UIImage *)image1
{
    
    UIImage *bottomImage = [self imageWithImage:[UIImage imageNamed:@"orangeBox.png"] scaledToSize:CGSizeMake(133, 119)];
    UIImage *image = [self imageWithImage:image1 scaledToSize:CGSizeMake(123, 109)];
    
    CGSize newSize = CGSizeMake(123, 109);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity
    [image drawInRect:CGRectMake(0,0,123,109) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void) timerAction
{
    second++;
    if(second == 60)
    {
        minute++;
        second = 0;
    }
    if(second % 15 == 0)
    {
        score -= 4;
    }
    
    timeLabel.text = [NSString stringWithFormat:@"%02d : %02d", minute, second];
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];

}

-(void) generateTheGameLogic
{
    usedIdArray = [[NSMutableArray alloc] init];
    usedImagesArray = [[NSMutableArray alloc] init];
    
//    if(selectedLevel == 5)
//    {
//        usedImagesArray = [self generateRandomNumber:6];
//    
//    }
//    else if(selectedLevel == 6)
//    {
//        usedImagesArray = [self generateRandomNumber:9];
//    }
//    else
//    {
//        usedImagesArray = [self generateRandomNumber:selectedLevel];
//    }
    
    switch (selectedLevel) {
        case 100:
            usedImagesArray = [self generateRandomNumber:6];
            break;

        case 101:
            usedImagesArray = [self generateRandomNumber:10];
            break;

        default:
            break;
    }
    
    [self addImages];
    
}

-(void) addImages
{
    
    int btnTag = 1;
    
    switch (selectedLevel) {
        case 1:
        {
            
//            totalNumberOfImages = 2;
//            
//            UIButton *btn1 = [[UIButton alloc] init];
//            btn1.tag = btnTag;
//            btn1.frame = CGRectMake(25, 46, 260, 169);
//            btn1.backgroundColor = [UIColor clearColor];
//            [btn1 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn1 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn1 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn1.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn1];
//            btnTag++;
//            
//            UIButton *btn2 = [[UIButton alloc] init];
//            btn2.tag = btnTag;
//            btn2.frame = CGRectMake(25, 248, 260, 169);
//            btn2.backgroundColor = [UIColor clearColor];
//            [btn2 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn2 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn2 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn2.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn2];
//
//            break;
            
            totalNumberOfImages = 6;
            totalImages = 6;
            
            NSMutableArray *randomIdArray = [self generateRandomId:6];
            
            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
            
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 60, 133, 119)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(165, 60, 133, 119)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 188, 133, 119)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(165, 188, 133, 119)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 313, 133, 119)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(165, 313, 133, 119)]];
            
            NSLog(@"%d", [usedImagesArray count]);
            
            UIButton *btn1 = [[UIButton alloc] init];
            btn1.tag = btnTag;
            btn1.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:0] intValue]] CGRectValue];
            btn1.backgroundColor = [UIColor clearColor];
            [btn1 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn1 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
            [btn1 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.adjustsImageWhenHighlighted = NO;
            btn1.contentMode = UIViewContentModeScaleAspectFit;
            //btn1.layer.borderColor = [[UIColor orangeColor] CGColor];
            //btn1.layer.borderWidth = 10.0;
            [self.view addSubview:btn1];
            btnTag++;
            
            UIButton *btn2 = [[UIButton alloc] init];
            btn2.tag = btnTag;
            btn2.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:1] intValue]] CGRectValue];
            btn2.backgroundColor = [UIColor clearColor];
            [btn2 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn2 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
            [btn2 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn2.adjustsImageWhenHighlighted = NO;
            btn2.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:btn2];
            btnTag++;
            
            UIButton *btn3 = [[UIButton alloc] init];
            btn3.tag = btnTag;
            btn3.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:2] intValue]] CGRectValue];
            btn3.backgroundColor = [UIColor clearColor];
            [btn3 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn3 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
            [btn3 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn3.adjustsImageWhenHighlighted = NO;
            btn3.contentMode = UIViewContentModeScaleAspectFit; 
            [self.view addSubview:btn3];
            btnTag++;
            
            UIButton *btn4 = [[UIButton alloc] init];
            btn4.tag = btnTag;
            btn4.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:3] intValue]] CGRectValue];
            btn4.backgroundColor = [UIColor clearColor];
            [btn4 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn4 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
            [btn4 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn4.adjustsImageWhenHighlighted = NO;
            btn4.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:btn4];
            btnTag++;
            
            UIButton *btn5 = [[UIButton alloc] init];
            btn5.tag = btnTag;
            btn5.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:4] intValue]] CGRectValue];
            btn5.backgroundColor = [UIColor clearColor];
            [btn5 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn5 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
            [btn5 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn5.adjustsImageWhenHighlighted = NO;
            btn5.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:btn5];
            btnTag++;
            
            UIButton *btn6 = [[UIButton alloc] init];
            btn6.tag = btnTag;
            btn6.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:5] intValue]] CGRectValue];
            btn6.backgroundColor = [UIColor clearColor];
            [btn6 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn6 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
            [btn6 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn6.adjustsImageWhenHighlighted = NO;
            btn6.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:btn6];
            
            break;
            
        }
        case 2:
        {
            
//            totalNumberOfImages = 4;
//            
//            NSMutableArray *randomIdArray = [self generateRandomId:4];
//            
//            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(15, 76, 135, 140)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(170, 76, 135, 140)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(15, 278, 135, 140)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(170, 278, 135, 140)]];
//            
//            UIButton *btn1 = [[UIButton alloc] init];
//            btn1.tag = btnTag;
//            btn1.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:0] intValue]] CGRectValue];
//            btn1.backgroundColor = [UIColor clearColor];
//            [btn1 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn1 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn1 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn1.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn1];
//            btnTag++;
//            
//            UIButton *btn2 = [[UIButton alloc] init];
//            btn2.tag = btnTag;
//            btn2.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:1] intValue]] CGRectValue];
//            btn2.backgroundColor = [UIColor clearColor];
//            [btn2 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn2 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn2 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn2.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn2];
//            btnTag++;
//            
//            UIButton *btn3 = [[UIButton alloc] init];
//            btn3.tag = btnTag;
//            btn3.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:2] intValue]] CGRectValue];
//            btn3.backgroundColor = [UIColor clearColor];
//            [btn3 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn3 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
//            [btn3 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn3.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn3];
//            btnTag++;
//            
//            UIButton *btn4 = [[UIButton alloc] init];
//            btn4.tag = btnTag;
//            btn4.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:3] intValue]] CGRectValue];
//            btn4.backgroundColor = [UIColor clearColor];
//            [btn4 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn4 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
//            [btn4 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn4.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn4];
//            
//            break;
            
            
            totalNumberOfImages = 8;
            totalImages = 8;
            NSMutableArray *randomIdArray = [self generateRandomId:8];
            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
            
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(45, 58, 100, 90)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(177, 58, 100, 90)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(45, 152, 100, 90)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(177, 152, 100, 90)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(45, 248, 100, 90)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(177, 248, 100, 90)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(45, 344, 100, 90)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(177, 344, 100, 90)]];
            
            UIButton *btn1 = [[UIButton alloc] init];
            btn1.tag = btnTag;
            btn1.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:0] intValue]] CGRectValue];
            btn1.backgroundColor = [UIColor clearColor];
            [btn1 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn1 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
            [btn1 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn1];
            btnTag++;
            
            UIButton *btn2 = [[UIButton alloc] init];
            btn2.tag = btnTag;
            btn2.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:1] intValue]] CGRectValue];
            btn2.backgroundColor = [UIColor clearColor];
            [btn2 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn2 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
            [btn2 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn2.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn2];
            btnTag++;
            
            UIButton *btn3 = [[UIButton alloc] init];
            btn3.tag = btnTag;
            btn3.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:2] intValue]] CGRectValue];
            btn3.backgroundColor = [UIColor clearColor];
            [btn3 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn3 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
            [btn3 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn3.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn3];
            btnTag++;
            
            UIButton *btn4 = [[UIButton alloc] init];
            btn4.tag = btnTag;
            btn4.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:3] intValue]] CGRectValue];
            btn4.backgroundColor = [UIColor clearColor];
            [btn4 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn4 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
            [btn4 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn4.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn4];
            btnTag++;
            
            UIButton *btn5 = [[UIButton alloc] init];
            btn5.tag = btnTag;
            btn5.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:4] intValue]] CGRectValue];
            btn5.backgroundColor = [UIColor clearColor];
            [btn5 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn5 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
            [btn5 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn5.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn5];
            btnTag++;
            
            UIButton *btn6 = [[UIButton alloc] init];
            btn6.tag = btnTag;
            btn6.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:5] intValue]] CGRectValue];
            btn6.backgroundColor = [UIColor clearColor];
            [btn6 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn6 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
            [btn6 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn6.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn6];
            btnTag++;
            
            UIButton *btn7 = [[UIButton alloc] init];
            btn7.tag = btnTag;
            btn7.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:6] intValue]] CGRectValue];
            btn7.backgroundColor = [UIColor clearColor];
            [btn7 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn7 setImage:[usedImagesArray objectAtIndex:3] forState:UIControlStateSelected];
            [btn7 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn7.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn7];
            btnTag++;
            
            UIButton *btn8 = [[UIButton alloc] init];
            btn8.tag = btnTag;
            btn8.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:7] intValue]] CGRectValue];
            btn8.backgroundColor = [UIColor clearColor];
            [btn8 setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
            [btn8 setImage:[usedImagesArray objectAtIndex:3] forState:UIControlStateSelected];
            [btn8 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn8.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:btn8];
            
            break;

                        
        }
        case 100:
        {
            
//            totalNumberOfImages = 6;
//            
//            NSMutableArray *randomIdArray = [self generateRandomId:6];
//            
//            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(17, 46, 135, 125)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(163, 46, 135, 125)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(17, 178, 135, 125)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(163, 178, 135, 125)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(17, 313, 135, 125)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(163, 313, 135, 125)]];
//
//            UIButton *btn1 = [[UIButton alloc] init];
//            btn1.tag = btnTag;
//            btn1.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:0] intValue]] CGRectValue];
//            btn1.backgroundColor = [UIColor clearColor];
//            [btn1 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn1 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn1 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn1.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn1];
//            btnTag++;
//            
//            UIButton *btn2 = [[UIButton alloc] init];
//            btn2.tag = btnTag;
//            btn2.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:1] intValue]] CGRectValue];
//            btn2.backgroundColor = [UIColor clearColor];
//            [btn2 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn2 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn2 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn2.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn2];
//            btnTag++;
//            
//            UIButton *btn3 = [[UIButton alloc] init];
//            btn3.tag = btnTag;
//            btn3.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:2] intValue]] CGRectValue];
//            btn3.backgroundColor = [UIColor clearColor];
//            [btn3 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn3 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
//            [btn3 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn3.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn3];
//            btnTag++;
//            
//            UIButton *btn4 = [[UIButton alloc] init];
//            btn4.tag = btnTag;
//            btn4.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:3] intValue]] CGRectValue];
//            btn4.backgroundColor = [UIColor clearColor];
//            [btn4 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn4 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
//            [btn4 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn4.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn4];
//            btnTag++;
//            
//            UIButton *btn5 = [[UIButton alloc] init];
//            btn5.tag = btnTag;
//            btn5.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:4] intValue]] CGRectValue];
//            btn5.backgroundColor = [UIColor clearColor];
//            [btn5 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn5 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
//            [btn5 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn5.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn5];
//            btnTag++;
//            
//            UIButton *btn6 = [[UIButton alloc] init];
//            btn6.tag = btnTag;
//            btn6.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:5] intValue]] CGRectValue];
//            btn6.backgroundColor = [UIColor clearColor];
//            [btn6 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn6 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
//            [btn6 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn6.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn6];
//
//            break;
            
            totalNumberOfImages = 12;
            totalImages = 12;
            NSMutableArray *randomIdArray = [self generateRandomId:12];
            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
            
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20*width/320, 65*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(113*width/320, 65*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(208*width/320, 65*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20*width/320, 155*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(113*width/320, 155*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(208*width/320, 155*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20*width/320, 245*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(113*width/320, 245*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(208*width/320, 245*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20*width/320, 335*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(113*width/320, 335*height/480, 94*width/320, 89*height/480)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(208*width/320, 335*height/480, 94*width/320, 89*height/480)]];
            
            int randomCnt = 0;
            for(int i = 0; i < 12; i++)
            {
                UIButton *btn = [[UIButton alloc] init];
                btn.tag = btnTag;
                btn.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:i] intValue]] CGRectValue];
                btn.backgroundColor = [UIColor clearColor];
                [btn setImage:[UIImage imageNamed:@"Tile.png"] forState:UIControlStateNormal];
                [btn setImage:[usedImagesArray objectAtIndex:randomCnt] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.adjustsImageWhenHighlighted = NO;
                [self.view addSubview:btn];
                btnTag++;
                
                if(i %2  == 1)
                {
                    randomCnt++;
                    
                    NSLog(@"%d", randomCnt);
                    
                }
            }
            
            break;
            
        }
            
        case 4:
        {
//            totalNumberOfImages = 8;
//            NSMutableArray *randomIdArray = [self generateRandomId:8];
//            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(30, 50, 110, 90)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(180, 50, 110, 90)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(30, 148, 110, 90)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(180, 148, 110, 90)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(30, 248, 110, 90)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(180, 248, 110, 90)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(30, 344, 110, 90)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(180, 344, 110, 90)]];
//            
//            UIButton *btn1 = [[UIButton alloc] init];
//            btn1.tag = btnTag;
//            btn1.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:0] intValue]] CGRectValue];
//            btn1.backgroundColor = [UIColor clearColor];
//            [btn1 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn1 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn1 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn1.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn1];
//            btnTag++;
//            
//            UIButton *btn2 = [[UIButton alloc] init];
//            btn2.tag = btnTag;
//            btn2.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:1] intValue]] CGRectValue];
//            btn2.backgroundColor = [UIColor clearColor];
//            [btn2 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn2 setImage:[usedImagesArray objectAtIndex:0] forState:UIControlStateSelected];
//            [btn2 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn2.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn2];
//            btnTag++;
//            
//            UIButton *btn3 = [[UIButton alloc] init];
//            btn3.tag = btnTag;
//            btn3.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:2] intValue]] CGRectValue];
//            btn3.backgroundColor = [UIColor clearColor];
//            [btn3 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn3 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
//            [btn3 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn3.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn3];
//            btnTag++;
//            
//            UIButton *btn4 = [[UIButton alloc] init];
//            btn4.tag = btnTag;
//            btn4.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:3] intValue]] CGRectValue];
//            btn4.backgroundColor = [UIColor clearColor];
//            [btn4 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn4 setImage:[usedImagesArray objectAtIndex:1] forState:UIControlStateSelected];
//            [btn4 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn4.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn4];
//            btnTag++;
//            
//            UIButton *btn5 = [[UIButton alloc] init];
//            btn5.tag = btnTag;
//            btn5.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:4] intValue]] CGRectValue];
//            btn5.backgroundColor = [UIColor clearColor];
//            [btn5 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn5 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
//            [btn5 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn5.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn5];
//            btnTag++;
//            
//            UIButton *btn6 = [[UIButton alloc] init];
//            btn6.tag = btnTag;
//            btn6.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:5] intValue]] CGRectValue];
//            btn6.backgroundColor = [UIColor clearColor];
//            [btn6 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn6 setImage:[usedImagesArray objectAtIndex:2] forState:UIControlStateSelected];
//            [btn6 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn6.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn6];
//            btnTag++;
//            
//            UIButton *btn7 = [[UIButton alloc] init];
//            btn7.tag = btnTag;
//            btn7.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:6] intValue]] CGRectValue];
//            btn7.backgroundColor = [UIColor clearColor];
//            [btn7 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn7 setImage:[usedImagesArray objectAtIndex:3] forState:UIControlStateSelected];
//            [btn7 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn7.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn7];
//            btnTag++;
//            
//            UIButton *btn8 = [[UIButton alloc] init];
//            btn8.tag = btnTag;
//            btn8.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:7] intValue]] CGRectValue];
//            btn8.backgroundColor = [UIColor clearColor];
//            [btn8 setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//            [btn8 setImage:[usedImagesArray objectAtIndex:3] forState:UIControlStateSelected];
//            [btn8 addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn8.adjustsImageWhenHighlighted = NO;
//            [self.view addSubview:btn8];
//
//            break;
            
            totalNumberOfImages = 16;
            totalImages = 16;
            NSMutableArray *randomIdArray = [self generateRandomId:16];
            
            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
            
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(10, 100, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(86, 100, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(165, 100, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(240, 100, 71, 64)]];
            
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(10, 175, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(86, 175, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(165, 175, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(240, 175, 71, 64)]];
            
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(10, 245, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(86, 245, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(165, 245, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(240, 245, 71, 64)]];
            
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(10, 320, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(86, 320, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(165, 320, 71, 64)]];
            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(240, 320, 71, 64)]];
            
            int randomCnt = 0;
            for(int i = 0; i < 16; i++)
            {
                
                UIButton *btn = [[UIButton alloc] init];
                btn.tag = btnTag;
                btn.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:i] intValue]] CGRectValue];
                btn.backgroundColor = [UIColor clearColor];
                [btn setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
                [btn setImage:[usedImagesArray objectAtIndex:randomCnt] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.adjustsImageWhenHighlighted = NO;
                [self.view addSubview:btn];
                btnTag++;
                
                if(i %2  == 1)
                {
                    randomCnt++;
                    NSLog(@"%d", randomCnt);
                    
                }
                
            }
            break;
            
        }
            
        case 101:
        {
            
//            totalNumberOfImages = 12;
//            
//            NSMutableArray *randomIdArray = [self generateRandomId:12];
//            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 50, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(120, 50, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(220, 50, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 150, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(120, 150, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(220, 150, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 250, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(120, 250, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(220, 250, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 350, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(120, 350, 80, 80)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(220, 350, 80, 80)]];
//
//            int randomCnt = 0;
//            for(int i = 0; i < 12; i++)
//            {
//            
//                UIButton *btn = [[UIButton alloc] init];
//                btn.tag = btnTag;
//                btn.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:i] intValue]] CGRectValue];
//                btn.backgroundColor = [UIColor clearColor];
//                [btn setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//                [btn setImage:[usedImagesArray objectAtIndex:randomCnt] forState:UIControlStateSelected];
//                [btn addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//                btn.adjustsImageWhenHighlighted = NO;
//                [self.view addSubview:btn];
//                btnTag++;
//                
//                if(i %2  == 1)
//                {
//                    randomCnt++;
//                    
//                    NSLog(@"%d", randomCnt);
//                
//                }
//            
//            }
//
//            break;
            
            totalNumberOfImages = 20;
            totalImages = 20;
            NSMutableArray *randomIdArray = [self generateRandomId:20];
            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
            
            int imgX = 20*width/320;
            int imgY = 65*height/480;
            for(int  j = 1; j < 21; j++)
            {
                [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(imgX, imgY, 70*width/320, 72*height/480)]];
                
                if(j % 4 == 0)
                {
                    imgX = 20*width/320;
                    imgY = imgY + 69*height/480 +2;
                }
                else
                {
                    imgX = imgX + 69*width/320 + 2;
                }
                    
            }
            
            int randomCnt = 0;
            for(int i = 0; i < 20; i++)
            {
                
                UIButton *btn = [[UIButton alloc] init];
                btn.tag = btnTag;
                btn.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:i] intValue]] CGRectValue];
                btn.backgroundColor = [UIColor clearColor];
                [btn setImage:[UIImage imageNamed:@"Tile.png"] forState:UIControlStateNormal];
                [btn setImage:[usedImagesArray objectAtIndex:randomCnt] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.adjustsImageWhenHighlighted = NO;
                [self.view addSubview:btn];
                btnTag++;
                
                if(i %2  == 1)
                {
                    randomCnt++;
                    
                    NSLog(@"%d", randomCnt);
                    
                }
                
            }
            
            break;

        
        }
            
        case 6:
        {
            
//            totalNumberOfImages = 16;
//            
//            NSMutableArray *randomIdArray = [self generateRandomId:16];
//            
//            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 70, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(95, 70, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(170, 70, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(245, 70, 60, 75)]];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 160, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(95, 160, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(170, 160, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(245, 160, 60, 75)]];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 250, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(95, 250, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(170, 250, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(245, 250, 60, 75)]];
//            
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(20, 340, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(95, 340, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(170, 340, 60, 75)]];
//            [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(245, 340, 60, 75)]];
//            
//            int randomCnt = 0;
//            for(int i = 0; i < 16; i++)
//            {
//                
//                UIButton *btn = [[UIButton alloc] init];
//                btn.tag = btnTag;
//                btn.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:i] intValue]] CGRectValue];
//                btn.backgroundColor = [UIColor clearColor];
//                [btn setImage:[UIImage imageNamed:@"level3Rect.png"] forState:UIControlStateNormal];
//                [btn setImage:[usedImagesArray objectAtIndex:randomCnt] forState:UIControlStateSelected];
//                [btn addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
//                btn.adjustsImageWhenHighlighted = NO;
//                [self.view addSubview:btn];
//                btnTag++;
//                
//                if(i %2  == 1)
//                {
//                    randomCnt++;
//                    
//                    NSLog(@"%d", randomCnt);
//                    
//                }
//                
//            }
//            break;
            
            
            totalNumberOfImages = 30;
            totalImages = 30;
            NSMutableArray *randomIdArray = [self generateRandomId:30];
            NSMutableArray *rectArray = [[NSMutableArray alloc] init];
            
            int imgX = 3;
            int imgY = 73;
            for(int  j = 1; j < 31; j++)
            {
                [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(imgX, imgY, 62, 55)]];
                
                if(j % 5 == 0)
                {
                    imgX = 5;
                    imgY = imgY + 55 + 2;
                }
                else
                {
                    imgX = imgX + 62 + 1;
                }
                
            }
            
            int randomCnt = 0;
            for(int i = 0; i < 30; i++)
            {
                
                UIButton *btn = [[UIButton alloc] init];
                btn.tag = btnTag;
                btn.frame = [[rectArray objectAtIndex:[[randomIdArray objectAtIndex:i] intValue]] CGRectValue];
                btn.backgroundColor = [UIColor clearColor];
                [btn setImage:[UIImage imageNamed:@"questionMark.png"] forState:UIControlStateNormal];
                [btn setImage:[usedImagesArray objectAtIndex:randomCnt] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(changeImageAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.adjustsImageWhenHighlighted = NO;
                [self.view addSubview:btn];
                btnTag++;
                
                if(i % 2  == 1)
                {
                    randomCnt++;
                    
                    NSLog(@"%d", randomCnt);
                    
                }
                
            }
            
            break;
            
        }
        default:
            break;
    }

}

-(IBAction)changeImageAction:(id)sender
{
    
    NSLog(@"The value of the btnFlag is %@\n", (btnFlag ? @"YES" : @"NO"));
    
    if(!btnFlag)
    {

    
    UIButton *tappedBtn = (UIButton *)sender;
    
    NSLog(@"%d", tappedBtn.tag);
    
    if(!tappedBtn.selected)
    {
        
        UIImage *tempImage =  [tappedBtn imageForState:UIControlStateSelected];
        [tappedBtn setImage:tempImage forState:UIControlStateNormal];
        
        if(firstImage == nil)
        {
            firstBtn = tappedBtn;
            firstImage = tempImage;
            
            tappedBtn.selected = YES;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                   forView:tappedBtn 
                                     cache:YES];
            [UIView commitAnimations];

        }
        else if(secondImage == nil)
        {
            secondBtn = tappedBtn;
            secondImage = tempImage; 
            
            tappedBtn.selected = YES;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                   forView:tappedBtn 
                                     cache:YES];
            [UIView commitAnimations];

            btnFlag = TRUE;
            
            [self performSelector:@selector(checkForSimirality) withObject:nil afterDelay:0.6];
        
        }
        
//        if(firstImage != nil && secondImage != nil)
//            [self performSelector:@selector(checkForSimirality) withObject:nil afterDelay:0.2];
//        else
//            [self checkForSimirality];

    }
    }

}

-(void) checkForSimirality
{
    
    NSLog(@"The value of the bool is %@\n", (checkFlag ? @"YES" : @"NO"));
    
    if(!checkFlag)
    {
    
    if(firstImage != nil && secondImage != nil)
    {
        NSLog(@"Checking");
        checkFlag = TRUE;
        
         NSLog(@"The value of the bool is %@\n", (checkFlag ? @"YES" : @"NO"));
        
        if([firstImage isEqual:secondImage])
        {
            
//            UIImageView *tenImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ten.png"]];
//            [tenImage setCenter:self.view.center];
//            
//            [UIView beginAnimations:nil context:NULL];
//            [UIView setAnimationDuration:1.0];
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
//                                   forView:tenImage 
//                                     cache:YES];
//            [UIView commitAnimations];
//            [self.view addSubview:tenImage];
            
            
            [usedIdArray addObject:[NSString stringWithFormat:@"%d", firstBtn.tag]];
            [usedIdArray addObject:[NSString stringWithFormat:@"%d", secondBtn.tag]];
            
            if(mainDelegate.soundFlag)
            {
                [correctMusic play];
            }
            
            [firstBtn removeFromSuperview];
            [secondBtn removeFromSuperview];
            
            totalNumberOfImages = totalNumberOfImages - 2;
            
            score += 30;
            pairCounter++;
            scoreLabel.text = [NSString stringWithFormat:@"%d", score];
            
//            firstImage = nil;
//            secondImage = nil;
//            firstBtn = nil;
//            secondBtn = nil;
            
            
            [self checkAchievements];
            
            [self performSelector:@selector(changeTheFlag) withObject:nil afterDelay:0.5];


//            UIAlertView *equalAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Level cleared...!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
//            [equalAlert show];

        
        }//End of inner if loop
        else
        {
            
            
            BOOL image1Flag = FALSE;
            BOOL image2Flag = FALSE;
            if ([usedIdArray indexOfObject:[NSString stringWithFormat:@"%d", firstBtn.tag]] != NSNotFound) {
                // object found
                
                image1Flag = TRUE;
            }
            else {
                // object not found
                [usedIdArray addObject:[NSString stringWithFormat:@"%d", firstBtn.tag]];

            }
            
            if ([usedIdArray indexOfObject:[NSString stringWithFormat:@"%d", secondBtn.tag]] != NSNotFound) {
                // object found
                
                image2Flag = TRUE;
                
            }
            else {
                // object not found
                [usedIdArray addObject:[NSString stringWithFormat:@"%d", secondBtn.tag]];
                
            }

            if(image1Flag && image2Flag)
            {
            
                score -= 1;
            
            }
            else if(image1Flag || image2Flag)
            {
                score -= 1;
            
            }
            
            //score -= 1;
            
            pairCounter = 0;
            
            scoreLabel.text = [NSString stringWithFormat:@"%d", score];

            [firstBtn setImage:[UIImage imageNamed:@"Tile.png"] forState:UIControlStateNormal];
            [secondBtn setImage:[UIImage imageNamed:@"Tile.png"] forState:UIControlStateNormal];
            
            if(mainDelegate.soundFlag)
            {
                [wrongMusic play];
            }
            
            firstBtn.selected = NO;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                                   forView:firstBtn 
                                     cache:YES];
            [UIView commitAnimations];
            
            secondBtn.selected = NO;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                                   forView:secondBtn 
                                     cache:YES];
            [UIView commitAnimations];

//            firstImage = nil;
//            secondImage = nil;
            //checkFlag = FALSE;
//            firstBtn = nil;
//            secondBtn = nil;
            
            //checkflag
            //checkFlag = FALSE;
            [self performSelector:@selector(changeTheFlag) withObject:nil afterDelay:0.5];
        
        }
        
        if(totalNumberOfImages == 0)
        {            
            
            [self getScoreFromTable];
//            NSString *msg;
//            
//            if(score > [levelScore intValue])
//            {
//                
//                msg = [NSString stringWithFormat:@"Score : %@ New High Score", scoreLabel.text];
//                [self writeNewScoreToDb:[NSString stringWithFormat:@"%d", score]];
//                
//            }
//            else
//            {
//                
//                msg = [NSString stringWithFormat:@"Score : %@", scoreLabel.text];
//            }
//
//            NSString *title = [NSString stringWithFormat:@"Level %d completed", selectedLevel];
            
//            UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Menu", @"Retry", @"Next", nil, nil];
//            [winAlert show];
//            winAlert.tag = 100;
            
            [gameTimer invalidate];
            gameTimer = nil;
            
            
            switch (selectedLevel) {
                case 1:
                {
                    mainDelegate.level1Flag = TRUE;
                    break;
                }
                    
                case 2:
                {
                    mainDelegate.level2Flag = TRUE;
                    break;
                }

                case 3:
                {
                    mainDelegate.level3Flag = TRUE;
                    break;
                }
                    
                case 4:
                {
                    mainDelegate.level4Flag = TRUE;
                    break;
                }
                    
                case 5:
                {
                    mainDelegate.level5Flag = TRUE;
                    break;
                }

                default:
                    break;
            }
            
            
            scoreBoard = [[UIView alloc] init];
            scoreBoard.frame = CGRectMake(0, 0, 320*width/320, 480*height/480);
            scoreBoard.backgroundColor = [UIColor clearColor];
            [self.view addSubview:scoreBoard];
            
            UIImageView *scoreBg = [[UIImageView alloc] init];
            scoreBg.frame = CGRectMake(0, 0, 320*width/320, 480*height/480);
            scoreBg.image = [UIImage imageNamed:@"scoreBg_iPad.png"];
            [scoreBoard addSubview:scoreBg];
            
            UIButton *enterInitialBtn = [[UIButton alloc] init];
            enterInitialBtn.tag = 101;
            enterInitialBtn.frame = CGRectMake(30*width/320, 30*height/480, 121*width/320, 79*height/480);
            [enterInitialBtn setImage:[UIImage imageNamed:@"enterInitialBtn.png"] forState:UIControlStateNormal];
            [enterInitialBtn setImage:[UIImage imageNamed:@"enterInitialPressed.png"] forState:UIControlStateSelected];
            [enterInitialBtn addTarget:self action:@selector(enterInitialAction:) forControlEvents:UIControlEventTouchUpInside];
            enterInitialBtn.adjustsImageWhenHighlighted = NO;
            [scoreBoard addSubview:enterInitialBtn];
            
            UIButton *noThanksBtn = [[UIButton alloc] init];
            noThanksBtn.tag = 102;
            noThanksBtn.frame = CGRectMake(172*width/320, 26*height/480, 121*width/320, 79*height/480);
            [noThanksBtn setImage:[UIImage imageNamed:@"noThanksBtn_iPad.png"] forState:UIControlStateNormal];
            [noThanksBtn setImage:[UIImage imageNamed:@"noThanksBtnPressed.png"] forState:UIControlStateSelected];
            [noThanksBtn addTarget:self action:@selector(noThanksAction:) forControlEvents:UIControlEventTouchUpInside];
            noThanksBtn.adjustsImageWhenHighlighted = NO;
            [scoreBoard addSubview:noThanksBtn];
            
            UILabel *simplyScoreLabel = [[UILabel alloc] init];
            simplyScoreLabel.frame = CGRectMake(182*width/320, 400*height/480, 100*width/320, 30*height/480);
            if(width>640)
            {
                simplyScoreLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:78];
            }
            else
            {
                simplyScoreLabel.font = [UIFont fontWithName:@"GoodDog Cool" size:54];
            }
            simplyScoreLabel.backgroundColor = [UIColor clearColor];
            simplyScoreLabel.textColor = [UIColor whiteColor];
            simplyScoreLabel.textAlignment = UITextAlignmentCenter;
            simplyScoreLabel.text = [NSString stringWithFormat:@"%d", score];;
            [scoreBg addSubview:simplyScoreLabel];
            
//            [self checkAchievements];
//            
//            
//            mainDelegate.gameCount++;
//            
//            if(mainDelegate.gameCount == 8)
//            {
//                
//                promoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"promoScreen.png"]];
//                promoView.frame = CGRectMake(0, 0, 320, 480);
//                promoView.userInteractionEnabled = YES;
//                [self.view addSubview:promoView];
//                
//                UIButton *fbPhotosBtn = [[UIButton alloc] init];
//                fbPhotosBtn.tag = 100;
//                fbPhotosBtn.frame = CGRectMake(30, 155, 260, 66);
//                fbPhotosBtn.backgroundColor = [UIColor clearColor];
//                [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtn.png"] forState:UIControlStateNormal];
//                [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtnPressed.png"] forState:UIControlStateSelected];
//                [fbPhotosBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//                [promoView addSubview:fbPhotosBtn];
//                
//                UIButton *yourPhotosBtn = [[UIButton alloc] init];
//                yourPhotosBtn.tag = 101;
//                yourPhotosBtn.frame = CGRectMake(30, 225, 260, 66);
//                yourPhotosBtn.backgroundColor = [UIColor clearColor];
//                [yourPhotosBtn setImage:[UIImage imageNamed:@"yourPhotoBtn.png"] forState:UIControlStateNormal];
//                [yourPhotosBtn setImage:[UIImage imageNamed:@"yourPhotoBtnPressed.png"] forState:UIControlStateSelected];
//                //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
//                [yourPhotosBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//                [promoView addSubview:yourPhotosBtn];
//                
//                UIButton *memoryMatchTableGame = [[UIButton alloc] init];
//                memoryMatchTableGame.tag = 102;
//                memoryMatchTableGame.frame = CGRectMake(30, 300, 260, 66);
//                memoryMatchTableGame.backgroundColor = [UIColor clearColor];
//                [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatch.png"] forState:UIControlStateNormal];
//                [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatchPressed.png"] forState:UIControlStateSelected];
//                [memoryMatchTableGame addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//                [promoView addSubview:memoryMatchTableGame];
//                
//                UIButton *cancelBtn = [[UIButton alloc] init];
//                cancelBtn.tag = 103;
//                cancelBtn.frame = CGRectMake(30, 370, 260, 66);
//                cancelBtn.backgroundColor = [UIColor clearColor];
//                [cancelBtn setImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
//                [cancelBtn setImage:[UIImage imageNamed:@"cancelBtnPressed.png"] forState:UIControlStateSelected];
//                [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//                [promoView addSubview:cancelBtn];
//                
//            }
//            else
//            {
//                
//                
//                scoreBoard = [[UIView alloc] init];
//                scoreBoard.frame = CGRectMake(0, 50, 320, 380);
//                scoreBoard.backgroundColor = [UIColor clearColor];
//                [self.view addSubview:scoreBoard];
//                
//                UIImageView *scoreBg = [[UIImageView alloc] init];
//                scoreBg.frame = CGRectMake(46, 50, 228, 245);
//                scoreBg.image = [UIImage imageNamed:@"alertBack.png"];
//                [scoreBoard addSubview:scoreBg];
//                
//                UIImageView *levelComplete = [[UIImageView alloc] init];
//                levelComplete.frame = CGRectMake(36, 20, 156, 15);
//                levelComplete.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%dcompleted.png",selectedLevel]];
//                [scoreBg addSubview:levelComplete];
//                
//                UILabel *simplyScoreLabel = [[UILabel alloc] init];
//                simplyScoreLabel.frame = CGRectMake(36, 55, 156, 25);
//                simplyScoreLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
//                simplyScoreLabel.backgroundColor = [UIColor clearColor];
//                simplyScoreLabel.textColor = [UIColor blackColor];
//                simplyScoreLabel.textAlignment = UITextAlignmentCenter;
//                simplyScoreLabel.text = [NSString stringWithFormat:@"Score : %d", score];;
//                [scoreBg addSubview:simplyScoreLabel];
//                
//                UILabel *simplyTimeLabel = [[UILabel alloc] init];
//                simplyTimeLabel.frame = CGRectMake(36, 95, 156, 25);
//                simplyTimeLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
//                simplyTimeLabel.backgroundColor = [UIColor clearColor];
//                simplyTimeLabel.textColor = [UIColor blackColor];
//                simplyTimeLabel.textAlignment = UITextAlignmentCenter;
//                simplyTimeLabel.text = [NSString stringWithFormat:@"Time : %02d : %02d", minute, second];;
//                [scoreBg addSubview:simplyTimeLabel];
//                
//                UIButton *menuBtn = [[UIButton alloc] init];
//                menuBtn.tag = 101;
//                menuBtn.frame = CGRectMake(15, 315, 90, 54);
//                [menuBtn setImage:[UIImage imageNamed:@"menuBtn.png"] forState:UIControlStateNormal];
//                [menuBtn setImage:[UIImage imageNamed:@"menuBtnPressed.png"] forState:UIControlStateNormal];
//                [menuBtn addTarget:self action:@selector(scoreAlertAction:) forControlEvents:UIControlEventTouchUpInside];
//                menuBtn.adjustsImageWhenHighlighted = NO;
//                [scoreBoard addSubview:menuBtn];
//                
//                UIButton *retryBtn = [[UIButton alloc] init];
//                retryBtn.tag = 102;
//                retryBtn.frame = CGRectMake(115, 315, 90, 54);
//                [retryBtn setImage:[UIImage imageNamed:@"retryBtn.png"] forState:UIControlStateNormal];
//                [retryBtn setImage:[UIImage imageNamed:@"retryBtnPressed.png"] forState:UIControlStateNormal];
//                [retryBtn addTarget:self action:@selector(scoreAlertAction:) forControlEvents:UIControlEventTouchUpInside];
//                retryBtn.adjustsImageWhenHighlighted = NO;
//                [scoreBoard addSubview:retryBtn];
//                
//                UIButton *nextBtn = [[UIButton alloc] init];
//                nextBtn.tag = 103;
//                nextBtn.frame = CGRectMake(215, 315, 90, 54);
//                [nextBtn setImage:[UIImage imageNamed:@"nextBtn.png"] forState:UIControlStateNormal];
//                [nextBtn setImage:[UIImage imageNamed:@"nextBtnPressed.png"] forState:UIControlStateNormal];
//                [nextBtn addTarget:self action:@selector(scoreAlertAction:) forControlEvents:UIControlEventTouchUpInside];
//                nextBtn.adjustsImageWhenHighlighted = NO;
//                [scoreBoard addSubview:nextBtn];
//            
//            
//            
//            
//            NSString *msg;
//            
//            if(score > [levelScore intValue])
//            {
//                
//                
//                if(mainDelegate.leaderBoardFlag)
//                {
//                    self.currentScore = score;
//                    
//                    NSLog(@"%lld", self.currentScore);
//                    
//                    self.currentScore = (int64_t)score;
//                    
//                    NSLog(@"%lld", self.currentScore);
//                    
//                    
//                    //Submit the score to game center
//                    //[self.gameCenterManager reportScore:self.currentScore forCategory:self.currentLeaderBoard];
//                    
//                    NSLog(@"%@", self.currentLeaderBoard);
//                    
//                    //Submit score to leaderboard
//                    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:self.currentLeaderBoard];
//                    scoreReporter.value = self.currentScore;
//                    scoreReporter.category = self.currentLeaderBoard;
//                    
//                    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
//                        if (error != nil)
//                        {
//                            NSLog(@"Found error while reporting score");
//                            // handle the reporting error
//                        }
//                    }];
//                }
//                
//                msg = [NSString stringWithFormat:@"New High Score"];
//                [self writeNewScoreToDb:[NSString stringWithFormat:@"%d", score]];
//                
//                UILabel *highScoreLabel = [[UILabel alloc] init];
//                highScoreLabel.frame = CGRectMake(36, 135, 156, 25);
//                highScoreLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
//                highScoreLabel.backgroundColor = [UIColor clearColor];
//                highScoreLabel.textColor = [UIColor blackColor];
//                highScoreLabel.textAlignment = UITextAlignmentCenter;
//                highScoreLabel.text = msg;
//                [scoreBg addSubview:highScoreLabel];
//                
//                
//                
//            }
//            else
//            {
//                msg = [NSString stringWithFormat:@"%@", scoreLabel.text];
//            }
//                }

        }
        else if(totalNumberOfImages == 0  && selectedLevel == 6)
        {
            
            
            mainDelegate.level6Flag = TRUE;
            
            [self checkAchievements];
            
            [self getScoreFromTable];
            
            NSString *msg;
            if(score > [levelScore intValue])
            {
                msg = [NSString stringWithFormat:@"Score : %@ New High Score", scoreLabel.text];
                [self writeNewScoreToDb:[NSString stringWithFormat:@"%d", score]];
                
                if(mainDelegate.leaderBoardFlag)
                {
                    self.currentScore = score;
                    
                    NSLog(@"%lld", self.currentScore);
                    
                    self.currentScore = (int64_t)score;
                    
                    NSLog(@"%lld", self.currentScore);
                    
                    
                    //Submit the score to game center
                    //[self.gameCenterManager reportScore:self.currentScore forCategory:self.currentLeaderBoard];
                    
                    NSLog(@"%@", self.currentLeaderBoard);
                    
                    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:self.currentLeaderBoard];
                    scoreReporter.value = self.currentScore;
                    scoreReporter.category = self.currentLeaderBoard;
                    
                    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
                        if (error != nil)
                        {
                            NSLog(@"Found error while reporting score");
                            // handle the reporting error
                        }
                    }];
                }

            }
            else
            {
                msg = [NSString stringWithFormat:@"Score : %@", scoreLabel.text];
            }
            
//            NSString *msg;
//            
//            if(score > [levelScore intValue])
//            {
//                
//                msg = [NSString stringWithFormat:@"Score : %@ New High Score", scoreLabel.text];
//                
//                [self writeNewScoreToDb:[NSString stringWithFormat:@"%d", score]];
//                //[self performSelectorInBackground:@selector(writeNewScoreToDb:) withObject:scoreLabel.text];
//                
//            }
//            else
//            {
//                
//                msg = [NSString stringWithFormat:@"Score : %@", scoreLabel.text];
//            }
//            
//            NSString *title = [NSString stringWithFormat:@"Level %d completed", selectedLevel];
//            
//            UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Menu", @"Retry", nil, nil];
//            [winAlert show];
//            winAlert.tag = 200;
            
            
            [gameTimer invalidate];
            gameTimer = nil;
            
            
            
            mainDelegate.gameCount++;
            
            if(mainDelegate.gameCount == 8)
            {
                
                promoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"promoScreen.png"]];
                promoView.frame = CGRectMake(0, 0, 320, 480);
                promoView.userInteractionEnabled = YES;
                [self.view addSubview:promoView];
                
                UIButton *fbPhotosBtn = [[UIButton alloc] init];
                fbPhotosBtn.tag = 100;
                fbPhotosBtn.frame = CGRectMake(30, 155, 260, 66);
                fbPhotosBtn.backgroundColor = [UIColor clearColor];
                [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtn.png"] forState:UIControlStateNormal];
                [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtnPressed.png"] forState:UIControlStateSelected];
                [fbPhotosBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [promoView addSubview:fbPhotosBtn];
                
                UIButton *yourPhotosBtn = [[UIButton alloc] init];
                yourPhotosBtn.tag = 101;
                yourPhotosBtn.frame = CGRectMake(30, 225, 260, 66);
                yourPhotosBtn.backgroundColor = [UIColor clearColor];
                [yourPhotosBtn setImage:[UIImage imageNamed:@"yourPhotoBtn.png"] forState:UIControlStateNormal];
                [yourPhotosBtn setImage:[UIImage imageNamed:@"yourPhotoBtnPressed.png"] forState:UIControlStateSelected];
                //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
                [yourPhotosBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [promoView addSubview:yourPhotosBtn];
                
                UIButton *memoryMatchTableGame = [[UIButton alloc] init];
                memoryMatchTableGame.tag = 102;
                memoryMatchTableGame.frame = CGRectMake(30, 300, 260, 66);
                memoryMatchTableGame.backgroundColor = [UIColor clearColor];
                [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatch.png"] forState:UIControlStateNormal];
                [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatchPressed.png"] forState:UIControlStateSelected];
                [memoryMatchTableGame addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [promoView addSubview:memoryMatchTableGame];
                
                UIButton *cancelBtn = [[UIButton alloc] init];
                cancelBtn.tag = 103;
                cancelBtn.frame = CGRectMake(30, 370, 260, 66);
                cancelBtn.backgroundColor = [UIColor clearColor];
                [cancelBtn setImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
                [cancelBtn setImage:[UIImage imageNamed:@"cancelBtnPressed.png"] forState:UIControlStateSelected];
                [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
                [promoView addSubview:cancelBtn];
                
            }

            else
            {
            
            scoreBoard = [[UIView alloc] init];
            scoreBoard.frame = CGRectMake(0, 50, 320, 380);
            scoreBoard.backgroundColor = [UIColor clearColor];
            [self.view addSubview:scoreBoard];
            
            UIImageView *scoreBg = [[UIImageView alloc] init];
            scoreBg.frame = CGRectMake(46, 50, 228, 245);
            scoreBg.image = [UIImage imageNamed:@"alertBack.png"];
            [scoreBoard addSubview:scoreBg];
            
            UIImageView *levelComplete = [[UIImageView alloc] init];
            levelComplete.frame = CGRectMake(36, 20, 156, 15);
            levelComplete.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%dcompleted.png",selectedLevel]];
            [scoreBg addSubview:levelComplete];
            
            UILabel *simplyScoreLabel = [[UILabel alloc] init];
            simplyScoreLabel.frame = CGRectMake(36, 55, 156, 25);
            simplyScoreLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
            simplyScoreLabel.backgroundColor = [UIColor clearColor];
            simplyScoreLabel.textColor = [UIColor blackColor];
            simplyScoreLabel.textAlignment = UITextAlignmentCenter;
            simplyScoreLabel.text = [NSString stringWithFormat:@"Score : %d", score];;
            [scoreBg addSubview:simplyScoreLabel];
            
            UILabel *simplyTimeLabel = [[UILabel alloc] init];
            simplyTimeLabel.frame = CGRectMake(36, 95, 156, 25);
            simplyTimeLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
            simplyTimeLabel.backgroundColor = [UIColor clearColor];
            simplyTimeLabel.textColor = [UIColor blackColor];
            simplyTimeLabel.textAlignment = UITextAlignmentCenter;
            simplyTimeLabel.text = [NSString stringWithFormat:@"Time : %02d : %02d", minute, second];;
            [scoreBg addSubview:simplyTimeLabel];
            
            UIButton *menuBtn = [[UIButton alloc] init];
            menuBtn.tag = 101;
            menuBtn.frame = CGRectMake(30, 315, 90, 54);
            [menuBtn setImage:[UIImage imageNamed:@"menuBtn.png"] forState:UIControlStateNormal];
            [menuBtn setImage:[UIImage imageNamed:@"menuBtnPressed.png"] forState:UIControlStateNormal];
            [menuBtn addTarget:self action:@selector(scoreAlertAction:) forControlEvents:UIControlEventTouchUpInside];
            menuBtn.adjustsImageWhenHighlighted = NO;
            [scoreBoard addSubview:menuBtn];
            
            UIButton *retryBtn = [[UIButton alloc] init];
            retryBtn.tag = 102;
            retryBtn.frame = CGRectMake(200, 315, 90, 54);
            [retryBtn setImage:[UIImage imageNamed:@"retryBtn.png"] forState:UIControlStateNormal];
            [retryBtn setImage:[UIImage imageNamed:@"retryBtnPressed.png"] forState:UIControlStateNormal];
            [retryBtn addTarget:self action:@selector(scoreAlertAction:) forControlEvents:UIControlEventTouchUpInside];
            retryBtn.adjustsImageWhenHighlighted = NO;
            [scoreBoard addSubview:retryBtn];
            
            if(score > [levelScore intValue])
            {
                msg = [NSString stringWithFormat:@"New High Score"];
                [self writeNewScoreToDb:[NSString stringWithFormat:@"%d", score]];
                
                UILabel *highScoreLabel = [[UILabel alloc] init];
                highScoreLabel.frame = CGRectMake(36, 135, 156, 25);
                highScoreLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
                highScoreLabel.backgroundColor = [UIColor clearColor];
                highScoreLabel.textColor = [UIColor blackColor];
                highScoreLabel.textAlignment = UITextAlignmentCenter;
                highScoreLabel.text = msg;
                [scoreBg addSubview:highScoreLabel];
                
            }
            else
            {
                msg = [NSString stringWithFormat:@"%@", scoreLabel.text];
            }
            }
            
            
//            UIButton *nextBtn = [[UIButton alloc] init];
//            nextBtn.tag = 103;
//            nextBtn.frame = CGRectMake(215, 335, 90, 54);
//            [nextBtn setImage:[UIImage imageNamed:@"nextBtn.png"] forState:UIControlStateNormal];
//            [nextBtn setImage:[UIImage imageNamed:@"nextBtnPressed.png"] forState:UIControlStateNormal];
//            [nextBtn addTarget:self action:@selector(scoreAlertAction:) forControlEvents:UIControlEventTouchUpInside];
//            nextBtn.adjustsImageWhenHighlighted = NO;
//            [scoreBoard addSubview:nextBtn];
        
        }
        
    }//End of outer if loop
    }

}

- (void) checkAchievements
{
    NSString* identifier = NULL;
    double percentComplete = 0;
    
    if(mainDelegate.level1Flag && mainDelegate.level2Flag && mainDelegate.level3Flag)
    {
        identifier= kAchievementEasyLevels;
        percentComplete= 100.0;
        
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
        }
        identifier = NULL;

    }
    
    if(mainDelegate.level5Flag)
    {
        identifier= kAchievementLevel5;
        percentComplete= 100.0;
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
        }
        identifier = NULL;
    
    }
    
    if(mainDelegate.level6Flag)
    {
        identifier= kAchievementLevel6;
        percentComplete= 100.0;
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
        }

        identifier = NULL;
        
    }
    
    if(mainDelegate.level4Flag && mainDelegate.level5Flag && mainDelegate.level6Flag)
    {
        identifier= kAchievementHardLevels;
        percentComplete= 100.0;
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
        }
        
        identifier = NULL;
        
    }
    
    
    BOOL image1Flag = FALSE;
    BOOL image2Flag = FALSE;
    if ([usedIdArray indexOfObject:[NSString stringWithFormat:@"%d", firstBtn.tag]] != NSNotFound) {
        // object found
        
        image1Flag = TRUE;
    }
        
    if ([usedIdArray indexOfObject:[NSString stringWithFormat:@"%d", secondBtn.tag]] != NSNotFound) {
        // object found
        
        image2Flag = TRUE;
        
    }
   
    
    if((selectedLevel == 5 || selectedLevel == 6) && pairCounter == 1 && !image1Flag && !image2Flag)
    {
        identifier= kAchievementLuckyMatch;
        percentComplete= 100.0;
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
        }
        
        identifier = NULL;
        
    }
    
    identifier = NULL;
    percentComplete = 0;
    switch(pairCounter)
    {
        case 2:
        {
            
            if(totalNumberOfImages == totalImages - 4)
            {
            identifier= kAchievementLuckyGuess;
            percentComplete= 100.0;
            }
            else
            {
                identifier= kAchievementRollx2;
                percentComplete= 100.0;
            }
            break;
        }
            
        case 3:
        {
            
            if(totalNumberOfImages == totalImages - 6)
            {
                identifier= kAchievementLucky6;
                percentComplete= 100.0;
            }
            else
            {
                identifier= kAchievementRollx3;
                percentComplete= 100.0;
            }
            break;
        }
            
        case 4:
        {
            identifier= kAchievementRollx4;
            percentComplete= 100.0;
        }

        case 5:
        {
            identifier= kAchievementRollx5;
            percentComplete= 100.0;
        }

        case 6:
        {
            identifier= kAchievementRollx6;
            percentComplete= 100.0;
        }

        case 7:
        {
            identifier= kAchievementRollx7;
            percentComplete= 100.0;
        }

        case 8:
        {
            identifier= kAchievementRollx8;
            percentComplete= 100.0;
        }

        case 9:
        {
            identifier= kAchievementRollx9;
            percentComplete= 100.0;
        }
            
        case 10:
        {
            identifier= kAchievementStrikex10;
            percentComplete= 100.0;
        }

             
    }
    if(identifier!= NULL)
    {
        [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
        
        identifier = NULL;
    }
    
    if(selectedLevel == 1 && score > 84)
    {
        identifier= kAchievementLevel1Master;
        percentComplete= 100.0;
        
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
            
            identifier = NULL;
        }
    
    }
    
    if(selectedLevel == 2 && score > 113)
    {
        identifier= kAchievementLevel2Master;
        percentComplete= 100.0;
        
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
            
            identifier = NULL;
        }
        
    }

    if(selectedLevel == 3 && score > 171)
    {
        identifier= kAchievementLevel3Master;
        percentComplete= 100.0;
        
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
            
            identifier = NULL;
        }
        
    }

    if(selectedLevel == 4 && score > 226)
    {
        identifier= kAchievementLevel4Master;
        percentComplete= 100.0;
        
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
            
            identifier = NULL;
        }
        
    }

    if(selectedLevel == 5 && score > 278)
    {
        identifier= kAchievementLevel5Master;
        percentComplete= 100.0;
        
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
            
            identifier = NULL;
        }
        
    }

    if(selectedLevel == 6 && score > 415)
    {
        identifier= kAchievementLevel6Master;
        percentComplete= 100.0;
        
        if(identifier!= NULL)
        {
            [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
            
            identifier = NULL;
        }
        
    }

    
}

-(void)changeTheFlag
{

     NSLog(@"changeTheFlag is %@\n", (checkFlag ? @"YES" : @"NO"));
    if(checkFlag)
    {
        checkFlag = FALSE;
        
        btnFlag = FALSE;
        
        firstImage = nil;
        secondImage = nil;
        firstBtn = nil;
        secondBtn = nil;

        
         NSLog(@"changeTheFlag is %@\n", (checkFlag ? @"YES" : @"NO"));
    }

}

-(IBAction)scoreAlertAction:(id)sender
{
    
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    UIButton *tappedBTn = (UIButton *)sender;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    tappedBTn.selected = YES;
    tappedBTn.alpha = 1;
    tappedBTn.frame = CGRectMake(tappedBTn.frame.origin.x, tappedBTn.frame.origin.y + 5, 90, 54);
    [UIView commitAnimations];
    
    [self performSelector:@selector(scoreMethod:) withObject:[NSString stringWithFormat:@"%d", tappedBTn.tag] afterDelay:0.1];

}

-(void) scoreMethod : (NSString *)btnTag
{
    int tempTag = [btnTag intValue];
    
    UIButton *tappedBTn = (UIButton *)[scoreBoard viewWithTag:tempTag];
    
    tappedBTn.frame = CGRectMake(tappedBTn.frame.origin.x, tappedBTn.frame.origin.y - 5, 90, 54);
    
    [self performSelector:@selector(scoreAlert:) withObject:[NSString stringWithFormat:@"%d", tappedBTn.tag] afterDelay:0.1];
}

-(void) scoreAlert : (NSString *)btnTag
{
    
    int tempTag = [btnTag intValue];
    
    UIButton *tappedBTn = (UIButton *)[scoreBoard viewWithTag:tempTag];

    if(tappedBTn.tag == 101)
    {
        
        //[self dismissModalViewControllerAnimated:NO];
        //tappedBTn.frame = CGRectMake(tappedBTn.frame.origin.x, tappedBTn.frame.origin.y - 5, 90, 54);
        [self.navigationController popViewControllerAnimated:YES];
        [scoreBoard removeFromSuperview];
        
    }
    else if(tappedBTn.tag == 102)
    {
        
        //tappedBTn.frame = CGRectMake(tappedBTn.frame.origin.x, tappedBTn.frame.origin.y - 5, 90, 54);
        
        prevTag = 0;
        score = 0;
        
        minute = 0;
        second = 0;
        
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        timeLabel.text = [NSString stringWithFormat:@"%02d : %02d", minute, second];
        
        //        firstImage = nil;
        //        secondImage = nil;
        //checkFlag = FALSE;
        
        [self performSelector:@selector(changeTheFlag) withObject:nil afterDelay:1.0];
        
        //        firstBtn = nil;
        //        secondBtn = nil;
        
                
        [usedIdArray release];
        [usedImagesArray release];
        
        usedIdArray = nil;
        usedImagesArray = nil;
        
        [scoreBoard removeFromSuperview];
        
        [self generateTheGameLogic];
        
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
       // [self generateTheGameLogic];
        
        
    }
    else if(tappedBTn.tag == 103)
    {
        
        //tappedBTn.frame = CGRectMake(tappedBTn.frame.origin.x, tappedBTn.frame.origin.y - 5, 90, 54);
        if(selectedLevel < 6)
        {
            
            if([gameTimer isValid])
            {
                
                [gameTimer invalidate];
                gameTimer = nil;
                
            }
            
            prevTag = 0;
            score = 0;
            minute = 0;
            second = 0;
            
            scoreLabel.text = [NSString stringWithFormat:@"Score : %d", score];
            
            //            firstImage = nil;
            //            secondImage = nil;
            //checkFlag = FALSE;
            
            [self performSelector:@selector(changeTheFlag) withObject:nil afterDelay:1.0];
            
            //            firstBtn = nil;
            //            secondBtn = nil;
            
            [usedIdArray release];
            [usedImagesArray release];
            
            usedIdArray = nil;
            usedImagesArray = nil;
            
            selectedLevel = selectedLevel + 1;
            
            [scoreBoard removeFromSuperview];
            
            [self generateTheGameLogic];
            timeLabel.text = [NSString stringWithFormat:@"%02d : %02d", minute, second];
            gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
        
    }


}

-(void) writeNewScoreToDb : (NSString *)string
{
    
	[self initDatabase];
    
    NSLog(@"%@", string);
    
    sqlite3_stmt *updateStmt =nil;
    if(sqlite3_open(dbpath, &memoryappDB) == SQLITE_OK)
    {
        NSString *updateQuery = [[NSString alloc] initWithFormat:@"update ScoreTbl set score = ? where level = 'level%d'", selectedLevel];
        
        NSLog(@"%@", updateQuery);
    
        const char *query_stmt = [updateQuery UTF8String];
        
        [updateQuery release];
        updateQuery = nil;
        
        if (sqlite3_prepare_v2(memoryappDB, query_stmt, -1, &updateStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(updateStmt, 1, [string UTF8String],-1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(updateStmt) != SQLITE_DONE ) {
                
                NSLog(@"Error - %s",sqlite3_errmsg(memoryappDB));
            }
            
            sqlite3_reset(updateStmt);
            sqlite3_finalize(updateStmt);
            
        }
        
        sqlite3_close(memoryappDB);		
    }
    else 
    {
        NSLog(@"Error : %s", sqlite3_errmsg(memoryappDB));
        sqlite3_close(memoryappDB);
    }	

}

-(void) getScoreFromTable 
{
    [self initDatabase];
    
    sqlite3_stmt *selectStmt = nil;
    
    if(sqlite3_open(dbpath, &memoryappDB) == SQLITE_OK){
        
        NSString *selectQuery = [NSString stringWithFormat:@"select score from ScoreTbl where level = 'level%d'", selectedLevel];
        
        NSLog(@"%@", selectQuery);
        
        const char *query_stmt = [selectQuery UTF8String];
        
        selectQuery = nil;
        
        if (sqlite3_prepare_v2(memoryappDB, query_stmt, -1, &selectStmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                
                levelScore = [[ NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(selectStmt,0)];
                
                NSLog(@"%@", levelScore);
                
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

-(NSMutableArray *) generateRandomId : (int) idCnt
{
    
    int numCnt = 0;
    BOOL flag = FALSE;
    NSMutableArray *tempIdArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; numCnt < idCnt; i++)
    {
        int randomNoForId = arc4random() % idCnt;
        
        for(int j = 0; j < [tempIdArray count]; j++)
        {
            if([[tempIdArray objectAtIndex:j]isEqualToString:[NSString stringWithFormat:@"%d",randomNoForId]])
            {
                
                flag = TRUE;
                
            }//End of if loop
            
        }// End of for(int j = 0
        
        if(!flag)
        {
            
            //if(randomNoForId != 0)
            {
                [tempIdArray addObject:[NSString stringWithFormat:@"%d",randomNoForId]];
                numCnt++;
                NSLog(@"%d", [tempIdArray count]);
            }
        }
        else
        {
            flag = FALSE;
        }
        
    }//End of for(int i =
    
    NSLog(@"%@", tempIdArray);
    return tempIdArray;

}

-(NSMutableArray *) generateRandomNumber : (int) levelCnt
{
    
    
    NSLog(@"%d",[imagesArray count]);
    
    
    int numCnt = 0;
    BOOL flag = FALSE;
    NSMutableArray *tempImagesArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; numCnt < levelCnt; i++)
    {
        int randomNoForImage = arc4random() % [imagesArray count];
        
        NSLog(@"%d", randomNoForImage);
        
        for(int j = 0; j < [tempImagesArray count]; j++)
        {
            
            if([[tempImagesArray objectAtIndex:j]isEqual:[imagesArray objectAtIndex:randomNoForImage]])
            {
                flag = TRUE;
            
            }//End of if loop
        
        }// End of for(int j = 0
        
        if(!flag)
        {
            [tempImagesArray addObject:[imagesArray objectAtIndex:randomNoForImage]];
            numCnt++;
            
            NSLog(@"%d", [tempImagesArray count]);
        }
        else
        {
            flag = FALSE;
        }
        
    }//End of for(int i =
    
    NSLog(@"%@", tempImagesArray);
    return tempImagesArray;
    
}

#pragma mark - UIAlertView Delegate 

-(void) alertView:(UIAlertView *)AlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(AlertView.tag == 100)
    {
        NSLog(@"%d", buttonIndex);
        if(buttonIndex == 0)
        {
            //[self dismissModalViewControllerAnimated:NO];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if(buttonIndex == 1)
        {
            prevTag = 0;
            score = 0;
            
            scoreLabel.text = [NSString stringWithFormat:@"Score : %d", score];
            
//            firstImage = nil;
//            secondImage = nil;
            //checkFlag = FALSE;
            
            [self performSelector:@selector(changeTheFlag) withObject:nil afterDelay:1.0];
            
//            firstBtn = nil;
//            secondBtn = nil;
            
            [usedIdArray release];
            [usedImagesArray release];
            
            usedIdArray = nil;
            usedImagesArray = nil;

            [self generateTheGameLogic];
            
        }
        else if(buttonIndex == 2)
        {
            if(selectedLevel < 6)
            {
                prevTag = 0;
                score = 0;
                
                scoreLabel.text = [NSString stringWithFormat:@"Score : %d", score];
                
//                firstImage = nil;
//                secondImage = nil;
                //checkFlag = FALSE;
                
                [self performSelector:@selector(changeTheFlag) withObject:nil afterDelay:1.0];
                
//                firstBtn = nil;
//                secondBtn = nil;
                
                [usedIdArray release];
                [usedImagesArray release];
                
                usedIdArray = nil;
                usedImagesArray = nil;
                
                selectedLevel = selectedLevel + 1;
                
                [self generateTheGameLogic];
            }
        }
    }
    
    if(AlertView.tag == 200)
    {
        
        NSLog(@"%d", buttonIndex);
        if(buttonIndex == 0)
        {
            //[self dismissModalViewControllerAnimated:NO];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if(buttonIndex == 1)
        {
            
            prevTag = 0;
            score = 0;
            
            scoreLabel.text = [NSString stringWithFormat:@"Score : %d", score];
            
//            firstImage = nil;
//            secondImage = nil;
            //checkFlag = FALSE;
            
            [self performSelector:@selector(changeTheFlag) withObject:nil afterDelay:1.0];
            
//            firstBtn = nil;
//            secondBtn = nil;
            
            [usedIdArray release];
            [usedImagesArray release];
            
            usedIdArray = nil;
            usedImagesArray = nil;
            
            [self generateTheGameLogic];
            
        }

    }
    
    if(AlertView.tag == 300)
    {
        
        if(buttonIndex == 1)
        {
            [gameTimer invalidate];
            //[self dismissModalViewControllerAnimated:NO];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if(buttonIndex == 0)
        {
        }
        
    }
    
    if(AlertView == photosPurchase)
    {
        if(buttonIndex == 0)
        {
            
            [self.navigationController popViewControllerAnimated:NO];
            
        }
        else if(buttonIndex == 1)
        {
            [self getPhotosFromDevice];
            
        }
        
    }
    
    if(AlertView == fbPhotosPurchased)
    {
        if(buttonIndex == 0)
        {
            
            [self.navigationController popViewControllerAnimated:NO];
            
        }
        else if(buttonIndex == 1)
        {
            [self getFriendPicsFromFB];
            
        }
        
    }


}

-(IBAction)goBack:(id)sender
{
    
    UIButton *tappedBtn = (UIButton *)sender;
    
    tappedBtn.selected = TRUE;
    
//    UIButton *tappedBtn = (UIButton *)sender;
//    
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.1];
//    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
//    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
//    tappedBtn.selected = YES;
//    tappedBtn.alpha = 1;
//    tappedBtn.frame = CGRectMake(tappedBtn.frame.origin.x, tappedBtn.frame.origin.y + 4, 72, 24);
//    [UIView commitAnimations];
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }

    [gameTimer invalidate];
    //[self dismissModalViewControllerAnimated:NO];
    [self performSelector:@selector(back) withObject:nil afterDelay:0.1];
    
}

-(void) back
{
   // backBtn.frame = CGRectMake(backBtn.frame.origin.x, backBtn.frame.origin.y - 4, 72, 24);
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)quitAction:(id)sender
{
    
    UIButton *tappedBtn = (UIButton *)sender;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:[UIApplication sharedApplication]];
    [UIView setAnimationDidStopSelector:@selector(endIgnoringInteractionEvents)];
    tappedBtn.selected = YES;
    tappedBtn.alpha = 1;
    tappedBtn.frame = CGRectMake(tappedBtn.frame.origin.x, tappedBtn.frame.origin.y + 4, 73, 24);
    [UIView commitAnimations];
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    [self performSelector:@selector(quit:) withObject:[NSString stringWithFormat:@"%d", tappedBtn.tag] afterDelay:0.1];
    
}

-(void) quit : (NSString *) btnTag
{

    UIAlertView *quitAlertView = [[UIAlertView alloc] initWithTitle:@"Quite to menu?" message:@"Are you sure you want to quit ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quit", nil];
    quitAlertView.tag = 300;
    [quitAlertView show];
    
    quitBtn.frame = CGRectMake(quitBtn.frame.origin.x, quitBtn.frame.origin.y - 4, 73, 24);

}

#pragma mark - Local database function

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

#pragma mark - GKAchievement delegate methods

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{

}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
    
    if((error == NULL) && (ach != NULL))
    {
        
        
        NSString *msg = @"";
        if([ach.identifier isEqualToString:@"M_1"])
        {
        
            msg = @"Well done. You have completed all the easy levels!";
        
        }
        else if([ach.identifier isEqualToString:@"M_2"])
        {
            
            msg = @"Memory Match Marvelous! You completed level 5";
            
        }
        else if([ach.identifier isEqualToString:@"M_3"])
        {
            
            msg = @"You are a pro and have completed level 6";
            
        }
        else if([ach.identifier isEqualToString:@"M_4"])
        {
            
            msg = @"What a memory! You have now completed all the difficult levels!";
            
        }
        else if([ach.identifier isEqualToString:@"M_4"])
        {
            
            msg = @"What a memory! You have now completed all the difficult levels!";
            
        }
        else if([ach.identifier isEqualToString:@"M_5"])
        {
            
            msg = @"Picking a pair on your first 2 cards.";
            
        }
        else if([ach.identifier isEqualToString:@"M_6"])
        {
            
            msg = @"Solving level 1 with no errors";
            
        }
        else if([ach.identifier isEqualToString:@"M_7"])
        {
            
            msg = @"Picking a pair on level 5 or 6 without having seen the cards.";
            
        }
        else if([ach.identifier isEqualToString:@"M_8"])
        {
            
            msg = @"Finding two pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_9"])
        {
            
            msg = @"Finding three pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_10"])
        {
            
            msg = @"Finding four pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_11"])
        {
            
            msg = @"Finding five pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_12"])
        {
            
            msg = @"Finding six pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_13"])
        {
            
            msg = @"Finding seven pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_14"])
        {
            
            msg = @"Finding eight pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_15"])
        {
            
            msg = @"Finding nine pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_16"])
        {
            
            msg = @"Finding ten pairs consecutively.";
            
        }
        else if([ach.identifier isEqualToString:@"M_17"])
        {
            
            msg = @"Upgrade to Memory Match Social with your iPhone Photo Albums.";
            
        }
        else if([ach.identifier isEqualToString:@"M_18"])
        {
            
            msg = @"Upgrade to Memory Match Social with Facebook Profile Pics.";
            
        }
        else if([ach.identifier isEqualToString:@"M_19"])
        {
            
            msg = @"Score of over 84";
            
        }
        else if([ach.identifier isEqualToString:@"M_20"])
        {
            
            msg = @"Score of over 113";
            
        }
        else if([ach.identifier isEqualToString:@"M_21"])
        {
            
            msg = @"Score of over 171";
            
        }
        else if([ach.identifier isEqualToString:@"M_22"])
        {
            
            msg = @"Score of over 226";
            
        }
        else if([ach.identifier isEqualToString:@"M_23"])
        {
            
            msg = @"Score of over 278";
            
        }
        else if([ach.identifier isEqualToString:@"M_24"])
        {
            
            msg = @"Score of over 415";
            
        }

        if(achievementAlert == nil)
        {
            achievementAlert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightbox.png"]];
            achievementAlert.frame = CGRectMake(0, 0, 300, 85);
            achievementAlert.center = self.view.center;
            [self.view addSubview:achievementAlert];
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(20, 10, 247, 60);
            label.textColor = [UIColor blackColor];
            label.textAlignment = UITextAlignmentCenter;
            label.text = msg;
            label.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:18];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 3;
            [achievementAlert addSubview:label];
            
            [self.view bringSubviewToFront:achievementAlert];
            
            achievementTimer = [NSTimer scheduledTimerWithTimeInterval:2.2 target:self selector:@selector(achievementTimerAction) userInfo:nil repeats:NO];
        }
        
    }
    else
    {
        // Achievement Submission Failed.
    }
    
}

-(void) achievementTimerAction
{
    
    if([achievementTimer isValid])
    {
        [achievementTimer invalidate];
        achievementTimer = nil;
        
        [achievementAlert removeFromSuperview];
        achievementAlert = nil;
    }


}

#pragma mark - In app purchase

//-(IBAction)cancelAction:(id)sender
//{
//    
//    [promoView removeFromSuperview];
//    promoView = nil;
//    
//    [self.navigationController popViewControllerAnimated:NO];
//    
//}

- (void) checkPurchasedItems
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}// Call This Function

//Then this delegate Funtion Will be fired
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    purchasedItemIDs = [[NSMutableArray alloc] init];
    
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
    }
    
}

- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    //    self.tableView.hidden = FALSE;    
    //    
    //    [self.tableView reloadData];
    
}

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}

- (void)updateInterfaceWithReachability: (Reachability*) curReach {
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //self.tableView.hidden = TRUE;
    
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBarHidden = YES;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
//    
//    Reachability *reach = [Reachability reachabilityForInternetConnection];	
//    NetworkStatus netStatus = [reach currentReachabilityStatus];    
//    if (netStatus == NotReachable) 
//    {        
//        NSLog(@"No internet connection!");        
//    } 
//    else 
//    {        
//        if ([InAppRageIAPHelper sharedHelper].products == nil)
//        {
//            
//            [[InAppRageIAPHelper sharedHelper] requestProducts];
//            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            _hud.labelText = @"Loading ...";
//            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
//            
//        }        
//    }
//    
//    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark In app purchase

- (IBAction)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;    
    
    NSLog(@"Tag : %d",buyButton.tag);
    
    NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
    
    SKProduct *product;
    switch (buyButton.tag) {
        case 100:
        {
            
            NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
            if([[InAppRageIAPHelper sharedHelper].products count] > 0)
            {
                //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
                product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:1];
                
                BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
                if(!productPurchased)
                {
                    
                    NSLog(@"Buying %@...", product.productIdentifier);
                    
                    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
                    
                    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    NSString *str = [NSString stringWithFormat:@"Loading Facebook Photos"];
                    //str = [str stringByAppendingFormat:@"%@",product.productIdentifier];
                    _hud.labelText = str;
                    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
                    
                }
                else
                {
                    fbPhotosPurchased = [[UIAlertView alloc] initWithTitle:@"" message:@"You've already purchased this.Do you want to refresh the list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                    [fbPhotosPurchased show];
                    
                }
            }
            break;
        }
        case 101:
        {
            if([[InAppRageIAPHelper sharedHelper].products count] > 0)
            {
                //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
                product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
                BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
                if(!productPurchased)
                {
                    
                    NSLog(@"Buying %@...", product.productIdentifier);
                    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
                    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    NSString *str = [NSString stringWithFormat:@"Loading Your Photos"];
                    //str = [str stringByAppendingFormat:@"%@",product.productIdentifier];
                    _hud.labelText = str;
                    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
                    
                }
                else
                {
                    photosPurchase = [[UIAlertView alloc] initWithTitle:@"" message:@"You've already purchased this.Do you want to refresh the list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                    [photosPurchase show];
                    
                }
            }
            break;
            
        }
            
        case 102:
        {
            
            ComingSoonPage *comingSoonPage = [[ComingSoonPage alloc] initWithNibName:@"ComingSoonPage" bundle:nil];
            [self.navigationController pushViewController:comingSoonPage animated:NO];
            
            break;
        }
            
        default:
            break;
    }
    
    //    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
    //    if(!productPurchased)
    //    {
    //        [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    //        
    //            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //            NSString *str = [NSString stringWithFormat:@"Buying"];
    //            str = [str stringByAppendingFormat:@"%@",product.productIdentifier];
    //            _hud.labelText = str;
    //            [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
    //        }
    //    else
    //    {
    //        
    //            AlreadyPurchased *alreadyPurchased = [[AlreadyPurchased alloc] initWithNibName:@"AlreadyPurchased" bundle:nil];
    //            alreadyPurchased.identifierStr = product.productIdentifier;
    //            [self.navigationController pushViewController:alreadyPurchased animated:NO];
    //            
    //        }
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    
//    if(alertView == photosPurchase)
//    {
//        if(buttonIndex == 0)
//        {
//            
//            [self.navigationController popViewControllerAnimated:NO];
//            
//        }
//        else if(buttonIndex == 1)
//        {
//            [self getPhotosFromDevice];
//            
//        }
//        
//    }
//    
//    if(alertView == fbPhotosPurchased)
//    {
//        if(buttonIndex == 0)
//        {
//            
//            [self.navigationController popViewControllerAnimated:NO];
//            
//        }
//        else if(buttonIndex == 1)
//        {
//            [self getFriendPicsFromFB];
//            
//        }
//        
//    }
//    
//    
//}
//
- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    if ([productIdentifier isEqualToString:@"FacebookPhotos"]) 
    {
        NSLog(@"FacebookPhotos Purchased");
        [self fbPhotosBtnAction];
        
    }
    else if([productIdentifier isEqualToString:@"DevicePhotos"]) 
    {
        [self getPhotosFromDevice];
        
    }
    
}

-(void)getPhotosFromDevice
{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *str = [NSString stringWithFormat:@"Loading...Please wait"];
    //str = [str stringByAppendingFormat:@"%@",product.productIdentifier];
    _hud.labelText = str;
    
    //[self performSelectorInBackground:@selector(loadDevicePhotos) withObject:nil];
    [self performSelectorOnMainThread:@selector(loadDevicePhotos) withObject:nil waitUntilDone:YES];
    
}

-(void) loadDevicePhotos
{
    
    self.assetGroups = [[NSMutableArray alloc] init];
    
    //    ALAssetsLibraryGroupsEnumerationResultsBlock *listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    //    {
    
    //    dispatch_async(dispatch_get_main_queue(), ^
    //                   {    
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
    {
        
        int numberOfGroups = 0;
        int numberOfAssets = 0;
        
        if(group){
            
            self.assetGroups = [[NSMutableArray alloc] init];
            numberOfGroups++;
            numberOfAssets += group.numberOfAssets;
            NSLog(@"Name of the group is : %@", [group valueForProperty:ALAssetsGroupPropertyName]);
            NSLog(@"%d", numberOfGroups);
            NSLog(@"%d", numberOfAssets);
            
            [self.assetGroups addObject:group];
            [self loadImages : group];
            
        }
        else
        {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            self.hud = nil;
            
            SKProduct *product;
            
            NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
            if([[InAppRageIAPHelper sharedHelper].products count] > 0)
            {
                //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
                product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
                
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:product.productIdentifier];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You can now play with your Photos, to play just change the mode of the game from options" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [purchasedAlert show];
            
            
            [promoView removeFromSuperview];
            promoView = nil;
            
        }
        
    };
    
    // Group Enumerator Failure Block
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"No Albums Available"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    };   
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSUInteger groupTypes = ALAssetsGroupAll;
    [library enumerateGroupsWithTypes:groupTypes usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
    
    //                  });
    
    
    
    
    
}

-(void)loadImages : (ALAssetsGroup *)assetGrp
{   
    
    //    dispatch_async(dispatch_get_main_queue(), ^
    //                   {    
    
    ALAssetsGroup *assetGroup = assetGrp;
    NSLog(@"ALBUM NAME:;%@",[assetGroup valueForProperty:ALAssetsGroupPropertyName]);
    
    
    NSLog(@"%d",assetGroup.numberOfAssets);
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != NULL) {
            NSLog(@"See Asset: %@", result);
            [mainDelegate.assets addObject:result];
            
        }
    };
    
    [assetGroup enumerateAssetsUsingBlock:assetEnumerator];
    
    //                 });
    
    
    
}


-(void)fbPhotosBtnAction
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
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) 
    {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} 
    else 
    {
		//pop a message letting them know most of the info will be dumped in the log
        
		NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
        
        mainDelegate.facebookPhotoFlag = TRUE;
        
        if([mainDelegate.facebookPhotoUrl count] <= 0)
        {
            
            activityAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Loading....Please Wait!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityView.frame = CGRectMake(110, 45, 55.0, 55.0);
            [activityView startAnimating];
            [activityAlert addSubview:activityView];    
            [self.view addSubview:activityAlert];
            
            [activityAlert show];    
            
            
            [self performSelector:@selector(getFriendPicsFromFB) withObject:nil afterDelay:0.1];
            
        }
        else
        {
            
            
            
        }
    }
    
}   
-(void)getFriendPicsFromFB
{
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", fbGraph.accessToken]];
    
    NSLog(@"%@", url);
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    NSString* newStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", newStr);
    
    NSMutableArray *tempArray = [(NSDictionary*)[newStr JSONValue] objectForKey:@"data"];	
    
    NSMutableArray *friendIdArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [tempArray count]; i++)
    {
        
        NSDictionary *dictionary = [tempArray objectAtIndex:i];
        NSLog(@"%@",[tempArray objectAtIndex:i]);
        
        NSString *friendId = [dictionary objectForKey:@"id"];
        NSLog(@"%@", friendId);
        
        [friendIdArray addObject:friendId];
        
        NSLog(@"%d", [friendIdArray count]);
        
    }
    
    NSMutableArray *usedIdArray = [[NSMutableArray alloc] init];
    int friendCount = 0;
    BOOL flag =FALSE;
    
    for(int j = 0; j < [friendIdArray count]; j++)
    {
        
        int randomNoForImage = arc4random() % [friendIdArray count];
        
        //check for used ids
        for(int k = 0; k < [usedIdArray count]; k++)
        {
            if([[usedIdArray objectAtIndex:k] isEqualToString:[friendIdArray objectAtIndex:randomNoForImage]])
            {
                flag = TRUE;
                break;
                
            }
            
        }
        
        if(!flag)
        {
            
            NSURL *url1 = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [friendIdArray objectAtIndex:randomNoForImage]]];
            
            NSLog(@"%@", url);
            
            NSURLRequest *urlRequest1 = [NSURLRequest requestWithURL:url1];
            
            NSData *urlData1;
            NSURLResponse *response1;
            
            urlData1 = [NSURLConnection sendSynchronousRequest:urlRequest1 returningResponse:&response1 error:nil];
            
            if(urlData1 !=nil)
            {
                
                UIImage *image = [UIImage imageWithData:urlData1];
                [mainDelegate.facebookPhotoUrl addObject:image];
                friendCount++;
                [usedIdArray addObject:[friendIdArray objectAtIndex:randomNoForImage]];
                
            }
            
        }
        else
        {
            
            flag = FALSE;
            
        }
        
        if(friendCount == 15)
        {
            break;
            
        }
        
    }
    
    [activityAlert dismissWithClickedButtonIndex:0 animated:NO];
    [activityView release];
    activityView = nil;
    activityAlert = nil;
    
    SKProduct *product;
    
    NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
    if([[InAppRageIAPHelper sharedHelper].products count] > 0)
    {
        product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:1];
        
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:product.productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You can now play with your Facebook Friends Photos, to play just change the mode of the game from options" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [purchasedAlert show];
    
    [promoView removeFromSuperview];
    promoView = nil;

    
    
}

-(void)getMyPhotosFromAlbum
{
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

- (void)productPurchaseFailed:(NSNotification *)notification
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
    }
    
}

#pragma mark - Memory management methods

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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else 
        return NO;
}

@end
