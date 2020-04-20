#import "VKPassPrefs.h"
// #import "VKPassLogo.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

NSMutableDictionary *passcodeFDict;
NSMutableDictionary *prefsDict;

@implementation VKPassPrefsListController

- (id)specifiers {
    loadprefsDict();
    // Reload all elements if 1) they aren't loaded yet, or 2) something changed in the UI
    if (shouldReload) {
        shouldReload = NO;
        [_specifiers release];
        _specifiers = nil;
    }
    if (!_specifiers) {
        // Using MutableArray so we can remove certain elements as needed.
        NSMutableArray *specifiers = [[self loadSpecifiersFromPlistName:@"VKPassPrefs" target:self] mutableCopy];

        // Get preference values, so we know what is enabled/disabled.
        NSDictionary *exchangentSettings = [NSDictionary dictionaryWithContentsOfFile:settingsPath];

        passcodeFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:passcodePath];

        id _tempValue;

        // Check if tweak is enabled.
        _tempValue = [exchangentSettings objectForKey:@"sPINEnabled"];
        BOOL isPasscodeEnabled = _tempValue ? [_tempValue boolValue] : NO;

        NSMutableArray *specifiersToRemove = [[NSMutableArray alloc] init];
        for (PSSpecifier *specifier in specifiers) {
            // Boolean logic.
            if ([_tempValue boolValue] == NO && ![[NSFileManager defaultManager] fileExistsAtPath:passcodePath] && ![passcodeFDict objectForKey:@"Passcode"]) {
                // [specifier.properties[@"key"] if switch
                // specifier.identifier if label
                // All actions hide
                if ([specifier.properties[@"action"] isEqualToString:@"changePINVC"])
                    [specifiersToRemove addObject:specifier];
                else if ([specifier.properties[@"action"] isEqualToString:@"deletePINVC"])
                    [specifiersToRemove addObject:specifier];
                else if ([specifier.properties[@"action"] isEqualToString:@"lostPass"])
                    [specifiersToRemove addObject:specifier];
                else if ([specifier.properties[@"key"] isEqualToString:@"timerPass"])
                    [specifiersToRemove addObject:specifier];
                else if ([specifier.properties[@"id"] isEqualToString:@"plss"])
                    [specifiersToRemove addObject:specifier];
                else if ([specifier.properties[@"id"] isEqualToString:@"footerWarning"])
                    [specifiersToRemove addObject:specifier];
            }
        }
                // Remove those specifiers.
        for (PSSpecifier *specifierToRemove in specifiersToRemove)
        {
            [specifiers removeObject:specifierToRemove];
        }
        _specifiers = [specifiers copy];
        [specifiers release];
    }
	// if(_specifiers == nil) {
	// 	_specifiers = [[self loadSpecifiersFromPlistName:@"VKPassPrefs" target:self] retain];
	// }
	return _specifiers;
}

static void loadprefsDict()
{
    prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:settingsPath])
    {
        NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] init];
        [prefsDict writeToFile:settingsPath atomically:NO];
    }
}

-(void)myVKLink
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vk://vk.com/orlov_alexender"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"vk://vk.com/orlov_alexender"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://vk.com/orlov_alexender"]];
}

-(void)cr0wAppsLink
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vk://vk.com/cr0wapps"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"vk://vk.com/cr0wapps"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://vk.com/cr0wapps"]];
}

-(void)oneScriptLink
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tg://resolve?domain=OneScriptVK"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tg://resolve?domain=OneScriptVK"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/OneScriptVK"]];
}

-(void)siteFox
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://f0x.pw"]];
}

-(void)sponsoredLink
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vk://vk.com/jailgeek"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"vk://vk.com/jailgeek"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://vk.com/jailgeek"]];
}

-(NSString*)tweakVersion:(PSSpecifier *)specifier
{
    return @"1.2-JB";
}

-(NSString*)vkVersion:(PSSpecifier *)specifier
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

