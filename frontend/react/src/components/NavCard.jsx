import React from 'react';
import { Link } from 'react-router-dom';

/**
 * A clickable navigation card with an icon, label, and description.
 * The entire card is wrapped in a react-router Link.
 *
 * Props:
 *   to          – react-router path
 *   label       – bold card title
 *   description – small subtitle text
 *   icon        – React node (e.g. an SVG or emoji) shown in the icon box
 *   accentColor – CSS colour used for the left border and icon box tint
 */
export function NavCard({ to, label, description, icon, accentColor }) {
    return (
        <Link to={to}>
            <div className="card p-4 flex items-start gap-3 h-full transition-all"
                 style={{ borderLeft: `3px solid ${accentColor ?? '#6366f1'}` }}>
                <div className="shrink-0 w-9 h-9 rounded-lg flex items-center justify-center"
                     style={{ background: `${accentColor}18`, color: accentColor ?? '#6366f1' }}>
                    {icon}
                </div>
                <div>
                    <p className="text-sm font-semibold text-slate-800"
                       style={{ fontFamily: "'Outfit', sans-serif" }}>
                        {label}
                    </p>
                    <p className="text-xs text-slate-400 mt-0.5">{description}</p>
                </div>
            </div>
        </Link>
    );
}
