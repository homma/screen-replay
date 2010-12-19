
// called when application starts
@interface MyDelegation : NSObject

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void) applicationWillTerminate:(NSNotification *)aNotification;

@end

