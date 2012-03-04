#import "RSSEntry.h"

@implementation RSSEntry
@synthesize blogTitle = _blogTitle;
@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;
@synthesize length = _length;
@synthesize enclosureUrl = _enclosureUrl;
@synthesize articleDate = _articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl length:(NSString*)length enclosureUrl:(NSString*)enclosureUrl articleDate:(NSDate*)articleDate 
{
    if ((self = [super init])) {
        _blogTitle = [blogTitle copy];
        _articleTitle = [articleTitle copy];
        _articleUrl = [articleUrl copy];
        _length = [length copy];
        _enclosureUrl = [enclosureUrl copy];
        _articleDate = [articleDate copy];
    }
    return self;
}

- (void)dealloc {
    [_blogTitle release];
    _blogTitle = nil;
    [_articleTitle release];
    _articleTitle = nil;
    [_articleUrl release];
    _articleUrl = nil;
    [_length release];
    _length = nil;
    [_enclosureUrl release];
    _enclosureUrl = nil;
    [_articleDate release];
    _articleDate = nil;
    [super dealloc];
}

@end