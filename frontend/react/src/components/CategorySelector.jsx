import AsyncSelect from 'react-select/async';
import React from 'react'
import { fetchWithAuth } from '@/utils/fetchWithAuth';

// Must mirror BADGE_COLORS in Category.jsx — CSS values for react-select inline styles
const BADGE_PALETTE = [
    { bg: '#eef2ff', color: '#4338ca', border: '#c7d2fe' }, // indigo
    { bg: '#f5f3ff', color: '#6d28d9', border: '#ddd6fe' }, // violet
    { bg: '#f0f9ff', color: '#0369a1', border: '#bae6fd' }, // sky
    { bg: '#ecfdf5', color: '#065f46', border: '#a7f3d0' }, // emerald
    { bg: '#fffbeb', color: '#92400e', border: '#fde68a' }, // amber
    { bg: '#fff1f2', color: '#9f1239', border: '#fecdd3' }, // rose
    { bg: '#f0fdfa', color: '#115e59', border: '#99f6e4' }, // teal
    { bg: '#fdf4ff', color: '#86198f', border: '#f0abfc' }, // fuchsia
];

function hashName(name) {
    let h = 0;
    for (let i = 0; i < name.length; i++) {
        h = (h * 31 + name.charCodeAt(i)) >>> 0;
    }
    return h;
}

function paletteFor(label) {
    return BADGE_PALETTE[hashName(label) % BADGE_PALETTE.length];
}

const multiValueStyles = {
    multiValue: (base, { data }) => {
        const p = paletteFor(data.label);
        return { ...base, backgroundColor: p.bg, border: `1px solid ${p.border}`, borderRadius: '9999px' };
    },
    multiValueLabel: (base, { data }) => {
        const p = paletteFor(data.label);
        return { ...base, color: p.color, fontWeight: '500', fontSize: '0.75rem', paddingLeft: '10px' };
    },
    multiValueRemove: (base, { data }) => {
        const p = paletteFor(data.label);
        return {
            ...base,
            color: p.color,
            borderRadius: '0 9999px 9999px 0',
            ':hover': { backgroundColor: p.border, color: p.color },
        };
    },
};

export default function CategorySelector({changeHandler, label, initialValue}) {

    const useableInitialValue = initialValue ? initialValue.map(c=>({value:extractUrl(c), label: c.name})) : []

    function extractUrl(category) {
        if(category._links) {
            const url = category._links.self.href
            if(url.indexOf('{') > -1) return url.substring(0, url.indexOf('{'))
            else return url
        }
        else {
            const url = location.protocol + "//" + location.hostname + ":" + location.port + "/.rest/categories/" + category.id
            console.log("Build URL: "+url)
            return url
        }
    }

    const findCategories = (inputValue, callback) => {
        console.log("Fetching categories like "+inputValue)
        fetchWithAuth(buildUrlForInputValue(inputValue))
            .then(res => res.json())
            .then(
                json => callback(json.map(c => ({value: "/categories/"+c.id, label: c.name}))))
    }

    function buildUrlForInputValue(inputValue) {
        if(inputValue) {
            return "/.rest/categories/search/findByNameContainsIgnoreCaseAndDisabledFalseOrderByNameAsc?name="+inputValue
        }
        else return "/.rest/categories/search/findAllByDisabledFalseOrderByNameAsc";
    }

    return (
        <div className="w-full">
            <label className="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">
                {label}
            </label>
            <AsyncSelect
                instanceId={"this-should-be-unique-on-the-page"}
                onChange={changeHandler}
                defaultOptions
                defaultValue={useableInitialValue}
                cacheOptions
                closeMenuOnSelect={false}
                isMulti
                loadOptions={findCategories}
                loadingMessage={() => console.log("Loading")}
                styles={multiValueStyles}
            />
        </div>
    );
}
