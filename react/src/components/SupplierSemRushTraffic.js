import { useEffect, useState } from "react";
import LineGraph from "./LineGraph";
import TrafficAnalyser from "./TrafficAnalyser";
import { useSession } from "next-auth/react";

export default function SupplierSemRushTraffic({supplier, adhoc = false}) {
    
    const [trafficDataPoints, setTrafficDataPoints] = useState([]);
    const { data: session } = useSession();


    useEffect(() => {

        if(!session) { return; }
        
        var url;

        if(adhoc) {
            url = "/.rest/semrush/lookup?domain="+supplier.domain;
        }
        else {
            const startDate = new Date(new Date().setFullYear(new Date().getFullYear() - 1)).toISOString().substring(0,10);
            const endDate = new Date().toISOString().substring(0,10);
            url = "/.rest/stats/search/findByDomainInTimeRange?"
                        +"domain="+supplier.domain
                        +"&startDate="+startDate
                        +"&endDate="+endDate
        }

        const fetchData = async () => {
            const response = await fetch(url, {headers: {'user': session.user.email}});
            var data = await response.json();
            if(adhoc) {
                data = data.map(d => ({date: d.date, traffic: d.organicTraffic, srrank: d.rank, uniqueYearMonth: new Date(d.date).toISOString().substring(0,7)}))
            }
            setTrafficDataPoints(data);
        };
        
        fetchData();

    }, [session]);
    
    return (
        <div>
        {trafficDataPoints ?
            <>
            <LineGraph datapoints={trafficDataPoints}/>
            <TrafficAnalyser datapoints={trafficDataPoints}/>
            </>
        :
            null
        }
        </div>
    )
}

