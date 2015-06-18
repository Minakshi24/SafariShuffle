//
//  SettingsPage.m
//  MemoryGameApp
//
//  Created by Ankita Chordia on 7/25/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "SettingsPage.h"
#import <StoreKit/StoreKit.h>
#import "FbGraph.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "InAppRageIAPHelper.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "JSON.h"

@implementation SettingsPage

@synthesize hud = _hud;
@synthesize fbGraph;
@synthesize assetGroups;

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    //self.tableView.hidden = TRUE;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
        NSLog(@"No internet connection!");        
    } else {        
        if ([InAppRageIAPHelper sharedHelper].products == nil) {
            
            [[InAppRageIAPHelper sharedHelper] requestProducts];
            //self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            //_hud.labelText = @"Loading ...";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
            
        }        
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    self.navigationController.navigationBarHidden = YES;
    
    mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"optionBg1.png"]];
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
    
    emojiBtn = [[UIButton alloc] init];
    emojiBtn.tag = 50;
    emojiBtn.frame = CGRectMake(250, 108, 27, 27);
    emojiBtn.backgroundColor = [UIColor clearColor];
    [emojiBtn setImage:[UIImage imageNamed:@"radioBtnUnselected.png"] forState:UIControlStateNormal];
    [emojiBtn setImage:[UIImage imageNamed:@"radioBtnSelected.png"] forState:UIControlStateSelected];
    [emojiBtn addTarget:self action:@selector(gamePlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emojiBtn];
    
    albumBtn = [[UIButton alloc] init];
    albumBtn.tag = 51;
    albumBtn.frame = CGRectMake(250, 138, 27, 27);
    albumBtn.backgroundColor = [UIColor clearColor];
    [albumBtn setImage:[UIImage imageNamed:@"radioBtnUnselected.png"] forState:UIControlStateNormal];
    [albumBtn setImage:[UIImage imageNamed:@"radioBtnSelected.png"] forState:UIControlStateSelected];
    [albumBtn addTarget:self action:@selector(gamePlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
    
    facebookPhotoBtn = [[UIButton alloc] init];
    facebookPhotoBtn.tag = 52;
    facebookPhotoBtn.frame = CGRectMake(250, 168, 27, 27);
    facebookPhotoBtn.backgroundColor = [UIColor clearColor];
    [facebookPhotoBtn setImage:[UIImage imageNamed:@"radioBtnUnselected.png"] forState:UIControlStateNormal];
    [facebookPhotoBtn setImage:[UIImage imageNamed:@"radioBtnSelected.png"] forState:UIControlStateSelected];
    [facebookPhotoBtn addTarget:self action:@selector(gamePlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookPhotoBtn];

    UIButton *soundOffBtn = [[UIButton alloc] init];
    soundOffBtn.tag = 53;
    soundOffBtn.frame = CGRectMake(220, 223, 37, 22);
    soundOffBtn.backgroundColor = [UIColor clearColor];
    [soundOffBtn setImage:[UIImage imageNamed:@"offOrange.png"] forState:UIControlStateNormal];
    [soundOffBtn setImage:[UIImage imageNamed:@"offBlue.png"] forState:UIControlStateSelected];
    [soundOffBtn addTarget:self action:@selector(soundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundOffBtn];
    
    
    UIButton *soundOnBtn = [[UIButton alloc] init];
    soundOnBtn.tag = 54;
    soundOnBtn.frame = CGRectMake(264, 224, 30, 20);
    soundOnBtn.backgroundColor = [UIColor clearColor];
    [soundOnBtn setImage:[UIImage imageNamed:@"onOrange.png"] forState:UIControlStateNormal];
    [soundOnBtn setImage:[UIImage imageNamed:@"onBlue.png"] forState:UIControlStateSelected];
    [soundOnBtn addTarget:self action:@selector(soundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundOnBtn];

    if(mainDelegate.soundFlag)
    {
        soundOnBtn.selected = YES;
        soundOffBtn.selected = NO;
    
    }
    else
    {
        soundOnBtn.selected = NO;
        soundOffBtn.selected = YES;
    
    }
    
    UIButton *facebookBtn = [[UIButton alloc] init];
    facebookBtn.frame = CGRectMake(250, 190, 27, 27);
    facebookBtn.backgroundColor = [UIColor clearColor];
    [facebookBtn setImage:[UIImage imageNamed:@"radioBtnUnselected.png"] forState:UIControlStateNormal];
    [facebookBtn setImage:[UIImage imageNamed:@"radioBtnSelected.png"] forState:UIControlStateSelected];
    [facebookBtn addTarget:self action:@selector(facebookBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:facebookBtn];
    
    UIButton *scoreResetBtn = [[UIButton alloc] init];
    //scoreResetBtn.frame = CGRectMake(250, 240, 27, 27);
    scoreResetBtn.frame = CGRectMake(250, 275, 27, 27);
    scoreResetBtn.backgroundColor = [UIColor clearColor];
    [scoreResetBtn setImage:[UIImage imageNamed:@"resetBtn.png"] forState:UIControlStateNormal];
    //[scoreResetBtn setImage:[UIImage imageNamed:@"radioBtnSelected.png"] forState:UIControlStateSelected];
    [scoreResetBtn addTarget:self action:@selector(scoreResetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scoreResetBtn];
    
    leaderBoardOFfBtn = [[UIButton alloc] init];
    leaderBoardOFfBtn.tag = 100;
    //leaderBoardOFfBtn.frame = CGRectMake(75, 335, 27, 27);
    leaderBoardOFfBtn.frame = CGRectMake(70, 360, 27, 27);
    leaderBoardOFfBtn.backgroundColor = [UIColor clearColor];
    [leaderBoardOFfBtn setImage:[UIImage imageNamed:@"radioBtnUnselected.png"] forState:UIControlStateNormal];
    [leaderBoardOFfBtn setImage:[UIImage imageNamed:@"radioBtnSelected.png"] forState:UIControlStateSelected];
    [leaderBoardOFfBtn addTarget:self action:@selector(leaderBoardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaderBoardOFfBtn];
    
    leaderBoardAutoBtn = [[UIButton alloc] init];
    leaderBoardAutoBtn.tag = 101;
    //leaderBoardAutoBtn.frame = CGRectMake(225, 335, 27, 27);
    leaderBoardAutoBtn.frame = CGRectMake(215, 360, 27, 27);
    leaderBoardAutoBtn.backgroundColor = [UIColor clearColor];
    [leaderBoardAutoBtn setImage:[UIImage imageNamed:@"radioBtnUnselected.png"] forState:UIControlStateNormal];
    [leaderBoardAutoBtn setImage:[UIImage imageNamed:@"radioBtnSelected.png"] forState:UIControlStateSelected];
    [leaderBoardAutoBtn addTarget:self action:@selector(leaderBoardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaderBoardAutoBtn];
    
    UIButton *rateBtn = [[UIButton alloc] init];
    rateBtn.frame = CGRectMake(253, 405, 42, 36);
    rateBtn.backgroundColor = [UIColor clearColor];
    [rateBtn setImage:[UIImage imageNamed:@"rateBtn.png"] forState:UIControlStateNormal];
    //[rateBtn setImage:[UIImage imageNamed:@"onBlue.png"] forState:UIControlStateSelected];
    [rateBtn addTarget:self action:@selector(rateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rateBtn];

    if(mainDelegate.leaderBoardFlag)
        leaderBoardAutoBtn.selected = YES;
    
    if(mainDelegate.emojiFlag)
        emojiBtn.selected = YES;
    else if(mainDelegate.yourPhotoFlag)
        albumBtn.selected = YES;
    else if(mainDelegate.facebookPhotoFlag)
        facebookPhotoBtn.selected = YES;
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buttonClick.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error1;
    buttonClickMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
    [buttonClickMusic prepareToPlay];
    
}

-(IBAction)rateBtnAction:(id)sender
{
    
    //NSString *str = @"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=546977811&type=Purple+Software";
    
    //NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=546977811";
    
    
    NSString *str = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=546977811";
    NSURL *url = [[NSURL alloc] initWithString:str];
    [[UIApplication sharedApplication] openURL:url];

}

-(IBAction)gamePlayAction:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    
    NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
    
    SKProduct *product;
    
    switch (btn.tag) {
        case 50:
        {
            if(!btn.selected)
            {
                
                btn.selected = YES;
                
                if(mainDelegate.soundFlag)
                {
                    [buttonClickMusic play];
                }
                
                mainDelegate.emojiFlag = TRUE;
                mainDelegate.yourPhotoFlag = FALSE;
                mainDelegate.facebookPhotoFlag = FALSE;
                
                albumBtn.selected = NO;
                facebookPhotoBtn.selected = NO;
            
            }
            
            break;
    }
            
        case 51:
        {
            
            if(!btn.selected)
            {
                
                
                if(mainDelegate.soundFlag)
                {
                    [buttonClickMusic play];
                }
                
                //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                [self getPhotosFromDevice];
                
                NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                albumBtn.selected = YES;
                facebookPhotoBtn.selected = NO;
                emojiBtn.selected = NO;
                [standardUserDefaults setBool:TRUE forKey:@"devicePhoto"];
                
                mainDelegate.facebookPhotoFlag = FALSE;
                mainDelegate.emojiFlag = FALSE;
                mainDelegate.yourPhotoFlag = TRUE;
                
//                if([[InAppRageIAPHelper sharedHelper].products count] > 0)
//                {
//                    product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
//                    
//                    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
//                    if(!productPurchased)
//                    {
//                        
//                        NSString *str = [NSString stringWithFormat:@"0"];
//                        [self performSelector:@selector(loadThProducts:) withObject:str afterDelay:1.0];
//
//                    }
//                    else
//                    {
//                        btn.selected = YES;
//                        mainDelegate.emojiFlag = FALSE;
//                        mainDelegate.yourPhotoFlag = TRUE;
//                        mainDelegate.facebookPhotoFlag = FALSE;
//                        
//                        emojiBtn.selected = NO;
//                        facebookPhotoBtn.selected = NO;
//                    }
//                }
                
            }

            break;
        }
        case 52:
        {
            
            if(!btn.selected)
            {
                
                
                if(mainDelegate.soundFlag)
                {
                    [buttonClickMusic play];
                }
                
                //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                if([[InAppRageIAPHelper sharedHelper].products count] > 0)
                {
                    product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:1];
                    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
                    if(!productPurchased)
                    {
                        
                        NSString *str = [NSString stringWithFormat:@"1"];
                        [self performSelector:@selector(loadThProducts:) withObject:str afterDelay:1.0];
                        
                    }
                    else
                    {
                        btn.selected = YES;

                        mainDelegate.emojiFlag = FALSE;
                        mainDelegate.yourPhotoFlag = FALSE;
                        mainDelegate.facebookPhotoFlag = TRUE;
                        
                        emojiBtn.selected = NO;
                        albumBtn.selected = NO;
                        
                    }
                }
                
            }

            break;
        }
        default:
            break;
    }

}

-(void)loadThProducts : (NSString *)index
{
    
    NSLog(@"%d", [index intValue]);
    
    NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
    
    SKProduct *product;
    
    NSArray *arr = [InAppRageIAPHelper sharedHelper].products;
    
    if([arr count] > 0)
    {
    
        NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
        product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:[index intValue]];

        [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *str = @"";
        
        if([index intValue] == 0)
        {
        
            str = [NSString stringWithFormat:@"Loading Your Photos"];
            
        }
        else if([index intValue] == 1)
        {
            str = [NSString stringWithFormat:@"Loading Facebook Photos"];
        
        }
        //str = [str stringByAppendingFormat:@"%@",product.productIdentifier];
        _hud.labelText = str;
        [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
        
    }

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

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


- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];    
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    

    
    if ([productIdentifier isEqualToString:@"FacebookPhotos"]) 
    {
        NSLog(@"FacebookPhotos Purchased");
        
        //        GamePage *gamePage = [[GamePage alloc] initWithNibName:@"GamePage" bundle:nil];
        //        [self.navigationController pushViewController:gamePage animated:NO];
        
        [self fbPhotosBtnAction];
        
//        UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Purchased" message:@"You can now play with Facebbok Photos" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //[purchasedAlert show];
        facebookPhotoBtn.selected = YES;
        emojiBtn.selected = NO;
        albumBtn.selected = NO;
        NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setBool:TRUE forKey:@"facebookPhoto"];
        mainDelegate.facebookPhotoFlag = TRUE;
        mainDelegate.emojiFlag = FALSE;
        mainDelegate.yourPhotoFlag = FALSE;

        
        
    }
    else if([productIdentifier isEqualToString:@"DevicePhotos"]) 
    {
        
        [self getPhotosFromDevice];
        
        albumBtn.selected = YES;
        facebookPhotoBtn.selected = NO;
        emojiBtn.selected = NO;
        [standardUserDefaults setBool:TRUE forKey:@"devicePhoto"];

        mainDelegate.facebookPhotoFlag = FALSE;
        mainDelegate.emojiFlag = FALSE;
        mainDelegate.yourPhotoFlag = TRUE;
        
    }
    
}

-(void)getPhotosFromDevice
{
    
    self.assetGroups = [[NSMutableArray alloc] init];
    
    //    ALAssetsLibraryGroupsEnumerationResultsBlock *listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    //    {
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {    
                       
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
                           else{
                               
                               
                               SKProduct *product;
                               
                               NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
                               if([[InAppRageIAPHelper sharedHelper].products count] > 0)
                               {
                                   //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
                                   product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:1];
                                   
                                   [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:product.productIdentifier];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   
                               }
                           
//                               UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You can now play with your Photos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                               [purchasedAlert show];

                           
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
                       
                   });
    
}

-(void)loadImages : (ALAssetsGroup *)assetGrp
{   
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {    
                       
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
                       
                   });
    
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    
    if(buttonIndex == 0)
    {
        
        
    
    
    }


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
            //[self getFriendPicsFromFB];
            
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
    
    SKProduct *product;
    
    NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
    if([[InAppRageIAPHelper sharedHelper].products count] > 0)
    {
        //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:1];
        
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:product.productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You can now play with your Facebook Friends Photos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [purchasedAlert show];
    
    
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
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Now you can play with your facebook photos" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    // [alert show];
    
    //To get the albums 
    //https://graph.facebook.com/me/albums?access_token=AAAFHZBXFW3ZC4BADYj9QZCkArTAKODcCdqrymmEWFYor95xPtZCE1W5mZAd7dDZAk1DZBBAzL2KwO4UoXO09unHGJPnW8AKS4AdSVlRZAj3aiAZDZD
    
    //to get the photos on the basis of album id
    //https://graph.facebook.com/171202463013994/photos?access_token=AAAFHZBXFW3ZC4BADYj9QZCkArTAKODcCdqrymmEWFYor95xPtZCE1W5mZAd7dDZAk1DZBBAzL2KwO4UoXO09unHGJPnW8AKS4AdSVlRZAj3aiAZDZD
    
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
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

-(IBAction)leaderBoardBtnAction:(id)sender
{
    UIButton *temp = (UIButton *)sender;
      
    switch (temp.tag) {
        case 100:
        {
            
            if(!temp.selected)
            {
                
                if(mainDelegate.soundFlag)
                {
                    [buttonClickMusic play];
                }
                
                temp.selected = YES;
                leaderBoardAutoBtn.selected = NO;
                mainDelegate.leaderBoardFlag = FALSE;
            }
                      
            break;
        }
            
        case 101:
        {
            
            if(!temp.selected)
            {
                
                if(mainDelegate.soundFlag)
                {
                    [buttonClickMusic play];
                }
                
                temp.selected = YES;
                leaderBoardOFfBtn.selected = NO;
                mainDelegate.leaderBoardFlag = FALSE;
            }

            
            break;
        }
            
        default:
            break;
    }


}

-(IBAction)scoreResetBtnAction:(id)sender
{
    
    UIButton *temp = (UIButton *)sender;
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }

    
    temp.selected = YES;
    mainDelegate.totalScore = 0;
    [self resetScoreToDb:@"0"];
    
//    if(temp.selected)
//    {
//        temp.selected = NO;
//    }
//    else
//    {
//        temp.selected = YES;
//        mainDelegate.totalScore = 0;
//        [self resetScoreToDb:@"0"];
//        
//    }

}

-(void) resetScoreToDb : (NSString *)string
{
    
	[self initDatabase];
    
    NSLog(@"%@", string);
    
    for(int j = 1; j < 8; j++)
    {
        sqlite3_stmt *updateStmt =nil;
        if(sqlite3_open(dbpath, &memoryappDB) == SQLITE_OK)
        {
            
            NSString *updateQuery = @"";
            if(j < 7)
            {
                updateQuery = [[NSString alloc] initWithFormat:@"update ScoreTbl set score = ? where level = 'level%d'", j];
            }
            else if(j == 7)
            {
                updateQuery = [[NSString alloc] initWithFormat:@"update ScoreTbl set score = ? where level = 'total'"];
            }
            
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

-(IBAction)facebookBtnAction:(id)sender
{
    UIButton *temp = (UIButton *)sender;
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    if(temp.selected)
    {
        
        temp.selected = NO;
    }
    else
    {
        temp.selected = YES;
        
    }

}

-(IBAction)soundBtnAction:(id)sender
{
    
    UIButton *temp = (UIButton *)sender;
    
    if(mainDelegate.soundFlag)
    {
        [buttonClickMusic play];
    }
    
    if(temp.tag == 53)
    {
    
        temp.selected = YES;
        mainDelegate.soundFlag = FALSE;
        
        UIButton *onBtn =(UIButton *)[self.view viewWithTag:54];
        onBtn.selected = NO;
        
    }
    else if(temp.tag == 54)
    {
        temp.selected = YES;
        
        UIButton *offBtn =(UIButton *)[self.view viewWithTag:53];
        offBtn.selected = NO;
        mainDelegate.soundFlag = TRUE;
    
    }

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
    
    //[self dismissModalViewControllerAnimated:NO];
    [self performSelector:@selector(back) withObject:nil afterDelay:0.1];
    
}

-(void) back
{
    backBtn.frame = CGRectMake(backBtn.frame.origin.x, backBtn.frame.origin.y - 4, 72, 24);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory Management Methods

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

