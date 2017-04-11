//
//  AppDelegate.h
//  LVideo
//
//  Created by xiaojuan on 17/4/6.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

