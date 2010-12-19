
#import "Video.h"
#import "Scanner.h"
#import "Global.h"

CVReturn displayCallback(
   CVDisplayLinkRef displayLink,
   const CVTimeStamp *inNow,
   const CVTimeStamp *inOutputTime,
   CVOptionFlags flagsIn,
   CVOptionFlags *flagsOut,
   void *displayLinkContext  // self
   )
{

  [(Video *) displayLinkContext displayCallbackMethod: displayLinkContext];

  return kCVReturnSuccess;
}

@implementation Video

- (id) init
{

  self = [super init];

  if(self) {

    [self initialize];

  }

  return self;

}

- (void) dealloc
{
  [path release];
  [movie release];

  [super dealloc];

}

- (void) start
{
  [self createDisplayLink];
}

- (void) stop
{

  [self deleteDisplayLink];

}

- (QTMovie *) movie
{

  return movie;

}

- (void) cleanUp
{

  // [movie invalidate];
  // [movie release];

  NSError *err;
  err = NULL;

  [[NSFileManager defaultManager] removeItemAtPath: path error: &err];
  if(err) NSLog(@"movie file delete error: %@", err);

  // NSLog(@"video cleanup done.");
}

// private methods

- (void) initialize
{

    // movie creation
//    movie = [[QTMovie movie] retain];  // this does not work.
    path = [NSTemporaryDirectory()
              stringByAppendingPathComponent: @"video.mov"];
    [path retain];
    movie = [[QTMovie alloc]
                initToWritableFile: path error: NULL];
    [movie setAttribute: [NSNumber numberWithBool: YES]
           forKey: QTMovieEditableAttribute];

}

- (void) createDisplayLink
{

  prevTime = [NSDate timeIntervalSinceReferenceDate];
  count = 0;

  // Is ...WithActiveCGDisplays version better to use here?
  // CVDisplayLinkCreateWithCGDisplay( CGMainDisplayID(), &linkRef );
  // kCGDirectMainDisplay == CGMainDisplayID()
  CVDisplayLinkCreateWithActiveCGDisplays( &linkRef );

  CVDisplayLinkSetOutputCallback( linkRef, &displayCallback, self);
  CVDisplayLinkStart( linkRef );

}

- (void) deleteDisplayLink
{
  CVDisplayLinkStop( linkRef );
  CVDisplayLinkRelease( linkRef );
}

- (void) displayCallbackMethod: (void *) displayLinkContext
{
  double fps;

  fps = [Global sharedInstance]->fps;

  NSTimeInterval interval = 1.0 / fps;

  Video *video = (Video *)displayLinkContext;
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  NSTimeInterval diff = now - video->prevTime;

  if(diff > interval) {
    video->prevTime = [NSDate timeIntervalSinceReferenceDate];

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Scanner *scanner;
    scanner = [[Scanner alloc] initWithMovie: [video movie] ];
    [scanner scan];
    [scanner release];
    [pool release];
  }

}
- (void) displayCallbackMethodForTest: (void *) displayLinkContext
{

  double fps;

  fps = [Global sharedInstance]->fps;

  NSTimeInterval interval = 1.0 / fps;

  Video *video = (Video *)displayLinkContext;
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  NSTimeInterval diff = now - video->prevTime;

  if(diff > interval) {
    video->prevTime = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"count: %d", video->count);
    video->count = 0;
  } else {
    video->count++;
  }

}

@end

