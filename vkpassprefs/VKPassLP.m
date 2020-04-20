#import "VKPassLP.h"

@implementation VKPassLP

+(VKPassLP *) sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&p, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(int)noLostPass
{
    return self.z = 0;
}

-(int)lostPass
{
    return self.z = 1;
}
-(int)authSecret
{
    return self.z = 2;
}
@end
