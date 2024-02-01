export default function TrafficAnalyser({datapoints}) {
    
    // rules
    // if latest traffic is 0, return 0
    // if average traffic in last 3 months > 50, return 5

    var rating;

    if(datapoints.length == 0) {
        rating = "NO DATA";
***REMOVED*** else {
        if(datapoints[datapoints.length-1].traffic < 3 || datapoints.length < 3) { // if the most recent datapoint is 0, or there are less than 3 datapoints
            rating = "BAD";
    ***REMOVED***
        else {
            var averageTraffic = 0;
            for(var i = datapoints.length-1; i > datapoints.length-4; i--) {
                averageTraffic += datapoints[i].traffic;
        ***REMOVED***
            averageTraffic = averageTraffic / 3;
            if(averageTraffic > 150) {
                rating = "GOOD";
        ***REMOVED*** 
            else if(averageTraffic > 35) {
                rating = "OK";
        ***REMOVED***
            else {
                rating = "BAD";
        ***REMOVED***
    ***REMOVED***
***REMOVED***
    
    return (
        <div>
            <h1>Traffic analysis: {rating}</h1>
        </div>
    )
}