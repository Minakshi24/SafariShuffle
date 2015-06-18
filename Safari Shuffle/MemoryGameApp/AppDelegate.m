//
//  AppDelegate.m
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstPage.h"
#import "LevelSelectionPage.h"
#import "InAppRageIAPHelper.h"
#import "FlurryAnalytics.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navigationController;
@synthesize totalScore;

@synthesize facebookPhotoUrl;
@synthesize facebookPhotoFlag, yourPhotoFlag, emojiFlag;

@synthesize assets, gameCount, assetGroups;

@synthesize level1Flag, level2Flag, level3Flag, level4Flag, level5Flag, level6Flag, soundFlag, leaderBoardFlag;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    totalScore = 0;
    soundFlag = TRUE;
    leaderBoardFlag = TRUE;
    gameCount = 0;
    
    
//    [self getPhotosFromDevice];
//    
//    activityAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Loading....Please Wait!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    
//    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityView.frame = CGRectMake(110, 45, 55.0, 55.0);
//    [activityView startAnimating];
//    [activityAlert addSubview:activityView];    
//    [self.window addSubview:activityAlert];
//    
//    [activityAlert show]; 
    
    
    facebookPhotoFlag = FALSE;
    yourPhotoFlag = TRUE;
    emojiFlag = FALSE;
    
//    facebookPhotoUrl = [[NSMutableArray alloc] init];
//    assets = [[NSMutableArray alloc] init];
//    
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageIAPHelper sharedHelper]];
//    
//    [FlurryAnalytics startSession:@"BWJF9NHSKXQXPJ7W65NT"];
//    
//    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    [standardUserDefaults setBool:FALSE forKey:@"facebookPhoto"];
//    [standardUserDefaults setBool:TRUE forKey:@"devicePhoto"];
//    [standardUserDefaults setBool:FALSE forKey:@"timetable"];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:[[FirstPage alloc] initWithNibName:@"FirstPage" bundle:nil]];
    [self.window addSubview:navigationController.view];
    
    //self.window.rootViewController = [[LevelSelectionPage alloc] initWithNibName:@"LevelSelectionPage" bundle:nil];
    
    [self.window makeKeyAndVisible];
    return YES;
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
                               
                               if(activityAlert != nil)
                               {
                                   [activityAlert dismissWithClickedButtonIndex:0 animated:NO];
                                   [activityView release];
                                   activityView = nil;
                                   activityAlert = nil;
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
                               [self.assets addObject:result];
                               
                           }
                       };
                       
                       [assetGroup enumerateAssetsUsingBlock:assetEnumerator];
                       
                   });
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
