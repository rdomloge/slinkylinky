import React from 'react';
import { Link } from 'react-router-dom';

/**
 * A titled panel card with an optional coloured left-border accent, loading skeleton,
 * and optional actions or a "View all →" link in the header.
 *
 * Props:
 *   title         – small-caps label shown in the card header
 *   loading       – when true, renders a pulsing skeleton instead of children
 *   children      – card body content
 *   to            – if set, renders a link in the header (react-router path)
 *   linkLabel     – label for the header link (default: "View all →")
 *   headerActions – optional JSX rendered next to the header link
 *   accentColor   – CSS colour used for the left border and title/link text
 */
export function PanelCard({ title, loading, children, to, linkLabel, headerActions, accentColor }) {
    return (
        <div className="card p-5 flex flex-col gap-3 overflow-hidden"
             style={accentColor ? { borderLeft: `3px solid ${accentColor}` } : {}}>
            <div className="flex items-center justify-between gap-3">
                <p className="text-xs font-semibold uppercase tracking-wide"
                   style={{ color: accentColor ?? '#94a3b8', fontFamily: "'JetBrains Mono', monospace", fontSize: '0.6rem' }}>
                    {title}
                </p>
                <div className="flex items-center gap-3 shrink-0">
                    {headerActions}
                    {to && (
                        <Link to={to}
                              className="text-xs font-medium transition-colors hover:underline"
                              style={{ color: accentColor ?? '#6366f1' }}>
                            {linkLabel ?? 'View all →'}
                        </Link>
                    )}
                </div>
            </div>
            {loading
                ? <div className="space-y-2">{[1, 2, 3].map(i => <div key={i} className="h-4 bg-slate-100 rounded animate-pulse" />)}</div>
                : children
            }
        </div>
    );
}
