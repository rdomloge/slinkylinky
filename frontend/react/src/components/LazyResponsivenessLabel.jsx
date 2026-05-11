import { useAuth } from "@/auth/AuthProvider";
import { useEffect, useState, useRef } from "react";
import { fetchWithAuth } from "@/utils/fetchWithAuth";
import ResponsivenessLabel from "./ResponsivenessLabel";

export default function LazyResponsivenessLabel({ supplier }) {
    const [data, setData] = useState(null);
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
        if (isVisible && !data) {
            fetchResponsiveness();
        }
        // eslint-disable-next-line
    }, [user, supplier, isVisible]);

    function fetchResponsiveness() {
        if (!user) return;

        const url = `/.rest/stats/responsiveness?domain=${encodeURIComponent(supplier.domain)}`;

        fetchWithAuth(url)
            .then(resp => {
                if (!resp.ok) {
                    if (resp.status !== 404) {
                        console.log("Error fetching responsiveness: " + resp.status);
                    }
                    return;
                }
                resp.json().then(data => {
                    setData(data);
                });
            });
    }

    return (
        <div ref={containerRef}>
            <ResponsivenessLabel avgResponseDays={data?.avgResponseDays} />
        </div>
    );
}
