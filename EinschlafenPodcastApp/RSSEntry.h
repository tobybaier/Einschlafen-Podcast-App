#import <Foundation/Foundation.h>

@interface RSSEntry : NSObject {
    NSString *_blogTitle;
    NSString *_articleTitle;
    NSString *_articleUrl;
    NSDate *_articleDate;
}

@property (copy) NSString *blogTitle;
@property (copy) NSString *articleTitle;
@property (copy) NSString *articleUrl;
@property (copy) NSString *length;
@property (copy) NSString *enclosureUrl;
@property (copy) NSDate *articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl length:(NSString*)length enclosureUrl:(NSString*)enclosureUrl articleDate:(NSDate*)articleDate;

@end