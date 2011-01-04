
#import "Scanner.h"
#import "Global.h"

@implementation Scanner

- (id) initWithMovie: (QTMovie *) mov
{

  self = [super init];

  if(self) {

    movie = mov;
    [self initialize];

  }

  return self;

}

- (void) dealloc
{
  [context release];
  free(textureAddress);

  [super dealloc];
}

- (void) initialize
{

  int width, height;

  width = [Global sharedInstance]->width;
  height = [Global sharedInstance]->height;
  imageSize = NSMakeSize(width, height);

}

- (void) scan
{

  CGRect scanRect;

  scanRect = CGDisplayBounds( CGMainDisplayID() );
  w = scanRect.size.width;
  h = scanRect.size.height;
  time = [NSDate timeIntervalSinceReferenceDate];

  [self createOpenGLContext];
  [self getScreenTexture];
  [self getImageFromMemory];
  [self createImageFromBitmap];
  [self appendToMovie];

}

// see "OpenGL Programming Guide for Mac OS X"
//       -- Drawing to the Full Screen
- (void) createOpenGLContext
{

  NSOpenGLPixelFormatAttribute attrs[] = {
    NSOpenGLPFAFullScreen,
    NSOpenGLPFAScreenMask,
    CGDisplayIDToOpenGLDisplayMask( CGMainDisplayID() ),
    0  // null termination
  };

  NSOpenGLPixelFormat *pixelFormat;
  pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes: attrs];

  context = [[NSOpenGLContext alloc] initWithFormat: pixelFormat
                                     shareContext: NULL];
  [pixelFormat release];

  [context setFullScreen];
  [context makeCurrentContext];

}

// see "OpenGL Programming Guide for Mac OS X"
//       -- Downloading Texture Data
- (void) getScreenTexture
{

  NSTimeInterval ival;
  uint texture;

  textureAddress = malloc(w * h * 4);  // 4 : RGBA

  glGenTextures(1, &texture);
  glBindTexture(GL_TEXTURE_RECTANGLE_ARB, texture);

  glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_STORAGE_HINT_APPLE,
                  GL_STORAGE_SHARED_APPLE);
  glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA, w, h, 0, GL_BGRA,
               GL_UNSIGNED_INT_8_8_8_8_REV, textureAddress);

  glCopyTexSubImage2D( GL_TEXTURE_RECTANGLE_ARB, 0, 0, 0, 0, 0, w, h);
  glFlush();

  // blocked here
  glGetTexImage( GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA,
                 GL_UNSIGNED_INT_8_8_8_8_REV, textureAddress);
  glFlush(); // necessary?

}

- (void) getImageFromMemory
{

  bitmap = [[NSBitmapImageRep alloc]
               initWithBitmapDataPlanes: (unsigned char **) &textureAddress
               pixelsWide: w
               pixelsHigh: h
               bitsPerSample: 8
               samplesPerPixel: 4
               hasAlpha: YES
               isPlanar: NO
               colorSpaceName: NSDeviceRGBColorSpace
               bitmapFormat: 0
               bytesPerRow: w * 4
               bitsPerPixel: 32 ];

}

- (void) createImageFromBitmap
{

  image = [[NSImage alloc] initWithSize: imageSize];
//  [image lockFocusFlipped: YES];

  [image lockFocus];
  NSAffineTransform *atran;

  [NSGraphicsContext saveGraphicsState];

  // flip upside down
  atran = [NSAffineTransform transform];
  [atran translateXBy: 0 yBy: imageSize.height];
  [atran scaleXBy: 1 yBy: -1];
  [atran set];

  [bitmap drawInRect: NSMakeRect(0, 0, imageSize.width, imageSize.height) ];

  [NSGraphicsContext restoreGraphicsState];

  [image unlockFocus];

  [bitmap release];

}

- (void) appendToMovie
{

  QTTime duration;
  NSDictionary *attr;
  double fps;

  fps = [Global sharedInstance]->fps;
  duration = QTMakeTime(600 / fps, 600);
  attr = NULL;

  attr = [NSDictionary dictionaryWithObjectsAndKeys:
            @"mp4v", QTAddImageCodecType,
            [NSNumber numberWithInt: codecNormalQuality],
            QTAddImageCodecQuality, nil];

  // choice of quality: in QTKitDefines.h
  // codecLosslessQuality, codecMaxQuality, codecMinQuality,
  // codecLowQuality, codecNormalQuality, codecHighQuality

  // raw w/o flatter => An ivalid track was found error

  NSArray *tracks;
  tracks = [movie tracks];
  if([tracks count]) {
    QTTrack *track;
    track = [tracks objectAtIndex: 0];
    @synchronized([Scanner class]) {
//      [ movie attachToCurrentThread ];
      [ track addImage: image forDuration: duration withAttributes: attr];
//      [ movie detachFromCurrentThread ];
    }
  } else {  // 1st time to add an image.
    @synchronized([Scanner class]) {
//      [ movie attachToCurrentThread ];
      [ movie addImage: image forDuration: duration withAttributes: attr];
//      [ movie detachFromCurrentThread ];
    }
  }

  [image release];

}

@end

