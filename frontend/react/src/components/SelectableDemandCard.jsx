import React, {useState} from 'react'

export default function SelectableDemandCard({children, onSelectedHandler, onDeselectedHandler}) {
    const [checked, setChecked] = useState(false);

    const handleChange = () => {
        const next = !checked;
        setChecked(next);
        if(next) onSelectedHandler();
        else onDeselectedHandler();
    };

    return (
        <div
            className={`relative mb-3 rounded-xl border-2 cursor-pointer transition-all ${
                checked
                    ? 'border-indigo-400 ring-2 ring-indigo-100'
                    : 'border-transparent hover:border-slate-200'
            }`}
            onClick={handleChange}
        >
            {children}
            <div className="absolute top-3 right-3 z-10">
                <div className={`w-5 h-5 rounded border-2 flex items-center justify-center transition-colors ${
                    checked ? 'bg-indigo-600 border-indigo-600' : 'bg-white border-slate-300'
                }`}>
                    {checked && (
                        <svg className="w-3 h-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7"/>
                        </svg>
                    )}
                </div>
            </div>
        </div>
    );
}
