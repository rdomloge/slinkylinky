import React from 'react';

function FiltersPanel({ children }) {
    return (
        <div className="mx-6 mb-4 px-4 py-3 bg-white rounded-xl border border-slate-200">
            <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Filters</p>
            {children}
        </div>
    );
}

export default FiltersPanel;
