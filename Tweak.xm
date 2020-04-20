#import "VKPass.h"

CFStringRef const cfNotificationString = CFSTR("ru.anonz.vkpassbundle/post");

NSMutableDictionary* settings;
UINavigationController* navigationController;
UIView *view;
BOOL res = TRUE;
BOOL timeCh;
NSBundle* vkBundle;
BKPasscodeViewController *passViewController;
UINavigationController *navController;
VPBiometricAuthenticationFacade *biometricFacade;
int cellIndex;
int cellIndexSettings;
static NSString *CellIdentifier = @"PrefsCell";
//UIWindow* window;
static void loadSettings()
{
	settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFilePath];
	if (![settings objectForKey:@"locationSettings"]) {
		[settings setValue:0 forKey:@"locationSettings"];
		[settings writeToFile:settingsFilePath atomically:NO];
	}
}

static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadSettings();
}

%hook AppDelegate

%new
- (void) showStatusBar {
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2
{
	/*
	passViewController = [[VKPrefsPasscode sharedInstance] checkPINVC];
    navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
    [[self window].rootViewController presentViewController:navController animated:YES completion:nil];
    */
  [[BKPasscodeLockScreenManager sharedManager] setDelegate:self];
  %orig;
    //[[BKPasscodeLockScreenManager sharedManager] setDelegate:self];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *localizationReason;
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([language isEqualToString:@"ru"])
    {
        localizationReason = @"Приложите палец для аутентификации.";
    }
    else
    {
        localizationReason = @"Scan your fingerprint for access.";
    }
    BOOL appIsLoaded = %orig;
    if ([[settings objectForKey:@"sTouchID"] boolValue] == YES && [[settings objectForKey:@"sPINEnabled"] boolValue] == YES && appIsLoaded)
    {
    	passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
    	navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
      //self.window.rootViewController = navController;
      [self.window makeKeyAndVisible];
      [self.window.rootViewController presentViewController:navController animated:YES completion:nil];
    	//[[self window].rootViewController presentViewController:navController animated:YES completion:nil];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        biometricFacade = [[VPBiometricAuthenticationFacade alloc] init];
        if (biometricFacade.isAuthenticationAvailable && [[settings objectForKey:@"sTouchID"] boolValue] == YES) {
		[biometricFacade enableAuthenticationForFeature:@"VKPass" succesBlock:^{
			[biometricFacade authenticateForAccessToFeature:@"VKPass" withReason:localizationReason succesBlock:^{
				[passViewController dismissViewControllerAnimated:YES completion:nil];
					      	 }
							 failureBlock:^(NSError *error){
							 	//[[self window].rootViewController presentViewController:navController animated:YES completion:nil];
							 }];
			}
			failureBlock:^(NSError *error) {
				//[[self window].rootViewController presentViewController:navController animated:YES completion:nil];
			}];
		}
	}
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[settings objectForKey:@"sTouchID"] boolValue] == NO && [[settings objectForKey:@"sPINEnabled"] boolValue] == YES && appIsLoaded)
    {
    	NSTimeInterval delayInSeconds = 1.0;
    	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
        navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
        [[self window].rootViewController presentViewController:navController animated:YES completion:nil];
    });
    	//return %orig;
    }
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //res = %orig(arg1, arg2);
	return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  %orig;
}

// %new
- (void)applicationWillEnterForeground:(UIApplication *)application
{
  %orig;
    loadSettings();
  NSNumber* choose = (NSNumber*)[settings valueForKey: @"timerPass"];
    int chooseVal = [choose intValue];
  switch(chooseVal)
    {
      case 0:
      timeCh = NO;
      break;
      case 1:
      timeCh = YES;
      break;
    }
    loadSettings();

  //SHOW BLOCK APP PASSCODE VIEW
  NSString *localizationReason;
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([language isEqualToString:@"ru"])
    {
        localizationReason = @"Приложите палец для аутентификации.";
    }
    else
    {
        localizationReason = @"Scan your fingerprint for access.";
    }
    if(timeCh == YES)
    {
      if ([[settings objectForKey:@"sTouchID"] boolValue] == YES)
      {
        passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
        navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
        [[self window].rootViewController presentViewController:navController animated:YES completion:nil];
          //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
          biometricFacade = [[VPBiometricAuthenticationFacade alloc] init];
          if (biometricFacade.isAuthenticationAvailable && [[settings objectForKey:@"sTouchID"] boolValue] == YES) {
      [biometricFacade enableAuthenticationForFeature:@"VKPass" succesBlock:^{
        [biometricFacade authenticateForAccessToFeature:@"VKPass" withReason:localizationReason succesBlock:^{
          [passViewController dismissViewControllerAnimated:YES completion:nil];
                   }
               failureBlock:^(NSError *error){
               }];
        }
        failureBlock:^(NSError *error) {
        }];
      }
    }
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
      if ([[settings objectForKey:@"sTouchID"] boolValue] == NO && [[settings objectForKey:@"sPINEnabled"] boolValue] == YES)
      {
        NSTimeInterval delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
          navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
          [[self window].rootViewController presentViewController:navController animated:YES completion:nil];
      });
      }
  }
}

