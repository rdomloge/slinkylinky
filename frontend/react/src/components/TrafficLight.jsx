import { CompactDate } from '@/components/atoms/DateTime';

export default function TrafficLight({ text, value, date, above = true, compact = false }) {

    if (compact) {
        return (
            <div className="flex flex-col items-center gap-1">
                <div className={`w-5 h-5 rounded-full flex items-center justify-center border-2 relative z-10 transition-colors ${
                    value ? 'bg-green-500 border-green-500' : 'bg-white border-slate-200'
                }`}>
                    {value && (
                        <svg className="w-3 h-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7"/>
                        </svg>
                    )}
                </div>
                <span className={`text-[10px] whitespace-nowrap font-medium ${value ? 'text-slate-600' : 'text-slate-400'}`}>
                    {text}
                </span>
            </div>
        );
    }

    // Full mode — alternating above/below with date
    // Geometry: h-14 label + h-3 connector + h-7 circle + h-3 spacer + h-14 label = 164px
    // Circle centre = 56 + 12 + 14 = 82px = top-[82px]

    const circle = (
        <div className={`w-7 h-7 rounded-full flex items-center justify-center border-2 transition-all duration-200 relative z-10 ${
            value
                ? 'bg-green-500 border-green-500 shadow-sm ring-2 ring-green-100'
                : 'bg-white border-slate-200'
        }`}>
            {value && (
                <svg className="w-3.5 h-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                    <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7"/>
                </svg>
            )}
        </div>
    );

    const labelContent = (
        <>
            <span className={`text-xs font-medium text-center leading-tight ${value ? 'text-slate-700' : 'text-slate-400'}`}>
                {text}
            </span>
            {value && date && (
                <span className="text-[10px] text-slate-400 mt-0.5">
                    <CompactDate isostring={date}/>
                </span>
            )}
        </>
    );

    if (above) {
        return (
            <div className="flex flex-col items-center">
                <div className="h-14 flex flex-col items-center justify-end pb-1">
                    {labelContent}
                </div>
                <div className={`w-px h-3 ${value ? 'bg-green-300' : 'bg-slate-200'}`}/>
                {circle}
                <div className="w-px h-3"/>
                <div className="h-14"/>
            </div>
        );
    }

    return (
        <div className="flex flex-col items-center">
            <div className="h-14"/>
            <div className="w-px h-3"/>
            {circle}
            <div className={`w-px h-3 ${value ? 'bg-green-300' : 'bg-slate-200'}`}/>
            <div className="h-14 flex flex-col items-center justify-start pt-1">
                {labelContent}
            </div>
        </div>
    );
}