/*
 //Версия твика (В зависимости от билда)
 - (NSString *)valueForSpecifierVersion:(PSSpecifier *)specifier
 {
 //return @"0.9.7-only for testing";
 NSTask *task = [[NSTask alloc] init];
 [task setLaunchPath: @"/bin/sh"];
 [task setArguments:[NSArray arrayWithObjects: @"-c", @"dpkg -s ru.anonz.vkpreferences | grep 'Version'", nil]];
 NSPipe *pipe = [NSPipe pipe];
 [task setStandardOutput:pipe];
 [task launch];

 NSData *data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
 NSString *version = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
 version = [version stringByReplacingOccurrencesOfString:@"Version: " withString:@""];
 //version = [version stringByReplacingOccurrencesOfString:@"\n" withString:@""];

 return version;
 }
 */

- (BOOL)canAuthenticateByTouchId {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    }
    return NO;
}

-(BOOL)passcodeEnable
{
    passcodeFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:passcodePath];
    if ([passcodeFDict objectForKey:@"Passcode"])
    {
        return YES;
    }
    else
        return NO;
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)spec
{
    loadprefsDict();
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    [defaults setObject:value forKey:spec.properties[@"key"]];
    [defaults writeToFile:settingsPath atomically:NO];
    //[self reloadSpecifiers];
    // [self passcodeEnable];
    // if ([self passcodeEnable] == NO)
    // {
    //     [self reloadSpecifiers];
    // }
    if([[spec propertyForKey:@"key"] isEqualToString:@"sPINEnabled"])
    {
        loadprefsDict();
        if([value intValue] == 1) {
            [self enablePINSwitch];
        }
        else if ([value intValue] == 0 && [[NSFileManager defaultManager] fileExistsAtPath:passcodePath]) {
            [self disablePINSwitch];
        }
    }
    if([[spec propertyForKey:@"key"] isEqualToString:@"sDialPass"])
    {
        loadprefsDict();
        if([value intValue] == 1) {
            [self enableDialogsPINSwitch];
        }
        else if ([value intValue] == 0 && [self passcodeEnable] == YES) {
            [self disableDialogsPINSwitch];
        }
    }
    if([[spec propertyForKey:@"key"] isEqualToString:@"sTouchID"])
    {
        loadprefsDict();
        if([value intValue] == 1) {
            if ([self canAuthenticateByTouchId] == NO) {
              [self createTouchIDAlert];
            }
        }
    }
    /*
    NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    [prefsDict setValue:value forKey:[spec propertyForKey:@"key"]];
    [prefsDict writeToFile:settingsPath atomically: NO];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("ru.anonz.vkpassbundle/post"), NULL, NULL, YES);
    */
        //[self reloadSpecifiers];

    // Send Notification (via Darwin) if one is specified for the preference value.
    // This will notify the Tweak (.xm) that the preference value changed.
    CFStringRef toPost = (CFStringRef)spec.properties[@"PostNotification"];
    if (toPost) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
        loadprefsDict();
        [self reloadSpecifiers];
    }
}

