import React from 'react';

function FiltersPanel({ children, className = '' }) {
    return (
        <div
            className={`mx-6 mb-4 px-4 py-3 rounded-xl ${className}`}
            style={{
                background: 'var(--bg-paper)',
                border: '1px solid var(--ink-hair)',
                boxShadow:
                    '0 1px 0 0 rgba(255,255,255,0.6) inset, 0 1px 2px 0 rgba(42,36,35,0.03)',
            }}
        >
            <p
                className="text-xs uppercase mb-2"
                style={{
                    fontFamily: "'DM Mono', monospace",
                    letterSpacing: '0.22em',
                    color: 'var(--ink-tertiary)',
                    fontWeight: 500,
                }}
            >
                Filters
            </p>
            {children}
        </div>
    );
}

export default FiltersPanel;
