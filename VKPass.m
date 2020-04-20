#import "VKPass.h"

@implementation VKPass
UITableView *tableView;
//static NSString *CellIdentifier = @"CustomCells";

+ (VKPass *)sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&p, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(VKPass *) init
{
    return self;
}

-(void)showPassView
{
    /*
    BKPasscodeViewController *viewController = [[VKPrefsPasscode sharedInstance] checkPINVC];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:NO completion:nil];
     */
}

- (void)showVKPassSettings
{
    //id mainController = [[objc_getClass("ModernSettingsController") sharedInstance] init];
    //[mainController pushBaseViewController:[[VKPreferencesBundleListController alloc] init]];
    //id vkcController = [[VKColorizeBundleListController alloc] init];
}
@end
// vim:ft=objc
