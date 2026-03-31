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
            className="relative mb-3 rounded-xl border-2 cursor-pointer transition-all"
            style={checked ? {
                borderColor: 'var(--demand-color)',
                boxShadow: '0 0 0 3px var(--demand-glow)',
            } : {borderColor: 'transparent'}}
            onMouseEnter={e => { if (!checked) e.currentTarget.style.borderColor = 'var(--demand-border)'; }}
            onMouseLeave={e => { if (!checked) e.currentTarget.style.borderColor = 'transparent'; }}
            onClick={handleChange}
        >
            {children}
            <div className="absolute top-3 right-3 z-10">
                <div className="w-5 h-5 rounded border-2 flex items-center justify-center transition-colors"
                     style={checked ? {backgroundColor: 'var(--demand-color)', borderColor: 'var(--demand-color)'} : {backgroundColor: 'white', borderColor: '#cbd5e1'}}>
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
