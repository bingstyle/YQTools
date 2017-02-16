//
//  UIControl+Sound_yq.m
//  YQToolsDemo
//
//  Created by weixb on 2017/2/16.
//  Copyright © 2017年 weixb. All rights reserved.
//

#import "UIControl+Sound_yq.h"
#import <objc/runtime.h>

// Key for the dictionary of sounds for control events.
static char const * const yq_kSoundsKey = "yq_kSoundsKey";

@implementation UIControl (Sound_yq)

- (void)yq_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent
{
    // Remove the old UI sound.
    NSString *oldSoundKey = [NSString stringWithFormat:@"%ld", (long)controlEvent];
    AVAudioPlayer *oldSound = [self yq_sounds][oldSoundKey];
    [self removeTarget:oldSound action:@selector(play) forControlEvents:controlEvent];
    
    // Set appropriate category for UI sounds.
    // Do not mute other playing audio.
    [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryAmbient" error:nil];
    
    // Find the sound file.
    NSString *file = [name stringByDeletingPathExtension];
    NSString *extension = [name pathExtension];
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:file withExtension:extension];
    
    NSError *error = nil;
    
    // Create and prepare the sound.
    AVAudioPlayer *tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    NSString *controlEventKey = [NSString stringWithFormat:@"%ld", (long)controlEvent];
    NSMutableDictionary *sounds = [self yq_sounds];
    [sounds setObject:tapSound forKey:controlEventKey];
    [tapSound prepareToPlay];
    if (!tapSound) {
        NSLog(@"Couldn't add sound - error: %@", error);
        return;
    }
    
    // Play the sound for the control event.
    [self addTarget:tapSound action:@selector(play) forControlEvents:controlEvent];
}


#pragma mark - Associated objects setters/getters

- (void)setyq_sounds:(NSMutableDictionary *)sounds
{
    objc_setAssociatedObject(self, yq_kSoundsKey, sounds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)yq_sounds
{
    NSMutableDictionary *sounds = objc_getAssociatedObject(self, yq_kSoundsKey);
    
    // If sounds is not yet created, create it.
    if (!sounds) {
        sounds = [[NSMutableDictionary alloc] initWithCapacity:2];
        // Save it for later.
        [self setyq_sounds:sounds];
    }
    
    return sounds;
}

@end
