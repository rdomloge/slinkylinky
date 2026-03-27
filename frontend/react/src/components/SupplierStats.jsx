import LineGraph from "./LineGraph";
import TrafficAnalyser from "./TrafficAnalyser";
import { useAuth } from "@/auth/AuthProvider";
import { useEffect, useState, useRef } from "react";
import { fetchWithAuth } from "@/utils/fetchWithAuth";

function formatTraffic(n) {
    if (!n) return '—';
    if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M';
    if (n >= 1_000) return (n / 1_000).toFixed(1) + 'k';
    return String(n);
}

export default function SupplierSemRushTraffic({ supplier, adhoc = false, dataListener = null, showTrafficAnalysis = true, showSpamScore = true, compact = false }) {
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
        if (containerRef.current) observer.observe(containerRef.current);
        return () => { if (containerRef.current) observer.unobserve(containerRef.current); };
    }, []);

    useEffect(() => {
        if (isVisible) getTrafficData();
        // eslint-disable-next-line
    }, [user, supplier, isVisible]);

    function getTrafficData() {
        if (!user) return;

        let url;
        if (adhoc) {
            url = "/.rest/semrush/lookup?domain=" + supplier.domain;
        } else {
            const lastDayOfLastMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 0);
            const year = lastDayOfLastMonth.getFullYear() - 1;
            const month = lastDayOfLastMonth.getMonth();
            const day = lastDayOfLastMonth.getDate();
            const startDate = new Date(year, month, day).toISOString().substring(0, 10);
            const endDate = lastDayOfLastMonth.toISOString().substring(0, 10);
            url = "/.rest/stats/fordomain?domain=" + supplier.domain + "&startDate=" + startDate + "&endDate=" + endDate;
        }

        fetchWithAuth(url, { headers: { 'user': user.email } })
            .then(resp => {
                if (!resp.ok) { console.log("Unknown error: " + resp.status); return; }
                resp.json().then(data => {
                    if (adhoc) {
                        data = data.map(d => ({
                            date: d.date,
                            traffic: d.organicTraffic,
                            srrank: d.rank,
                            yearMonth: new Date(d.date).toISOString().substring(0, 7),
                        })).reverse();
                    }
                    if (!adhoc && data.length > 0) setSpamScore(data[data.length - 1].spamScore);
                    setTrafficDataPoints(data);
                    if (dataListener) dataListener(data);
                });
            });
    }

    if (compact) {
        const latest = trafficDataPoints.length > 0 ? trafficDataPoints[trafficDataPoints.length - 1] : null;
        const prev   = trafficDataPoints.length > 1 ? trafficDataPoints[trafficDataPoints.length - 2] : null;
        const trending = prev && latest
            ? (latest.traffic > prev.traffic ? 'up' : latest.traffic < prev.traffic ? 'down' : 'flat')
            : null;

        return (
            <div ref={containerRef} className="flex items-center gap-1.5">
                {latest ? (
                    <>
                        {trending === 'up'   && <span className="text-emerald-500 text-xs font-bold">↑</span>}
                        {trending === 'down' && <span className="text-red-400 text-xs font-bold">↓</span>}
                        <span className="text-sm font-semibold text-slate-800">{formatTraffic(latest.traffic)}</span>
                        <span className="text-xs text-slate-400">/mo</span>
                        {showSpamScore && !adhoc && spamScore > 0 &&
                            <span className={`text-xs font-medium px-1.5 py-0.5 rounded-full ${spamScore > 9 ? 'bg-red-50 text-red-600' : 'bg-slate-100 text-slate-500'}`}>
                                {spamScore}% spam
                            </span>
                        }
                    </>
                ) : (
                    <span className="text-xs text-slate-400">—</span>
                )}
            </div>
        );
    }

    return (
        <div ref={containerRef}>
            {trafficDataPoints.length > 0 ? (
                <>
                    <LineGraph datapoints={trafficDataPoints} />
                    <div className="flex items-center justify-between mt-1">
                        {showTrafficAnalysis && <TrafficAnalyser datapoints={trafficDataPoints} />}
                        {showSpamScore && !adhoc && spamScore > 0 && (
                            <span className={`inline-flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full border ${
                                spamScore > 9
                                    ? 'bg-red-50 text-red-700 border-red-200'
                                    : 'bg-slate-50 text-slate-500 border-slate-200'
                            }`}>
                                <svg xmlns="http://www.w3.org/2000/svg" className="w-3 h-3" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
                                </svg>
                                {spamScore}% spam
                            </span>
                        )}
                    </div>
                </>
            ) : null}
        </div>
    );
}
