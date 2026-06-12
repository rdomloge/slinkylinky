import { useEffect } from 'react';
import { createPortal } from 'react-dom';

/**
 * Slide-out panel anchored to the right edge (full-width on mobile). Styled to
 * match the Modal atom (orange accent strip, blurred scrim, Escape-to-close).
 *
 * The portal stays mounted so both enter and exit transitions play; visibility
 * is driven entirely by `open`. The caller owns the open lead/content and keeps
 * rendering it during the close transition.
 *
 * Props:
 *  - open                  show/hide the panel
 *  - onClose               called on scrim click, Escape, or the close button
 *  - title / subtitle      header nodes (e.g. domain + status badge)
 *  - width                 panel width classes (default: full on mobile, 26rem on sm+)
 *  - dismissOnBackdropClick guard backdrop dismissal (e.g. while a form is dirty)
 */
export default function Drawer({
    open,
    onClose,
    title,
    subtitle,
    width = 'w-full sm:w-[26rem]',
    dismissOnBackdropClick = true,
    children,
}) {
    useEffect(() => {
        if (!open) return undefined;
        const handler = e => { if (e.key === 'Escape') onClose(); };
        document.addEventListener('keydown', handler);
        return () => document.removeEventListener('keydown', handler);
    }, [open, onClose]);

    return createPortal(
        <div className="fixed inset-0 z-50 pointer-events-none" aria-hidden={!open}>
            {/* Scrim */}
            <div
                className={`absolute inset-0 transition-opacity duration-200 ${open ? 'opacity-100 pointer-events-auto' : 'opacity-0'}`}
                style={{ background: 'rgba(10, 15, 30, 0.45)', backdropFilter: 'blur(1px)' }}
                onClick={dismissOnBackdropClick ? onClose : undefined}
            />

            {/* Panel */}
            <aside
                role="dialog"
                aria-modal="true"
                className={`absolute top-0 right-0 h-full ${width} bg-white shadow-2xl flex flex-col transition-transform duration-300 ${open ? 'translate-x-0 pointer-events-auto' : 'translate-x-full'}`}
                style={{ transitionTimingFunction: 'cubic-bezier(0.22, 0.61, 0.36, 1)' }}
            >
                {/* Accent strip */}
                <div className="h-1 shrink-0" style={{ background: 'linear-gradient(90deg, #f97316 0%, #fb923c 40%, #fbbf24 100%)' }} />

                {/* Header */}
                <div className="flex items-start justify-between px-5 pt-4 pb-3 border-b border-slate-100 shrink-0">
                    <div className="min-w-0">
                        {title}
                        {subtitle && <div className="mt-1.5">{subtitle}</div>}
                    </div>
                    <button
                        onClick={onClose}
                        aria-label="Close"
                        className="ml-4 shrink-0 rounded-lg p-1 text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition-colors"
                    >
                        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                {/* Body */}
                <div className="flex-1 overflow-y-auto px-5 py-4">
                    {children}
                </div>
            </aside>
        </div>,
        document.body,
    );
}
