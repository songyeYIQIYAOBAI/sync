//
//  WaveNode.m
//
//  Created by lvming on 12-12-27.
//  Copyright (c) 2012年 lvming. All rights reserved.
//

#import "cocos2d.h"
#import "WaveNode.h"

#define DIFFUSION 0.8
#define DAMPING 0.99
#define COUNT 120

@implementation WaveNode

@synthesize width;
@synthesize depth;

@synthesize waterColorRed;
@synthesize waterColorGreen;
@synthesize waterColorBlue;
@synthesize waterAlpha;

- (id)init {
	if (self = [super init]) {
		_h1 = calloc(COUNT, sizeof(float));
		_h2 = calloc(COUNT, sizeof(float));
		
		width = 0;
		depth = 0;
        
        waterColorRed = 127.0f / 255.0f;
        waterColorGreen = 186.0f / 255.0f;
        waterColorBlue = 23.0f / 255.0f;
        waterAlpha = 1.0f;
	}
	
	return self;
}

- (void)dealloc {
	free(_h1);
	free(_h2);
	
	[super dealloc];
}

- (void)onExit {
	[self cleanup];
	
	[super onExit];
}

- (void)vertlet {
	for (int i=0; i<COUNT; i++) {
		_h1[i] = 2.0 * _h2[i] - _h1[i];
	}
	
	float* temp = _h2;
	_h2 = _h1;
	_h1 = temp;
}

static inline float
diffuse(float diff, float damp, float prev, float curr, float next){
	return (curr * diff + ((prev + next) * 0.5f) * (1.0f - diff)) * damp;
}

- (void)diffuse {
	float prev = _h2[0];
	float curr = _h2[0];
	float next = _h2[1];
	
	_h2[0] = diffuse(DIFFUSION, DAMPING, prev, curr, next);
	
	for(int i=1; i<(COUNT - 1); ++i){
		prev = curr;
		curr = next;
		next = _h2[i + 1];
		
		_h2[i] = diffuse(DIFFUSION, DAMPING, prev, curr, next);
	}
	
	prev = curr;
	curr = next;
	_h2[COUNT - 1] = diffuse(DIFFUSION, DAMPING, prev, curr, next);
}

- (float)dx {
	return width / (GLfloat)(COUNT - 1);
}

- (void)draw {
	// It would be better to run these on a fixed timestep.
	// As an GFX only effect it doesn't really matter though.
	[self vertlet];
	[self diffuse];
	
	GLfloat dx = [self dx];
	GLfloat top = depth;
	
	// Build a vertex array and render it.
	struct Vertex {GLfloat x,y;};
	struct Vertex verts[COUNT*2];
	for(int i=0; i<COUNT; i++){
		GLfloat x = i * dx;
		verts[2 * i + 0] = (struct Vertex){x, 0};
		verts[2 * i + 1] = (struct Vertex){x, top + _h2[i]};
	}
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glDisable(GL_TEXTURE_2D);
	
	GLfloat r = waterColorRed;
	GLfloat g = waterColorGreen;
	GLfloat b = waterColorBlue;
	GLfloat a = waterAlpha;
	glColor4f(r * a, g * a, b * a, a);
	
	glVertexPointer(2, GL_FLOAT, 0, verts);
	
	glPushMatrix(); {
		glScalef(CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR(), 1.0);
		glTranslatef(0.0, 0.0, 0.0);
		
		glDrawArrays(GL_TRIANGLE_STRIP, 0, COUNT * 2);
	} glPopMatrix();
	
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}

- (void)makeSplashAt:(float)x withAmplitude:(float)amplitude {
	// Changing the values of heightfield in h2 will make the waves move.
	// Here I only change one column, but you get the idea.
	// Change a bunch of the heights using a nice smoothing function for a better effect.
	
	int index = MAX(0, MIN((int)(x/[self dx]), COUNT - 1));
	_h2[index] += CCRANDOM_MINUS1_1() * amplitude;
}

@end
