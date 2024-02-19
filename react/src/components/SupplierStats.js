import { useEffect, useState } from "react";
import LineGraph from "./LineGraph";
import TrafficAnalyser from "./TrafficAnalyser";
import { useSession } from "next-auth/react";

export default function SupplierSemRushTraffic({supplier, adhoc = false}) {
    
    const [trafficDataPoints, setTrafficDataPoints] = useState([]);
    const [spamScore, setSpamScore] = useState();
    const { data: session } = useSession();


    useEffect(() => {

        if(!session) { return; }
        
        var url;

        if(adhoc) {
            url = "/.rest/semrush/lookup?domain="+supplier.domain;
        }
        else {
            const lastDayOfLastMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 0);
            const year = lastDayOfLastMonth.getFullYear() -1
            const month = lastDayOfLastMonth.getMonth()
            const day = lastDayOfLastMonth.getDate()
            const startDate = new Date(year, month, day).toISOString().substring(0,10);
            // const endDate = lastDayOfLastMonth.toISOString().substring(0,10);
            const endDate = new Date().toISOString().substring(0,10); // temporarily use today as end date so that we get some spam data
            url = "/.rest/stats/fordomain?"
                        +"domain="+supplier.domain
                        +"&startDate="+startDate
                        +"&endDate="+endDate
        }

        fetch(url, {headers: {
            'user': session.user.email}
        })
        .then( (resp) => {
            if(resp.ok) {
                resp.json().then( (data) => {
                    if(adhoc) {
                        data = data.map(d => ({   
                            date: d.date, 
                            traffic: d.organicTraffic, 
                            srrank: d.rank, 
                            yearMonth: new Date(d.date).toISOString().substring(0,7)})).reverse()
                    }
                    if(! adhoc) setSpamScore(data[data.length-1].spamScore)
                    // need to trim off the last data point as we have 13 months of data, because of the hack above
                    setTrafficDataPoints(data.slice(0, data.length-1))
                })
            }
            else {
                console.log("Unknown error: "+resp.status)
            }
        })

    }, [session, supplier]);
    
    return (
        <div>
        {trafficDataPoints ?
            <>
            <LineGraph datapoints={trafficDataPoints}/>
            <TrafficAnalyser datapoints={trafficDataPoints}/>
            {adhoc ? 
                null
            : 
                <p>Spam: {spamScore}</p>
            }
            
            </>
        :
            null
        }
        </div>
    )
}

