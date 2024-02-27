import { useEffect, useState } from "react";
import LineGraph from "./LineGraph";
import TrafficAnalyser from "./TrafficAnalyser";
import { useSession } from "next-auth/react";
import Image from 'next/image'
import PigIcon from '@/components/pig.svg'

export default function SupplierSemRushTraffic({supplier, adhoc = false}) {
    
    const [trafficDataPoints, setTrafficDataPoints] = useState([]);
    const [spamScore, setSpamScore] = useState();
    const { data: session } = useSession();


    useEffect(() => {

        if(!session) { return; }
        
        var url;

        if(adhoc) {
            url = "/.rest/semrush/lookup?domain="+supplier.domain;
    ***REMOVED***
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
    ***REMOVED***

        fetch(url, {headers: {
            'user': session.user.email}
    ***REMOVED***)
        .then( (resp) => {
            if(resp.ok) {
                resp.json().then( (data) => {
                    if(adhoc) {
                        data = data.map(d => ({   
                            date: d.date, 
                            traffic: d.organicTraffic, 
                            srrank: d.rank, 
                            yearMonth: new Date(d.date).toISOString().substring(0,7)})).reverse()
                ***REMOVED***
                    if(! adhoc & data.length > 0) {
                        setSpamScore(data[data.length-1].spamScore)
                ***REMOVED***
                    // need to trim off the last data point as we have 13 months of data, because of the hack above
                    setTrafficDataPoints(data.slice(0, data.length-1))
            ***REMOVED***)
        ***REMOVED***
            else {
                console.log("Unknown error: "+resp.status)
        ***REMOVED***
    ***REMOVED***)

***REMOVED***, [session, supplier]);
    
    return (
        <div>
        {trafficDataPoints ?
            <>
            <LineGraph datapoints={trafficDataPoints}/>
            <TrafficAnalyser datapoints={trafficDataPoints}/>
            {adhoc || spamScore < 1 ? 
                null
            : 
                <div>
                <Image src={PigIcon} width={40} className="float-left" alt="spam score"/>
                <p className={spamScore > 9 ? "in-pig-dd": "in-pig-sd"}>{spamScore}</p>
                </div>
        ***REMOVED***
            
            </>
        :
            null
    ***REMOVED***
        </div>
    )
}

