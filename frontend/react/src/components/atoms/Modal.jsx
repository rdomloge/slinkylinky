import { useEffect } from 'react';
import { createPortal } from 'react-dom';

export default function Modal({children, dismissHandler, title, width, id = "default-modal"}) {

    // Close on Escape key
    useEffect(() => {
        const handler = e => { if (e.key === 'Escape') dismissHandler(); };
        document.addEventListener('keydown', handler);
        return () => document.removeEventListener('keydown', handler);
    }, [dismissHandler]);

    return createPortal(
        <div
            id={id}
            className="fixed inset-0 z-50 flex items-center justify-center p-4"
            aria-modal="true"
            role="dialog"
        >
            {/* Backdrop — deep + blurred */}
            <div
                className="absolute inset-0 backdrop-blur-md"
                style={{background: 'rgba(10, 15, 30, 0.65)'}}
                onClick={dismissHandler}
            />

            {/* Panel */}
            <div
                className={`relative flex flex-col max-h-[90vh] overflow-hidden ${width ?? 'w-auto min-w-[22rem]'}`}
                style={{
                    background: 'white',
                    borderRadius: '1rem',
                    boxShadow: '0 25px 60px rgba(0,0,0,0.3), 0 8px 20px rgba(0,0,0,0.15)',
                    border: '1px solid #e2e8f0',
                }}
            >
                {/* Accent strip at top */}
                <div className="h-1 shrink-0" style={{background: 'linear-gradient(90deg, #0f172a 0%, #6366f1 50%, #8b5cf6 100%)'}}/>

                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 shrink-0">
                    <h3 className="font-semibold text-slate-800" style={{fontFamily: "'Outfit', sans-serif", fontSize: '0.95rem', letterSpacing: '-0.01em'}}>
                        {title ?? ''}
                    </h3>
                    <button
                        onClick={dismissHandler}
                        className="ml-4 rounded-lg p-1.5 text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition-colors"
                        aria-label="Close"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12"/>
                        </svg>
                    </button>
                </div>

                {/* Body */}
                <div className="overflow-y-auto px-6 py-5 space-y-4 text-sm text-slate-700">
                    {children}
                </div>
            </div>
        </div>,
        document.body
    );
}