- (void)createTouchIDAlert {
  NSString *localizationMessage;
  NSString *localizationCancelBtn;
  NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
  if ([language isEqualToString:@"ru"]) {
      localizationMessage = @"Ваше устройство не поддерживает Touch ID! Настройка выключена.";
      localizationCancelBtn = @"OK";
  } else {
      localizationMessage = @"Your device doesn't support Touch ID! Switch is off.";
      localizationCancelBtn = @"OK";
  }
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"VKPass"
                 message:localizationMessage
                 preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@":(" style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                   NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
                                   [prefsDict setValue:@NO forKey:@"sTouchID"];
                                   [prefsDict writeToFile:settingsPath atomically:NO];
                                   [self reloadSpecifiers];
                                 }];

  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)passcodeSet {
  NSString *localizationMessage;
  NSString *localizationCancelBtn;
  NSString *localizationOtherBtn;
  NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
  if ([language isEqualToString:@"ru"]) {
      localizationMessage = @"Пароля не существует, сначала создайте пароль! \nPS. Для тех, кто забудет пароль, ниже, после создания пароля, будет кнопка <Забыли пароль?>, нажмите и создайте контрольную фразу, по которой Вы сможете восстановить пароль.";
      localizationCancelBtn = @"OK";
      localizationOtherBtn = @"Создать пароль";
  } else {
      localizationMessage = @"Password doesn't exist, first create a password! \nPS. If you don't want to forget password, please, tap on <Forgot password?> button and create key phrase and You will be able to recover the password.";
      localizationCancelBtn = @"OK";
      localizationOtherBtn = @"Create password";
  }
  passcodeFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:passcodePath];
  if (![[NSFileManager defaultManager] fileExistsAtPath:passcodePath] || ![passcodeFDict objectForKey:@"Passcode"])
  {
      [UIAlertView showWithTitle:@"VKPass"
                         message:localizationMessage
               cancelButtonTitle:localizationCancelBtn
               otherButtonTitles:@[localizationOtherBtn]
                        tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == [alertView cancelButtonIndex])
                            {
                                NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
                                [prefsDict setValue:@NO forKey:@"sPINEnabled"];
                                [prefsDict writeToFile:settingsPath atomically:NO];
                                // [self setPreferenceValue:@NO specifier:[self specifierForID:@"enablePINSwitch"]];
                                [self reloadSpecifierID:@"enablePINSwitch" animated:YES];
                            }
                            else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:localizationOtherBtn])
                            {
                                VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
                                prefsPass.delegate = self;
                                BKPasscodeViewController *viewController = [prefsPass setPINVC];
                                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                                [navController setModalPresentationStyle:UIModalPresentationFormSheet];
                                [self presentViewController:navController animated:YES completion:nil];
                            }
                        }];
                        return NO;
  }
  else if ([[NSFileManager defaultManager] fileExistsAtPath:passcodePath]) {
    return YES;
  }
  return NO;
}

- (void)enablePINSwitch {
  NSString *localizationMessage;
  NSString *localizationCancelBtn;
  NSString *localizationOtherBtn;
  NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
  if ([language isEqualToString:@"ru"]) {
      localizationMessage = @"Пароля не существует, сначала создайте пароль! \nPS. Для тех, кто забудет пароль, ниже, после создания пароля, будет кнопка <Забыли пароль?>, нажмите и создайте контрольную фразу, по которой Вы сможете восстановить пароль.";
      localizationCancelBtn = @"OK";
      localizationOtherBtn = @"Создать пароль";
  } else {
      localizationMessage = @"Password doesn't exist, first create a password! \nPS. If you don't want to forget password, please, tap on <Forgot password?> button and create key phrase and You will be able to recover the password.";
      localizationCancelBtn = @"OK";
      localizationOtherBtn = @"Create password";
  }
  passcodeFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:passcodePath];
  if (![[NSFileManager defaultManager] fileExistsAtPath:passcodePath] || ![passcodeFDict objectForKey:@"Passcode"])
  {
      [UIAlertView showWithTitle:@"VKPass"
                         message:localizationMessage
               cancelButtonTitle:localizationCancelBtn
               otherButtonTitles:@[localizationOtherBtn]
                        tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == [alertView cancelButtonIndex])
                            {
                                NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
                                [prefsDict setValue:@NO forKey:@"sPINEnabled"];
                                [prefsDict writeToFile:settingsPath atomically:NO];
                                // [self setPreferenceValue:@NO specifier:[self specifierForID:@"enablePINSwitch"]];
                                [self reloadSpecifierID:@"enablePINSwitch" animated:YES];
                            }
                            else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:localizationOtherBtn])
                            {
                                VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
                                prefsPass.delegate = self;
                                BKPasscodeViewController *viewController = [prefsPass setPINVC];
                                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                                [navController setModalPresentationStyle:UIModalPresentationFormSheet];
                                [self presentViewController:navController animated:YES completion:nil];
                            }
                        }];
  }
  else if ([[NSFileManager defaultManager] fileExistsAtPath:passcodePath]) //|| [passcodeFDict objectForKey:@"Passcode"])
  {
      VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
      prefsPass.delegate = self;
      BKPasscodeViewController *viewController = [prefsPass checkPINVCWithType:@"EnablePIN"];
      UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
      [navController setModalPresentationStyle:UIModalPresentationFormSheet];
      [self presentViewController:navController animated:YES completion:nil];
  }
}

