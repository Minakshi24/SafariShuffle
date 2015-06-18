

#import "RootViewController.h"
#import "InAppRageIAPHelper.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "GamePage.h"
#import "AlreadyPurchased.h"
#import "LevelSelectionPage.h"
#import "ComingSoonPage.h"
#import "JSON.h"

@implementation RootViewController
@synthesize hud = _hud;
@synthesize fbGraph;
@synthesize assetGroups;

#pragma mark -
#pragma mark View lifecycle

-(void) clickOnCancelBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) clickOniTunesButton
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://click.linksynergy.com/fs-bin/stat?id=ek7tbqB9Ae0&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fau%252Fgenre%252Fmusic%252Fid34%253FpartnerId%253D30"]];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{

}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.hidden = YES;

    mainDelegate = [[UIApplication sharedApplication]delegate];
    
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buttonClick.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error1;
    buttonClickMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error1];
    [buttonClickMusic prepareToPlay];
    
    w = mainDelegate.window.frame.size.width;
    h = mainDelegate.window.frame.size.height;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.title = @"In App BabyAnimalPuzzle";
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:18];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor orangeColor]; // change this color
    //self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"In App Memory Match", @"");
    [label sizeToFit];
    
//    UIImage *tempImage = [self imageWithImage:[UIImage imageNamed:@"navBack.png"] scaledToSize:CGSizeMake(320, 55) ];
    
//    [self.navigationController.navigationBar setBackgroundImage:tempImage forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationItem.hidesBackButton = YES;
//    self.navigationController.navigationItem.backBarButtonItem = nil;

//    UIBarButtonItem  *item = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStylePlain
//    [self.navigationItem setRightBarButtonItem:item animated:YES];
    
    self.navigationController.navigationBarHidden = YES;
    

        
