export default function TrafficAnalyser({ datapoints }) {
    let rating;

    if (datapoints.length === 0) {
        rating = "NO DATA";
    } else if (datapoints[datapoints.length - 1].traffic < 3 || datapoints.length < 3) {
        rating = "BAD";
    } else {
        let sum = 0;
        for (let i = datapoints.length - 1; i > datapoints.length - 4; i--) {
            sum += datapoints[i].traffic;
        }
        const avg = sum / 3;
        if (avg > 150) rating = "GOOD";
        else if (avg > 35) rating = "OK";
        else rating = "BAD";
    }

    const styles = {
        GOOD:      'bg-emerald-50 text-emerald-700 border-emerald-200',
        OK:        'bg-amber-50 text-amber-700 border-amber-200',
        BAD:       'bg-red-50 text-red-600 border-red-200',
        'NO DATA': 'bg-slate-100 text-slate-500 border-slate-200',
    };

    const dots = {
        GOOD:      'bg-emerald-500',
        OK:        'bg-amber-500',
        BAD:       'bg-red-500',
        'NO DATA': 'bg-slate-400',
    };

    return (
        <div className="flex items-center gap-2 mt-3">
            <span className="text-xs text-slate-500 font-medium">Traffic quality</span>
            <span className={`inline-flex items-center gap-1.5 text-xs font-semibold px-2.5 py-1 rounded-full border ${styles[rating]}`}>
                <span className={`w-1.5 h-1.5 rounded-full ${dots[rating]}`}/>
                {rating}
            </span>
        </div>
    );
}