- (void)disablePINSwitch {
  passcodeFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:passcodePath];
  if ([passcodeFDict objectForKey:@"Passcode"])
  {
      VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
      prefsPass.delegate = self;
      BKPasscodeViewController *viewController = [prefsPass checkDisablePINVCWithType:@"DisablePIN"];
      UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
      [navController setModalPresentationStyle:UIModalPresentationFormSheet];
      [self presentViewController:navController animated:YES completion:nil];
  }
}

- (void)enableDialogsPINSwitch {
  NSString *localizationMessage;
  NSString *localizationCancelBtn;
  NSString *localizationOtherBtn;
  NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
  if ([language isEqualToString:@"ru"]) {
      localizationMessage = @"Пароля не существует, сначала создайте пароль! \nPS. Для тех, кто забудет пароль, ниже, после создания пароля, будет кнопка <Забыли пароль?>, нажмите и создайте контрольную фразу, по которой Вы сможете восстановить пароль.";
      localizationCancelBtn = @"OK";
      localizationOtherBtn = @"Создать пароль";
  } else {
      localizationMessage = @"Password doesn't exist, first create a password! \nPS. If you don't want to forget password, please, tap on <Forgot password?> button and create key phrase and You will be able to recover the password.";
      localizationCancelBtn = @"OK";
      localizationOtherBtn = @"Create password";
  }
  passcodeFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:passcodePath];
  if (![[NSFileManager defaultManager] fileExistsAtPath:passcodePath] || ![passcodeFDict objectForKey:@"Passcode"])
  {
    NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    [prefsDict setValue:@YES forKey:@"sHZ"];
    [prefsDict writeToFile:settingsPath atomically:NO];
      [UIAlertView showWithTitle:@"VKPass"
                         message:localizationMessage
               cancelButtonTitle:localizationCancelBtn
               otherButtonTitles:@[localizationOtherBtn]
                        tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex == [alertView cancelButtonIndex])
                            {
                                NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
                                [prefsDict setValue:@NO forKey:@"sDialPass"];
                                [prefsDict writeToFile:settingsPath atomically:NO];
                                // [self setPreferenceValue:@NO specifier:[self specifierForID:@"enablePINSwitch"]];
                                [self reloadSpecifierID:@"dialogsPINSwitch" animated:YES];
                            }
                            else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:localizationOtherBtn])
                            {
                                VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
                                prefsPass.delegate = self;
                                BKPasscodeViewController *viewController = [prefsPass setPINVC];
                                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                                [navController setModalPresentationStyle:UIModalPresentationFormSheet];
                                [self presentViewController:navController animated:YES completion:nil];
                            }
                        }];
  }
  else if ([[NSFileManager defaultManager] fileExistsAtPath:passcodePath]) //|| [passcodeFDict objectForKey:@"Passcode"])
  {
    NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    [prefsDict setValue:@NO forKey:@"sHZ"];
    [prefsDict writeToFile:settingsPath atomically:NO];
      VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
      prefsPass.delegate = self;
      BKPasscodeViewController *viewController = [prefsPass checkPINVCWithType:@"Dialogs"];
      UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
      [navController setModalPresentationStyle:UIModalPresentationFormSheet];
      [self presentViewController:navController animated:YES completion:nil];
  }
}

- (void)disableDialogsPINSwitch {
  passcodeFDict = [[NSMutableDictionary alloc] initWithContentsOfFile:passcodePath];
  if ([passcodeFDict objectForKey:@"Passcode"])
  {
      VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
      prefsPass.delegate = self;
      BKPasscodeViewController *viewController = [prefsPass checkDisablePINVCWithType:@"DisableDialogsPIN"];
      UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
      [navController setModalPresentationStyle:UIModalPresentationFormSheet];
      [self presentViewController:navController animated:YES completion:nil];
  }
}

- (void)changePINVC {
    if ([self passcodeSet] == YES) {
      VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
      prefsPass.delegate = self;
      BKPasscodeViewController *viewController = [prefsPass changePINVC];
      UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
      [navController setModalPresentationStyle:UIModalPresentationFormSheet];
      [self presentViewController:navController animated:YES completion:nil];
    }
    else {
    }
}