//    detailView = [[UIView alloc] initWithFrame:CGRectMake(30*w/320, 10*h/480, 260*w/320, 380*h/480)];
//    [detailView setBackgroundColor:[UIColor blueColor]];
//    [detailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"store_bg.png"]]];
//    detailView.hidden = TRUE;
//    
//    detailView.hidden = NO;
//   // viewBackButton.hidden = NO;
//    int y = 70;
//    hint150 =[UIButton buttonWithType:UIButtonTypeCustom];
//    [hint150 setFrame:CGRectMake(40*w/320, y*h/480, 180*w/320, 30*h/480)];
//    [hint150 setImage:[UIImage imageNamed:@"150Hint.png"] forState:UIControlStateNormal];
//    [hint150 addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:hint150];
//    [hint150 setTag:0];
//    y = y + 40;
//    
//    hint300 =[UIButton buttonWithType:UIButtonTypeCustom];
//    [hint300 setFrame:CGRectMake(40*w/320, y*h/480, 180*w/320, 30*h/480)];
//    [hint300 setImage:[UIImage imageNamed:@"300Hints.png"] forState:UIControlStateNormal];
//    [hint300 addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:hint300];
//    [hint300 setTag:1];
//    y = y + 40;
//    
//    award20 =[UIButton buttonWithType:UIButtonTypeCustom];
//    [award20 setFrame:CGRectMake(40*w/320, y*h/480, 180*w/320, 30*h/480)];
//    [award20 setImage:[UIImage imageNamed:@"20Award.png"] forState:UIControlStateNormal];
//    [award20 addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:award20];
//    [award20 setTag:2];
//    y = y + 40;
//    
//    award200 =[UIButton buttonWithType:UIButtonTypeCustom];
//    [award200 setFrame:CGRectMake(40*w/320, y*h/480, 180*w/320, 30*h/480)];
//    [award200 setImage:[UIImage imageNamed:@"200Award.png"] forState:UIControlStateNormal];
//    [award200 addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:award200];
//    [award200 setTag:3];
//    y = y + 40;
//    
//    valuePack =[UIButton buttonWithType:UIButtonTypeCustom];
//    [valuePack setFrame:CGRectMake(40*w/320, y*h/480, 180*w/320, 30*h/480)];
//    [valuePack setImage:[UIImage imageNamed:@"NoAds.png"] forState:UIControlStateNormal];
//    [valuePack addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:valuePack];
//    [valuePack setTag:4];
//    y = y + 40;
//    
//    cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelBtn setFrame:CGRectMake(40*w/320, y*h/480, 180*w/320, 30*h/480)];
//    [cancelBtn setImage:[UIImage imageNamed:@"store_cancel.png"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(clickOnCancelBtn) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:cancelBtn];
//    
//    iTuneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [iTuneBtn setFrame:CGRectMake(95*w/320, 340*h/480, 70*w/320, 25*h/480)];
//    [iTuneBtn setImage:[UIImage imageNamed:@"iTunes.png"] forState:UIControlStateNormal];
//    [iTuneBtn addTarget:self action:@selector(clickOniTunesButton) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:iTuneBtn];
//    
//    [self.view addSubview:detailView];

    // set the nav bar's right button item
    //self.navigationItem.rightBarButtonItem = item;
     
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstBack.png"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 480);
    //[self.view addSubview:backgroundImageView];

    moreView = [[UIView alloc] init];
    moreView.frame = CGRectMake(0, 0, 320, 480);
    moreView.backgroundColor = [UIColor lightGrayColor];
    moreView.layer.cornerRadius = 5.0;
    [self.view addSubview:moreView];
    
    UIImageView *moreBack = [[UIImageView alloc] init];
    moreBack.frame = CGRectMake(0, 0, 320, 480);
    moreBack.image = [UIImage imageNamed:@"moreBack1.png"];
    [moreView addSubview:moreBack];
    
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
    
    restoreBtn = [[UIButton alloc] init];
    restoreBtn.tag = 1001;
    restoreBtn.frame = CGRectMake(235, 8, 73, 20);
    restoreBtn.backgroundColor = [UIColor clearColor];
    [restoreBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [restoreBtn.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:20]];
    [restoreBtn setImage:[UIImage imageNamed:@"restoreBtn1.png"] forState:UIControlStateNormal];
    //[restoreBtn setTitle:@"Restore" forState:UIControlStateNormal];
    [restoreBtn addTarget:self action:@selector(checkPurchasedItems) forControlEvents:UIControlEventTouchUpInside];
    [navImage addSubview:restoreBtn];
    
    UIButton *fbPhotosBtn = [[UIButton alloc] init];
    fbPhotosBtn.tag = 100;
    fbPhotosBtn.frame = CGRectMake(30, 110, 260, 66);
    fbPhotosBtn.backgroundColor = [UIColor clearColor];
    [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtn.png"] forState:UIControlStateNormal];
    [fbPhotosBtn setImage:[UIImage imageNamed:@"fbBtnPressed.png"] forState:UIControlStateSelected];
    [fbPhotosBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:fbPhotosBtn];
    
    UIButton *yourPhotosBtn = [[UIButton alloc] init];
    yourPhotosBtn.tag = 101;
    yourPhotosBtn.frame = CGRectMake(30, 190, 260, 66);
    yourPhotosBtn.backgroundColor = [UIColor clearColor];
    [yourPhotosBtn setImage:[UIImage imageNamed:@"triviaQuizBtn.png"] forState:UIControlStateNormal];
    //[yourPhotosBtn addTarget:self action:@selector(showAchievements:) forControlEvents:UIControlEventTouchUpInside];
    [yourPhotosBtn addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:yourPhotosBtn];
    
    UIButton *memoryMatchTableGame = [[UIButton alloc] init];
    memoryMatchTableGame.tag = 102;
    memoryMatchTableGame.frame = CGRectMake(30, 275, 260, 66);
    memoryMatchTableGame.backgroundColor = [UIColor clearColor];
    [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatch.png"] forState:UIControlStateNormal];
    [memoryMatchTableGame setImage:[UIImage imageNamed:@"memoryMatchPressed.png"] forState:UIControlStateSelected];
    [memoryMatchTableGame addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:memoryMatchTableGame];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.tag = 103;
    cancelBtn.frame = CGRectMake(30, 360, 260, 66);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"cancelBtnPressed.png"] forState:UIControlStateSelected];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:cancelBtn];
    
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


-(IBAction)cancelAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:NO];

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

