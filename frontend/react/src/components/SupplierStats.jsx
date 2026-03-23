import LineGraph from "./LineGraph";
import TrafficAnalyser from "./TrafficAnalyser";
import { useAuth } from "@/auth/AuthProvider";
import PigIcon from '@/assets/pig.svg'
import { useEffect, useState, useRef } from "react";
import { fetchWithAuth } from "@/utils/fetchWithAuth";

function formatTraffic(n) {
    if (!n) return '—';
    if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M';
    if (n >= 1_000) return (n / 1_000).toFixed(1) + 'k';
    return String(n);
}

export default function SupplierSemRushTraffic({supplier, adhoc = false, dataListener = null, showTrafficAnalysis = true, showSpamScore = true, compact = false}) {
    const [trafficDataPoints, setTrafficDataPoints] = useState([]);
    const [spamScore, setSpamScore] = useState();
    const { user } = useAuth();
    const containerRef = useRef(null);
    const [isVisible, setIsVisible] = useState(false);

    useEffect(() => {
        const observer = new window.IntersectionObserver(
            ([entry]) => setIsVisible(entry.isIntersecting),
            { threshold: 0.1 }
        );
        if (containerRef.current) {
            observer.observe(containerRef.current);
        }
        return () => {
            if (containerRef.current) {
                observer.unobserve(containerRef.current);
            }
        };
    }, []);

    useEffect(() => {
        if (isVisible) {
            getTrafficData();
        }
        // eslint-disable-next-line
    }, [user, supplier, isVisible]);

    function getTrafficData() {
        if(!user) { return; }
        
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
            const endDate = lastDayOfLastMonth.toISOString().substring(0,10);
            url = "/.rest/stats/fordomain?"
                        +"domain="+supplier.domain
                        +"&startDate="+startDate
                        +"&endDate="+endDate
        }

        fetchWithAuth(url, {headers: {
            'user': user.email}
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
                    if(! adhoc & data.length > 0) {
                        setSpamScore(data[data.length-1].spamScore)
                    }
                    setTrafficDataPoints(data)
                    if(dataListener) {
                        dataListener(data)
                    }
                })
            }
            else {
                console.log("Unknown error: "+resp.status)
            }
        })
    }

    if (compact) {
        const latest = trafficDataPoints.length > 0 ? trafficDataPoints[trafficDataPoints.length - 1] : null;
        const prev   = trafficDataPoints.length > 1 ? trafficDataPoints[trafficDataPoints.length - 2] : null;
        const trending = prev && latest ? (latest.traffic > prev.traffic ? 'up' : latest.traffic < prev.traffic ? 'down' : 'flat') : null;
        return (
            <div ref={containerRef} className="flex items-center gap-1.5">
                {latest ? (
                    <>
                        {trending === 'up'   && <span className="text-green-500 text-xs font-bold">↑</span>}
                        {trending === 'down' && <span className="text-red-400 text-xs font-bold">↓</span>}
                        <span className="text-sm font-semibold text-gray-800">{formatTraffic(latest.traffic)}</span>
                        <span className="text-xs text-gray-400">/mo</span>
                        {showSpamScore && !adhoc && spamScore > 0 &&
                            <span className={`text-xs font-medium px-1.5 py-0.5 rounded-full ${spamScore > 9 ? 'bg-red-50 text-red-600' : 'bg-gray-100 text-gray-500'}`}>
                                {spamScore}% spam
                            </span>
                        }
                    </>
                ) : (
                    <span className="text-xs text-gray-400">—</span>
                )}
            </div>
        );
    }

    return (
        <div ref={containerRef}>
        {trafficDataPoints ?
            <>
            <LineGraph datapoints={trafficDataPoints}/>
            {showTrafficAnalysis ?
                <TrafficAnalyser datapoints={trafficDataPoints}/>
            : 
                null
            }
            
            {!showSpamScore || adhoc || spamScore < 1 ? 
                null
            : 
                <div>
                <img src={PigIcon} width={40} className="float-left" alt="spam score"/>
                <p className={spamScore > 9 ? "in-pig-dd": "in-pig-sd"}>{spamScore}</p>
                </div>
            }
            
            </>
        :
            null
        }
        </div>
    )
}

