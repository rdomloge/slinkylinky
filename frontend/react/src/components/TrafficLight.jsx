export default function TrafficLight({ text, value }) {
    return (
        <div className="flex flex-col items-center gap-1.5 shrink-0">
            <div className={`w-7 h-7 rounded-full flex items-center justify-center border-2 transition-colors ${
                value
                    ? 'bg-green-500 border-green-500 text-white'
                    : 'bg-white border-gray-300'
            }`}>
                {value && (
                    <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7"/>
                    </svg>
                )}
            </div>
            <span className={`text-xs whitespace-nowrap ${value ? 'text-green-700 font-medium' : 'text-gray-400'}`}>
                {text}
            </span>
        </div>
    );
}
