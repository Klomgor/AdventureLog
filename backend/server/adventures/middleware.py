class AppVersionMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Process request (if needed)
        response = self.get_response(request)

        # Add custom header to response
        # Replace with your app version
        response['X-AdventureLog-Version'] = '1.0.0'

        return response

# make a middlewra that prints all of the request cookies
class PrintCookiesMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        print(request.COOKIES)
        response = self.get_response(request)
        return response