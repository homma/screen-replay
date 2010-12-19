
#import <Quartz/Quartz.h>
#import "Scanner.h"
#import "Audio.h"
#import "Video.h"

@interface Recorder : NSObject
{
  CVDisplayLinkRef linkRef;
  BOOL isRecording;  // flag: is the recording in progress?
  Audio *audio;
  Video *video;

}

- (id) init;
- (void) dealloc;
- (void) start;
- (void) stop;

@end

@interface Recorder (Private)

- (void) initialize;
- (void) mergeAudioAndVideo;
- (NSString *) createMoviePath;
- (void) save;

@end

