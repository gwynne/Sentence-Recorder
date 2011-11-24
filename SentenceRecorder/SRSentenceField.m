//
//  SRSentenceField.m
//  SentenceRecorder
//
//  Created by Gwynne on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SRSentenceField.h"

@implementation SRSentenceField
{
	BOOL	isDown;
}

@synthesize delegate;

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
	if ([[theEvent characters] isEqualToString:@" "])
	{
		if (!isDown)
			[self.delegate didPressSpace];
		isDown = YES;
	}
	else
		[super keyDown:theEvent];
}

- (void)keyUp:(NSEvent *)theEvent
{
	if ([[theEvent characters] isEqualToString:@" "])
	{
		if (isDown)
			[self.delegate didReleaseSpace];
		isDown = NO;
	}
	else
		[super keyUp:theEvent];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
	if ([[self window] firstResponder] == self)
	{
		NSSetFocusRingStyle(NSFocusRingOnly);
		NSRectFill([self bounds]);
	}
}

@end

@implementation SRSentenceCell

- (BOOL)showsFirstResponder
{
	return YES;
}

- (BOOL)refusesFirstResponder
{
	return NO;
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (NSFocusRingType)focusRingType
{
	return NSFocusRingTypeExterior;
}

@end
