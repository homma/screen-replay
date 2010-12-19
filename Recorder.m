
#import <Cocoa/Cocoa.h>
#import "Recorder.h"
#import "Global.h"
#import "Audio.h"

@implementation Recorder

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
  [video release];
  [audio release];

  [super dealloc];

}

- (void) start
{

  if(isRecording) return;    // do nothing if the recording is in progress.

  [video start];
  [audio start];

  isRecording = YES;

}

- (void) stop
{

  if(!isRecording) return;    // do nothing if the recording is not in progress.

  isRecording = NO;

  [video stop];
  [audio stop];

  [self mergeAudioAndVideo];
  [self save];

  [audio cleanUp];
  [video cleanUp];

}

@end

@implementation Recorder (Private)

- (void) initialize
{

  isRecording = NO;

  video = [[Video alloc] init];
  audio = [[Audio alloc] init];
}

- (void) mergeAudioAndVideo
{

  QTMovie *videoMovie;
  QTMovie *audioMovie;
  QTTrack *audioTrack;
  QTTimeRange videoRange;
  QTTimeRange audioRange;
  NSError *err;
  NSString *audioPath;

  err = NULL;

  audioPath = [audio audioPath];

  videoMovie = [video movie];
  audioMovie = [[QTMovie alloc]
                initWithFile: audioPath error: &err];
  if(err) {
    NSLog(@"audio merge error : %@", err);
    NSLog(@"audio path : %@", audioPath);
    err = NULL;
  }

  audioTrack = [[audioMovie tracks] objectAtIndex: 0];
  [audioTrack setVolume: 1.0];

  audioRange.time = QTZeroTime;
  audioRange.duration = [audioMovie duration];

  [videoMovie insertSegmentOfTrack: audioTrack
          timeRange: audioRange
          atTime: QTZeroTime];

  [videoMovie updateMovieFile];
  [audioMovie release];

}

// create a path of final movie output
- (NSString *) createMoviePath
{
  NSString *movieDir;
  NSString *fileName;
  NSString *extension;
  NSString *pathTemp;
  NSString *path;

  movieDir = [NSSearchPathForDirectoriesInDomains(NSMoviesDirectory,
                NSUserDomainMask, YES) objectAtIndex: 0];
  fileName = @"Screen Movie";
  extension = @".mp4";

  pathTemp = [movieDir stringByAppendingPathComponent: fileName];
  pathTemp = [pathTemp stringByAppendingString: extension];

  if( [[NSFileManager defaultManager] fileExistsAtPath: pathTemp ] ) {
    // continue
    pathTemp = nil;
  } else {
    path = pathTemp;
    return path;
  }

  int i;
  for(i = 1;;i++) {

    pathTemp = [movieDir stringByAppendingPathComponent: fileName];
    pathTemp = [pathTemp stringByAppendingFormat: @" %d", i];
    pathTemp = [pathTemp stringByAppendingString: extension];

    if([[NSFileManager defaultManager] fileExistsAtPath: pathTemp]) {
      continue;
    } else {
      path = pathTemp;
      break;
    }

  }

  return path;

}

- (void) save
{

  QTMovie *movie;
  NSDictionary *attr;
  NSError *err;
  NSString *moviePath;

  movie = [video movie];
  attr = NULL;
  err = NULL;

  // /System/Library/Frameworks/QTKit.framework/Headers/QTKitDefines.h
  // kQTFileType3GPP, etc. ...
  attr = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool: YES], QTMovieExport,
            [NSNumber numberWithLong: kQTFileTypeMP4], QTMovieExportType,
            [NSNumber numberWithBool: YES], QTMovieFlatten,
            nil];

  // Video Output
  moviePath = [self createMoviePath];  // will not retain here
  [movie writeToFile: moviePath
         withAttributes: attr
         error: &err];

}

@end