//ПОСЛЕ ЛЮБОГО ДЕЙСТВИЯ ВЫЗОВ
/*
- (void)applicationDidBecomeActive:(id)arg1
{
%orig;
%log(@"==========VK App Active============");
}
*/
%end


////////////////////
//////////////////
%group VK3_0_OR_BIGGEST
//Block messages controller
// %hook DialogsController
// %hook DLVController
%hook ChatController

- (void)viewDidLoad {
  loadSettings();
  if([[settings objectForKey:@"sDialPass"] boolValue] == YES)
  {
    NSString *localizationReason;
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([language isEqualToString:@"ru"])
    {
        localizationReason = @"Приложите палец для аутентификации.";
    }
    else
    {
        localizationReason = @"Scan your fingerprint for access.";
    }
      if ([[settings objectForKey:@"sTouchID"] boolValue] == YES)
      {
        passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
        navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
        [self presentViewController:navController animated:YES completion:nil];
          biometricFacade = [[VPBiometricAuthenticationFacade alloc] init];
          if (biometricFacade.isAuthenticationAvailable && [[settings objectForKey:@"sTouchID"] boolValue] == YES) {
      [biometricFacade enableAuthenticationForFeature:@"VKPass" succesBlock:^{
        [biometricFacade authenticateForAccessToFeature:@"VKPass" withReason:localizationReason succesBlock:^{
          [passViewController dismissViewControllerAnimated:YES completion:^{
            %orig;
          }];
                   }
               failureBlock:^(NSError *error){
                %orig;
               }];
        }
        failureBlock:^(NSError *error) {
          %orig;
        }];
      }
    }
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[settings objectForKey:@"sTouchID"] boolValue] == NO && [[settings objectForKey:@"sDialPass"] boolValue] == YES)
      {
        //NSTimeInterval delayInSeconds = 1.0;
        //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
          navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
          [self presentViewController:navController animated:YES completion:^{
            %orig;
          }];
      //});
      }
  }
  else
    %orig;
}

