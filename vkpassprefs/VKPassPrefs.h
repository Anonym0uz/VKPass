#import <Preferences/Preferences.h>
//#import <Preferences/PSListController.h>
//#import <Preferences/PSSpecifier.h>
#import "VKPrefsPasscode.h"
#import "VKPPaths.h"
#import "VKPassLP.h"

@interface VKPassPrefsListController: PSListController <VKPrefsPasscodeDelegate> {
    BOOL shouldReload;
}
@end
