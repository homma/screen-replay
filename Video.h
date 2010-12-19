
#import <Quartz/Quartz.h>

@interface Video : NSObject
{
  CVDisplayLinkRef linkRef;
  NSString *path;
  QTMovie *movie;
  NSTimeInterval prevTime;  // previous time
  int count;
}

- (id) init;
- (void) dealloc;
- (void) start;
- (void) stop;
- (QTMovie *) movie;
- (void) initialize;
- (void) cleanUp;
- (void) createDisplayLink;
- (void) deleteDisplayLink;
- (void) displayCallbackMethod: (void *) displayLinkContext;
- (void) displayCallbackMethodForTest: (void *) displayLinkContext;

@end