- (void)viewWillAppear:(BOOL)animated {

    //self.tableView.hidden = TRUE;

    self.navigationController.navigationBarHidden = NO;
     self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) 
    {        
        NSLog(@"No internet connection!");        
    } 
    else 
    {        
        if ([InAppRageIAPHelper sharedHelper].products == nil)
        {
            
            [[InAppRageIAPHelper sharedHelper] requestProducts];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Loading ...";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
            
        }        
    }

    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source
/*
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[InAppRageIAPHelper sharedHelper].products count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    mainDelegate = [[UIApplication sharedApplication] delegate];
    
    if (mainDelegate.window.frame.size.height == 1024)
    {
        return 100;        
    }
    else
    {
        return 40;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:indexPath.row];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];

    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = formattedString;

    if ([[InAppRageIAPHelper sharedHelper].purchasedProducts containsObject:product.productIdentifier]) 
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
        
//        mainDelegate.purchased_flag = 1;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Purchase successful. Tap OK to download it now." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
//        [mainDelegate.productListArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    } 
    else 
    {     
        if (mainDelegate.window.frame.size.height == 1024)
        {
            UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            buyButton.frame = CGRectMake(0, 0, 172, 79);
            [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
            [buyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
            buyButton.tag = indexPath.row;
            [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = buyButton; 
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:30]];
            [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:24]];
        }
        else
        {
            UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            buyButton.frame = CGRectMake(0, 0, 72, 37);
            [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
            buyButton.tag = indexPath.row;
            [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = buyButton; 
        }
            
        
    }

    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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

            NSString *str = @"https://itunes.apple.com/hk/app/trivia-quiz-music/id546627825?mt=8";
            NSURL *url = [[NSURL alloc] initWithString:str];
            [[UIApplication sharedApplication] openURL:url];
            
//            [self getPhotosFromDevice];
//            
//            mainDelegate.facebookPhotoFlag = FALSE;
//            mainDelegate.emojiFlag = FALSE;
//            mainDelegate.yourPhotoFlag = TRUE;
            
//            if([[InAppRageIAPHelper sharedHelper].products count] > 0)
//            {
//                 //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
//                product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
//                BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
//                if(!productPurchased)
//                {
//                
//                    NSLog(@"Buying %@...", product.productIdentifier);
//                    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
//                    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//                    NSString *str = [NSString stringWithFormat:@"Loading Your Photos"];
//                    //str = [str stringByAppendingFormat:@"%@",product.productIdentifier];
//                    _hud.labelText = str;
//                    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
//                    
//                }
//                else
//                {
//                    photosPurchase = [[UIAlertView alloc] initWithTitle:@"" message:@"You've already purchased this.Do you want to refresh the list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//                    [photosPurchase show];
//                    
//                }
//            }
            break;
        
        }
        
        case 102:
        {
            
//            ComingSoonPage *comingSoonPage = [[ComingSoonPage alloc] initWithNibName:@"ComingSoonPage" bundle:nil];
//            [self.navigationController pushViewController:comingSoonPage animated:NO];
            
            NSString *str = @"https://itunes.apple.com/us/app/times-table-match/id553809657?ls=1&mt=8";
            NSURL *url = [[NSURL alloc] initWithString:str];
            [[UIApplication sharedApplication] openURL:url];
            
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        
    
    if(alertView == photosPurchase)
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
    
    if(alertView == fbPhotosPurchased)
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
//    else if([productIdentifier isEqualToString:@"DevicePhotos"]) 
//    {
//        [self getPhotosFromDevice];
//        
//    }
    
}

-(void)getPhotosFromDevice
{
    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    NSString *str = [NSString stringWithFormat:@"Loading...Please wait"];
//    //str = [str stringByAppendingFormat:@"%@",product.productIdentifier];
//    _hud.labelText = str;
    
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
            
//            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//            self.hud = nil;
//            
//            SKProduct *product;
//            
//            NSLog(@"Product List : %@",[InAppRageIAPHelper sharedHelper].products);
//            if([[InAppRageIAPHelper sharedHelper].products count] > 0)
            {
                //NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
//                product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
                
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"DevicePhotos"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            UIAlertView *purchasedAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You can now play with your Photos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [purchasedAlert show];
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

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    self.hud = nil;
}

- (void)dealloc 
{
    [_hud release];
    _hud = nil;
    [super dealloc];
}

@end