// -(void)tableView:(id)view didSelectRowAtIndexPath:(id)indexPath
// {
//   loadSettings();
//   if([[settings objectForKey:@"sDialPass"] boolValue])
//   {
//     NSString *localizationReason;
//     NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
//     if ([language isEqualToString:@"ru"])
//     {
//         localizationReason = @"Приложите палец для аутентификации.";
//     }
//     else
//     {
//         localizationReason = @"Scan your fingerprint for access.";
//     }
//       if ([[settings objectForKey:@"sTouchID"] boolValue])
//       {
//         passViewController = [[VKPrefsPasscode sharedInstance] checkPINVC];
//         navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
//         [self presentViewController:navController animated:YES completion:nil];
//           biometricFacade = [[VPBiometricAuthenticationFacade alloc] init];
//           if (biometricFacade.isAuthenticationAvailable && [[settings objectForKey:@"sTouchID"] boolValue]) {
//       [biometricFacade enableAuthenticationForFeature:@"VKPass" succesBlock:^{
//         [biometricFacade authenticateForAccessToFeature:@"VKPass" withReason:localizationReason succesBlock:^{
//           [passViewController dismissViewControllerAnimated:YES completion:nil];
//           %orig;
//                    }
//                failureBlock:^(NSError *error){
//                	%orig;
//                }];
//         }
//         failureBlock:^(NSError *error) {
//         	%orig;
//         }];
//       }
//     }
//       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//     if ([[settings objectForKey:@"sTouchID"] boolValue] == NO && [[settings objectForKey:@"sDialPass"] boolValue])
//       {
//         //NSTimeInterval delayInSeconds = 1.0;
//         //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//         //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//           passViewController = [[VKPrefsPasscode sharedInstance] checkPINVC];
//           navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
//           [self presentViewController:navController animated:YES completion:nil];
//       //});
//         %orig;
//       }
//   }
//   else
//     %orig;
// }
%end
%end
///////////////
///////////////
%group VK2_15_OR_LESS
//Block messages controller
%hook SingleUserChatController
- (void)viewDidLoad {
  loadSettings();
  if([[settings objectForKey:@"sDialPass"] boolValue] == YES)
  {
    NSString *localizationReason;
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([language isEqualToString:@"ru"])
    {
        localizationReason = @"Приложите палец для аутентификации.";
    }
    else
    {
        localizationReason = @"Scan your fingerprint for access.";
    }
      if ([[settings objectForKey:@"sTouchID"] boolValue] == YES)
      {
        passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
        navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
        [self presentViewController:navController animated:YES completion:nil];
          biometricFacade = [[VPBiometricAuthenticationFacade alloc] init];
          if (biometricFacade.isAuthenticationAvailable && [[settings objectForKey:@"sTouchID"] boolValue] == YES) {
      [biometricFacade enableAuthenticationForFeature:@"VKPass" succesBlock:^{
        [biometricFacade authenticateForAccessToFeature:@"VKPass" withReason:localizationReason succesBlock:^{
          [passViewController dismissViewControllerAnimated:YES completion:^{
            %orig;
          }];
                   }
               failureBlock:^(NSError *error){
                %orig;
               }];
        }
        failureBlock:^(NSError *error) {
          %orig;
        }];
      }
    }
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[settings objectForKey:@"sTouchID"] boolValue] == NO && [[settings objectForKey:@"sDialPass"] boolValue] == YES)
      {
        //NSTimeInterval delayInSeconds = 1.0;
        //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
          navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
          [self presentViewController:navController animated:YES completion:^{
            %orig;
          }];
      //});
      }
  }
  else
    %orig;
}
%end
%hook MultiChatController
- (void)viewDidLoad {
  loadSettings();
  if([[settings objectForKey:@"sDialPass"] boolValue] == YES)
  {
    NSString *localizationReason;
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    if ([language isEqualToString:@"ru"])
    {
        localizationReason = @"Приложите палец для аутентификации.";
    }
    else
    {
        localizationReason = @"Scan your fingerprint for access.";
    }
      if ([[settings objectForKey:@"sTouchID"] boolValue] == YES)
      {
        passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
        navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
        [self presentViewController:navController animated:YES completion:nil];
          biometricFacade = [[VPBiometricAuthenticationFacade alloc] init];
          if (biometricFacade.isAuthenticationAvailable && [[settings objectForKey:@"sTouchID"] boolValue] == YES) {
      [biometricFacade enableAuthenticationForFeature:@"VKPass" succesBlock:^{
        [biometricFacade authenticateForAccessToFeature:@"VKPass" withReason:localizationReason succesBlock:^{
          [passViewController dismissViewControllerAnimated:YES completion:^{
            %orig;
          }];
                   }
               failureBlock:^(NSError *error){
                %orig;
               }];
        }
        failureBlock:^(NSError *error) {
          %orig;
        }];
      }
    }
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[settings objectForKey:@"sTouchID"] boolValue] == NO && [[settings objectForKey:@"sDialPass"] boolValue] == YES)
      {
        //NSTimeInterval delayInSeconds = 1.0;
        //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          passViewController = [[VKPrefsPasscode sharedInstance] checkPINVCWithType:@"EnablePIN"];
          navController = [[UINavigationController alloc] initWithRootViewController:passViewController];
          [self presentViewController:navController animated:YES completion:^{
            %orig;
          }];
      //});
      }
  }
  else
    %orig;
}
%end
%end
///////////////
///////////////

// int cellIndex;
@interface MenuViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
- (void)vkcView;
// -(int)settingsLocation;
@end
%hook MenuViewController
- (void)viewWillAppear:(BOOL)animated {
	%orig;
	// if ([[settings objectForKey:@"settingsMenu"] boolValue] == YES)
	[self.tableView reloadData];
}
// %new
// -(int)settingsLocation {
// 	NSNumber* locationNum = (NSNumber*)[settings valueForKey: @"locationSettings"];
//     int chooseVal = [locationNum intValue];
//   switch(chooseVal)
//     {
//       case 0:
//       return 0;
//       break;
//       case 1:
//       return 1;
//       break;
//     }
//     return 0;
// }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	loadSettings();
    // if([[[[VKPreferences sharedInstance] settings] objectForKey:@"sMenuChange"] boolValue])
    // {
    //     menu = [[NSMutableDictionary alloc] initWithContentsOfFile:menuFile];
    //     enabled = [menu valueForKey:@"enabled"];
    //     return enabled.count;
    // }
    // else
    // {
    if (section == 0 && [[settings objectForKey:@"settingsMenu"] boolValue] == YES) {
        int a = %orig;
        cellIndex = a;
        return a + 1;
    }
    else
        return %orig;
    // }
}