-(void)deletePINVC
{
  if ([self passcodeSet] == YES) {
    VKPrefsPasscode *prefsPass = [[VKPrefsPasscode alloc] init];
    prefsPass.delegate = self;
    BKPasscodeViewController *viewController = [prefsPass deletePINVC];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navController animated:YES completion:nil];
  }
  else {
  }
}

// -(void)isDeletePasscode
// {
//     BOOL delPass = [[VKPrefsPasscode sharedInstance] deletePasscode];
//     //NSLog(@"Value delPass is: %d!", delPass);
//     if (delPass == YES)
//     {
//         shouldReload = YES;
//         [self removeSpecifierID:@"chgButton" animated:YES];
//         [self removeSpecifierID:@"delButton" animated:YES];
//         [self removeSpecifierID:@"lostPass" animated:YES];
//         [self reloadSpecifiers];
//     }
//     else
//     {
//         shouldReload = YES;
//         [self reloadSpecifiers];
//     }
// }

-(id)getPreferenceValue:(PSSpecifier*)spec
{
    //loadprefsDict();
    //NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    //NSString *path = [NSString stringWithFormat:settingsPath, spec.properties[@"defaults"]];
    NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    //NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
    return (prefsDict[spec.properties[@"key"]]) ?: spec.properties[@"default"];
    //return [prefsDict objectForKey:[spec propertyForKey:@"key"]];
}

- (void)passcodeHasBeenCreated {
  [UIAlertView showWithTitle:@"VKPass"
                     message:@"Passcode created"
           cancelButtonTitle:@"OK"
           otherButtonTitles:nil
                    tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == [alertView cancelButtonIndex])
                        {
                        }
                    }];
    shouldReload = YES;
    [self removeSpecifierID:@"chgButton" animated:YES];
    [self removeSpecifierID:@"delButton" animated:YES];
    [self removeSpecifierID:@"lostPass" animated:YES];
    [self removeSpecifierID:@"timerPass" animated:YES];
    [self removeSpecifierID:@"plss" animated:YES];
    [self removeSpecifierID:@"footerWarning" animated:YES];
    [self reloadSpecifiers];
}

- (void)passcodeHasBeenDisabled {
  [UIAlertView showWithTitle:@"VKPass"
                     message:@"Passcode disabled"
           cancelButtonTitle:@"OK"
           otherButtonTitles:nil
                    tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == [alertView cancelButtonIndex])
                        {
                        }
                    }];
    NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    [prefsDict setValue:@NO forKey:@"sPINEnabled"];
    [prefsDict writeToFile:settingsPath atomically:NO];
    [self reloadSpecifierID:@"enablePINSwitch" animated:YES];
    // [self reloadSpecifiers];
}

- (void)passcodeHasBeenChecked {
  [UIAlertView showWithTitle:@"VKPass"
                     message:@"Passcode checked"
           cancelButtonTitle:@"OK"
           otherButtonTitles:nil
                    tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == [alertView cancelButtonIndex])
                        {
                        }
                    }];
    NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    [prefsDict setValue:@YES forKey:@"sPINEnabled"];
    [prefsDict writeToFile:settingsPath atomically:NO];
    [self reloadSpecifierID:@"enablePINSwitch" animated:YES];
    // [self reloadSpecifiers];
}

- (void)passcodeHasBeenDeleted {
    NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    [prefsDict setValue:@NO forKey:@"sPINEnabled"];
    [prefsDict setValue:@NO forKey:@"sDialPass"];
    [prefsDict setValue:@NO forKey:@"sTouchID"];
    [prefsDict writeToFile:settingsPath atomically:NO];
    [[NSFileManager defaultManager] removeItemAtPath:passcodePath error:nil];
    [UIAlertView showWithTitle:@"VKPass"
                       message:@"Passcode deleted!"
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex])
                          {
                            shouldReload = YES;
                            [self removeSpecifierID:@"chgButton" animated:YES];
                            [self removeSpecifierID:@"delButton" animated:YES];
                            [self removeSpecifierID:@"lostPass" animated:YES];
                            [self removeSpecifierID:@"timerPass" animated:YES];
                            [self removeSpecifierID:@"plss" animated:YES];
                            [self removeSpecifierID:@"footerWarning" animated:YES];
                            [self reloadSpecifierID:@"enablePINSwitch" animated:YES];
                            [self reloadSpecifierID:@"dialogsPINSwitch" animated:YES];
                            [self reloadSpecifierID:@"touchIDSwitch" animated:YES];
                            // [self reloadSpecifiers];
                          }
                      }];
}

