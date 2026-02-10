import React from 'react';

const panelStyle = {
    border: '1px solid #ccc',
    borderRadius: '6px',
    padding: '8px',
    position: 'relative',
    marginTop: '8px'
};

const legendStyle = {
    padding: '0 12px',
    fontWeight: 'bold',
    fontSize: '1.1em'
};

function FiltersPanel({ children }) {
    return (
        <fieldset style={panelStyle}>
            <legend style={legendStyle}>Filters</legend>
            {children}
        </fieldset>
    );
}

export default FiltersPanel;