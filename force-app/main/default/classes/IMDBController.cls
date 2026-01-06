public with sharing class IMDBController {
    @AuraEnabled(cacheable=true)
    public static String getMovies(String searchText) {
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();

            //remote site settings need to be configured for this endpoint
            //req.setEndpoint('https://api.collectapi.com/imdb/imdbSearchByName?query=' + searchText);

            //Named credentials
            req.setEndpoint('callout:IMDB/imdb/imdbSearchByName?query=' + searchText);
            req.setMethod('GET');
            req.setTimeout(10000);
            //req.setHeader('authorization', 'apikey 5WXGEIxvQPgzXZYaOiLrR5:7gK25281XiLwlVYaXrrLoj');

            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                // Ensure JSON has success flag for LWC
                String responseBody = res.getBody();
                return responseBody;
            } else {
                // Return standardized JSON error for LWC
                String errorMessage = '{"success": false, "result": [], "message": "HTTP error: ' + String.valueOf(res.getStatusCode()) + ' - ' + String.escapeSingleQuotes(res.getStatus()) + '"}';
                return errorMessage;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
