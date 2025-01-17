//  MockRoutesMiddleware.swift

import Foundation

struct MockRoutesMiddleware: Middleware {
        
    let router: MockNIOHTTPRouter

    let responseFactory: ResponseFactory
    
    init(router: MockNIOHTTPRouter, responseFactory: ResponseFactory) {
        self.router = router
        self.responseFactory = responseFactory
    }
    
    func execute(withContext context: MiddlewareContext) {
        let requestBody = Data(context.requestContext.body)
        guard let handler = router.handlerForMethod(context.requestContext.method,
                                                    path: context.requestContext.path,
                                                    params: context.requestContext.params,
                                                    headers: context.requestContext.headers,
                                                    body: requestBody) else {
            context.notFoundHandler?(context.requestContext, context.responseContext)
            return context.next()
        }
        
        handler(context.requestContext, context.responseContext)
        context.next()
    }
}
