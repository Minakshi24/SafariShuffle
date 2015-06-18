//
//  AlreadyPurchased.m
//  Match Games 'Social'
//
//  Created by Ankita Chordia on 8/1/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import "AlreadyPurchased.h"
#import "JSON.h"

@implementation AlreadyPurchased
@synthesize hud = _hud;
@synthesize fbGraph;
@synthesize assetGroups;

@synthesize identifierStr;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{
    
}

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
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
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
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(50, 50, 250, 200);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:18];
    label.text = @"You have already purchased this product.Do you want to refresh the list?";
    [label setNumberOfLines:3];
    [self.view addSubview:label];
    
    UIButton *okBtn = [[UIButton alloc] init];
    okBtn.frame = CGRectMake(130, 320, 60, 30);
    okBtn.backgroundColor = [UIColor clearColor];
    [okBtn.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:24]];
    [okBtn.titleLabel setTextColor:[UIColor orangeColor]];
    [okBtn setTitle:@"Ok" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
}

-(IBAction)okBtnAction:(id)sender
{
    if ([identifierStr isEqualToString:@"FacebookPhotos"]) 
    {
        NSLog(@"FacebookPhotos Purchased");
        
        mainDelegate.facebookPhotoUrl = [[NSMutableArray alloc] init];
        
        [self fbPhotosBtnAction];
        
    }
    else if([identifierStr isEqualToString:@"DevicePhotos"]) 
    {
        
        mainDelegate.assets = [[NSMutableArray alloc] init];
        [self getPhotosFromDevice];
        
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
    
    [self performSelector:@selector(back) withObject:nil afterDelay:0.1];
    
}

-(void) back
{
    backBtn.frame = CGRectMake(backBtn.frame.origin.x, backBtn.frame.origin.y - 4, 72, 24);
    [self.navigationController popViewControllerAnimated:YES];
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
                           
                       };
                       
                       // Group Enumerator Failure Block
                       void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                           
                           NSLog(@"%@", error.localizedDescription);
                           
                           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"No Albums Available"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
    
    
    UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Purchased" message:@"You can now play with your Photos" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [purchasedAlert show];
    
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
            [self getFriendPicsFromFB];
            
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
            
            NSURL *url1 = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [friendIdArray objectAtIndex:randomNoForImage]]];
            
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
    
    UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Purchased" message:@"You can now play with Facebbok Friends Photos" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [purchasedAlert show];
    
    
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
