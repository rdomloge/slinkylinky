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
            {/* Backdrop */}
            <div
                className="absolute inset-0 bg-gray-900/50 backdrop-blur-sm"
                onClick={dismissHandler}
            />

            {/* Panel */}
            <div className={`relative bg-white rounded-2xl shadow-xl flex flex-col max-h-[90vh] ${width ?? 'w-auto min-w-80'}`}>

                {/* Header */}
                <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100 shrink-0">
                    <h3 className="text-sm font-semibold text-gray-800">{title ?? ''}</h3>
                    <button
                        onClick={dismissHandler}
                        className="ml-4 rounded-lg p-1.5 text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors"
                        aria-label="Close"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12"/>
                        </svg>
                    </button>
                </div>

                {/* Body */}
                <div className="overflow-y-auto px-5 py-4 space-y-4">
                    {children}
                </div>
            </div>
        </div>,
        document.body
    );
}
