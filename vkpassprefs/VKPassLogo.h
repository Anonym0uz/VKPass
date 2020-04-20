#import <Preferences/Preferences.h>
//#import <Preferences/PSListController.h>
//#import <Preferences/PSSpecifier.h>
//#import <Preferences/PSViewController.h>
//#import <Preferences/PSDetailController.h>

@interface VKPassLogo : PSTableCell
{
    UILabel *heading;
    UILabel *subtitle;
}
@property (nonatomic, strong) UIImageView *logoImageView;
@end

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(PSSpecifier *)specifier;
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
@end

@interface PSTableCell ()
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end
