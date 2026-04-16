import { createContext, useContext, useState, useCallback, useEffect } from 'react';

const ToastContext = createContext(null);

const DURATION = 4000;

const VARIANTS = {
    success: {
        accent: '#10b981',
        bar:    '#6ee7b7',
        icon: (
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2.2} stroke="#059669">
                <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
            </svg>
        ),
    },
    error: {
        accent: '#ef4444',
        bar:    '#fca5a5',
        icon: (
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2.2} stroke="#dc2626">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m9.303 3.376c.866 1.5-.217 3.374-1.948 3.374H4.645c-1.73 0-2.813-1.874-1.948-3.374l7.226-12.498c.866-1.5 3.032-1.5 3.898 0l7.226 12.498zM12 15.75h.008v.008H12v-.008z" />
            </svg>
        ),
    },
    info: {
        accent: '#94a3b8',
        bar:    '#cbd5e1',
        icon: (
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2.2} stroke="#64748b">
                <path strokeLinecap="round" strokeLinejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" />
            </svg>
        ),
    },
};

function ToastItem({ toast, onDismiss }) {
    const [visible, setVisible] = useState(false);
    const v = VARIANTS[toast.type] ?? VARIANTS.info;

    useEffect(() => {
        const enterTimer = setTimeout(() => setVisible(true), 16);
        const exitTimer  = setTimeout(() => {
            setVisible(false);
            setTimeout(() => onDismiss(toast.id), 300);
        }, DURATION);
        return () => { clearTimeout(enterTimer); clearTimeout(exitTimer); };
    }, []);

    function dismiss() {
        setVisible(false);
        setTimeout(() => onDismiss(toast.id), 300);
    }

    return (
        <div
            className={`relative flex items-start gap-3 bg-white border border-slate-200 rounded-xl shadow-lg px-4 py-3 w-[340px] overflow-hidden transition-all duration-300 ease-out ${
                visible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-6'
            }`}
        >
            {/* Coloured left accent strip */}
            <div className="absolute left-0 top-0 bottom-0 w-[3px] rounded-l-xl" style={{ background: v.accent }} />

            {/* Icon */}
            <span className="mt-0.5 shrink-0">{v.icon}</span>

            {/* Message */}
            <p className="text-[13px] text-slate-700 leading-snug flex-1 pr-5 font-medium">{toast.message}</p>

            {/* Dismiss button */}
            <button
                onClick={dismiss}
                className="absolute top-2.5 right-2.5 text-slate-300 hover:text-slate-500 transition-colors"
            >
                <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" strokeWidth={2.5} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>

            {/* Countdown progress bar */}
            <div
                className="absolute bottom-0 left-[3px] right-0 h-[2px] rounded-br-xl origin-left"
                style={{
                    background: v.bar,
                    animation: `sl-toast-progress ${DURATION}ms linear forwards`,
                }}
            />
        </div>
    );
}

export function ToastProvider({ children }) {
    const [toasts, setToasts] = useState([]);

    const toast = useCallback((message, type = 'info') => {
        setToasts(prev => [...prev, { id: Date.now() + Math.random(), message, type }]);
    }, []);

    const dismiss = useCallback((id) => {
        setToasts(prev => prev.filter(t => t.id !== id));
    }, []);

    return (
        <ToastContext.Provider value={toast}>
            {children}
            <div className="fixed bottom-5 right-5 z-50 flex flex-col gap-2.5 items-end pointer-events-none">
                {toasts.map(t => (
                    <div key={t.id} className="pointer-events-auto">
                        <ToastItem toast={t} onDismiss={dismiss} />
                    </div>
                ))}
            </div>
        </ToastContext.Provider>
    );
}

export function useToast() {
    const ctx = useContext(ToastContext);
    if (!ctx) throw new Error('useToast must be used within ToastProvider');
    return ctx;
}