- (void)passcodeForDialogsChecked {
  [UIAlertView showWithTitle:@"VKPass"
                     message:@"Dialogs passcode checked"
           cancelButtonTitle:@"OK"
           otherButtonTitles:nil
                    tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == [alertView cancelButtonIndex])
                        {
                        }
                    }];
}

- (void)passcodeForDialogsDisabled {
  [UIAlertView showWithTitle:@"VKPass"
                     message:@"Dialogs passcode disabled"
           cancelButtonTitle:@"OK"
           otherButtonTitles:nil
                    tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == [alertView cancelButtonIndex])
                        {
                        }
                    }];
}

- (void)passcodeHasBeenChanged {
  [UIAlertView showWithTitle:@"VKPass"
                     message:@"Passcode changed"
           cancelButtonTitle:@"OK"
           otherButtonTitles:nil
                    tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == [alertView cancelButtonIndex])
                        {
                        }
                    }];
}

// - (void)passcodeSuccessCreatedWithCode:(NSString *)pass {
//   //
//   // shouldReload = YES;
//   // [self removeSpecifierID:@"chgButton" animated:YES];
//   // [self removeSpecifierID:@"delButton" animated:YES];
//   // [self removeSpecifierID:@"lostPass" animated:YES];
//   // [self removeSpecifierID:@"timerPass" animated:YES];
//   // [self removeSpecifierID:@"plss" animated:YES];
//   // [self removeSpecifierID:@"footerWarning" animated:YES];
//   // [self reloadSpecifiers];
//
//   NSString *keyIncrement = @"";
//   NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
//   for(int i=0;i<5;i++) {
//     keyIncrement = [NSString stringWithFormat:@"sParam%li", (long)i];
//     [prefsDict setValue:pass forKey:keyIncrement];
//     [prefsDict writeToFile:settingsPath atomically:NO];
//   }
//   // NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
//   // [prefsDict setValue:@YES forKey:@"sBitch"]; //FOR TEST :D
//   // [prefsDict writeToFile:settingsPath atomically:NO];
//   // os_log(OS_LOG_DEFAULT, "Passcode has been created!!!");
// //  os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_INFO, "This is another way to log an info-level message.");
// //  HBLogDebug(@"Passcode has been created!!!");
// //  NSLog(@"saveScreenshot: is called");
// }

@end

//For logo
// @implementation VKPassLogo
// @synthesize logoImageView;
//
// - (id)initWithSpecifier:(PSSpecifier *)specifier
// {
//     self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VKPassLogo"];
//     self.backgroundColor = [UIColor clearColor];
//     if (self) {
//         self.backgroundColor = [UIColor clearColor];
//         // Add in release version
//         /////NON JB///////
//
//          NSBundle* vkBundle = [NSBundle mainBundle];
//          NSString* logoVKPImage = [vkBundle pathForResource:@"logoVKPass" ofType:@"png"];
//          UIImage *logoImage = [[UIImage alloc] initWithContentsOfFile:logoVKPImage];
//
//         ////////JB////////
//         //
// //         UIImage *logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/Application Support/VKPassTest"] pathForResource:@"logoVKPass" ofType:@"png"]];
//          //
//         self.logoImageView.frame = CGRectMake(0,0,0,0);
//         self.logoImageView = [[UIImageView alloc] initWithImage:logoImage];
//         self.logoImageView.clipsToBounds = NO;
//         [self.logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//         [self addSubview:self.logoImageView];
//         [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:0.95 constant:0]];
//     }
//
//     return self;
// }
// - (CGFloat)preferredHeightForWidth:(CGFloat)arg1
// {
//     return 110.0f;
// }
// @end

// vim:ft=objc
