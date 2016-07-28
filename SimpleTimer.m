//
//  Created by Alexander Stepanov on 28/07/16.
//  Copyright © 2016 Alexander Stepanov. All rights reserved.
//

#import "SimpleTimer.h"
#import <objc/runtime.h>


static id _simpleTimer_tmp;

static const void *TrackersKey = &TrackersKey;


@interface SimpleTimerTarget : NSObject
@property (nonatomic, copy) void(^block)();
@end

@implementation SimpleTimerTarget
-(void)onTick:(NSTimer*)timer {
    self.block();
}
@end


@interface SimpleTimerTracker : NSObject
{
@public
    NSTimer* __weak timer;
    NSString* key;
}
@end

@implementation SimpleTimerTracker

-(void)dealloc {
    [timer invalidate];
}

@end


@implementation NSObject (SimpleTimer)

-(void)_simpleTimer_stop:(NSString *)key
{
    if (key.length == 0) return;
    
    NSMutableSet* trackers = objc_getAssociatedObject(self, TrackersKey);
    SimpleTimerTracker* trackerToRemove = nil;
    for (SimpleTimerTracker* tracker in trackers) {
        if ([tracker->key isEqualToString:key]){
            trackerToRemove = tracker;
            break;
        }
    }
    if (trackerToRemove != nil) {
        [trackers removeObject:trackerToRemove];
    }
}

-(void)_simpleTimer_stopAll
{
    NSMutableSet* trackers = objc_getAssociatedObject(self, TrackersKey);
    [trackers removeAllObjects];
}

-(void)_simpleTimer_startWithTimeInterval:(NSTimeInterval)tm repeats:(BOOL)repeats key:(NSString *)key
{
    _simpleTimer_tmp = [^(id block) {
        
        SimpleTimerTarget* tgt = [SimpleTimerTarget new];
        id __unsafe_unretained owner = self;
        tgt.block = ^{ ((void(^)(id))block)(owner); };
        
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:tm target:tgt selector:@selector(onTick:) userInfo:nil repeats:repeats];
        
        NSMutableSet* trackers = objc_getAssociatedObject(self, TrackersKey);
        if (trackers == nil){
            trackers = [NSMutableSet set];
            objc_setAssociatedObject(self, TrackersKey, trackers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        SimpleTimerTracker* tracker = nil;
        if (key.length > 0) {
            for (SimpleTimerTracker* tr in trackers) {
                if ([tr->key isEqualToString:key]){
                    tracker = tr;
                    [tracker->timer invalidate];
                    break;
                }
            }
        }
        
        if (tracker == nil) {
            tracker = [SimpleTimerTracker new];
            tracker->key = [key copy];
        }
        
        tracker->timer = timer;
        
        [trackers addObject:tracker];
        
    } copy];
}

-(void)set_simpleTimer_block:(id)block
{
    assert(block != nil);
    
    void(^block1)(id) = _simpleTimer_tmp;
    _simpleTimer_tmp = nil;
    block1(block);
}

@end
