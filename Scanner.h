
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface Scanner : NSObject
{

  CGFloat w, h;
  void *textureAddress;
  NSBitmapImageRep *bitmap;
  NSSize imageSize;
  NSImage *image;
  NSTimeInterval time;
  NSOpenGLContext *context;
  QTMovie *movie;

}

- (id) initWithMovie: (QTMovie *) mov;
- (void) dealloc;
- (void) initialize;
- (void) scan;
- (void) createOpenGLContext;
- (void) getScreenTexture;
- (void) getImageFromMemory;
- (void) createImageFromBitmap;
- (void) appendToMovie;

@end

