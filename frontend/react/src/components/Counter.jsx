export default function Counter({ count, low, medium, high }) {
    let colorClass;
    if (count < low)        colorClass = 'bg-slate-100 text-slate-500 border-slate-200';
    else if (count < medium) colorClass = 'bg-emerald-50 text-emerald-700 border-emerald-200';
    else if (count < high)   colorClass = 'bg-amber-50 text-amber-700 border-amber-200';
    else                     colorClass = 'bg-red-50 text-red-700 border-red-200';

    return (
        <span className={`inline-flex items-center text-xs font-semibold px-2 py-0.5 rounded-full border ${colorClass}`}>
            {count}
        </span>
    );
}