-(UITableViewCell*)tableView:(id)view cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = %orig;
    if (indexPath.row == cellIndex && indexPath.section == 0 && [[settings objectForKey:@"settingsMenu"] boolValue] == YES) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VKPassCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VKPassCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *customColorView = [[UIView alloc] init];
        customColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView =  customColorView;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"VKPass";
        UIImage *iconVKPass = [UIImage imageNamed:@"VKPass_menu"];
        cell.imageView.image = iconVKPass;
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && cellIndex == indexPath.row && [[settings objectForKey:@"settingsMenu"] boolValue] == YES)
        return 45;
    else
        return %orig;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == cellIndex && indexPath.section == 0 && [[settings objectForKey:@"settingsMenu"] boolValue] == YES) {
    [self vkcView];
  }
  else {
    %orig;
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

%new
-(void)vkcView
{
  UIViewController *accounts = [[VKPassPrefsListController alloc] init];
  [self.navigationController pushViewController:accounts animated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

%end

@interface ModernSettingsController : UIViewController
-(void)vkcView;
@end
%hook ModernSettingsController
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // if([[[[VKPreferences sharedInstance] settings] objectForKey:@"sMenuChange"] boolValue])
    // {
    //     menu = [[NSMutableDictionary alloc] initWithContentsOfFile:menuFile];
    //     enabled = [menu valueForKey:@"enabled"];
    //     return enabled.count;
    // }
    // else
    // {
    if (section == 1) {
        int a = %orig;
        cellIndexSettings = a;
        return a + 1;
    }
    else
        return %orig;
    // }
}
-(UITableViewCell*)tableView:(id)view cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = %orig;
    if (indexPath.row == cellIndexSettings && indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VKPassCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VKPassCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *customColorView = [[UIView alloc] init];
        customColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView =  customColorView;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"VKPass";
        UIImage *iconVKPass = [UIImage imageNamed:@"VKPass_menu"];
        cell.imageView.image = iconVKPass;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == cellIndexSettings && indexPath.section == 1) {
    [self vkcView];
  }
  else {
    %orig;
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// -(void)viewDidLoad
// {
//     //JAILED VERSION
//     UIImage *moreImage = [UIImage imageNamed:@"/Library/Application Support/VKPassTest/navigation_bar_more.png"];
//     //NON-JAIL VERSION
//     /*
//     vkBundle = [NSBundle mainBundle];
//     NSString* strMoreImage = [vkBundle pathForResource:@"navigation_bar_more" ofType:@"png"];
//     UIImage *moreImage = [UIImage imageWithContentsOfFile:strMoreImage];
//     */
//     UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
//     more.bounds = CGRectMake( 0, 0, moreImage.size.width, moreImage.size.height );
//     [more setImage:moreImage forState:UIControlStateNormal];
//     [more addTarget:self action:@selector(vkcView:) forControlEvents:UIControlEventTouchUpInside];
//     UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithCustomView:more];
//     [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:moreButton, nil]];
// 	%orig;
// }
%new
-(void)vkcView
{
  UIViewController *accounts = [[VKPassPrefsListController alloc] init];
  [self.navigationController pushViewController:accounts animated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
%end

%ctor
{
	// NSString *appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
	CGFloat versionNumber;

    NSArray *versionItems = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];

    if (versionItems.count == 3)
    {
        NSInteger major = [[versionItems objectAtIndex:0] integerValue];
        NSInteger minor = [[versionItems objectAtIndex:1] integerValue];
        NSInteger bug = [[versionItems objectAtIndex:2] integerValue];

        versionNumber = [[NSString stringWithFormat:@"%ld.%ld%ld",(long)major,(long)minor,(long)bug] floatValue];
    }
    else
    {
        versionNumber = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
    }
		%init(_ungrouped);
		if (versionNumber >= 3.0) {
			%init(VK3_0_OR_BIGGEST);
		}
		else if (versionNumber <= 3.0) {
			%init(VK2_15_OR_LESS);
		}
	  // Add observer to be notified when Preferences for this bundle change
  // When preferences change, call prefsChanged() to reload the preferences into this Tweak's global variables.
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
      NULL,
      &prefsChanged,
      cfNotificationString,
      NULL,
      CFNotificationSuspensionBehaviorDeliverImmediately);
  // Reload them anyway.
	loadSettings();
}
