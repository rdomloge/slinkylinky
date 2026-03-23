export function responsivenessLabel(avgDays) {
    if (avgDays == null) return { text: 'Unknown', bg: 'bg-gray-100', color: 'text-gray-400', border: 'border-gray-200' };
    if (avgDays <= 7)    return { text: 'Very responsive', bg: 'bg-emerald-50', color: 'text-emerald-700', border: 'border-emerald-200' };
    if (avgDays <= 14)   return { text: 'Responsive', bg: 'bg-green-50', color: 'text-green-700', border: 'border-green-200' };
    if (avgDays <= 30)   return { text: 'Average', bg: 'bg-amber-50', color: 'text-amber-700', border: 'border-amber-200' };
    if (avgDays <= 60)   return { text: 'Slow', bg: 'bg-orange-50', color: 'text-orange-700', border: 'border-orange-200' };
    return                 { text: 'Very slow', bg: 'bg-red-50', color: 'text-red-700', border: 'border-red-200' };
}

export default function ResponsivenessLabel({ avgResponseDays }) {
    const { text, bg, color, border } = responsivenessLabel(avgResponseDays);

    return (
        <span className={`inline-flex items-center text-xs font-medium px-2 py-0.5 rounded-full border ${bg} ${color} ${border}`}>
            {text}
        </span>
    );
}
