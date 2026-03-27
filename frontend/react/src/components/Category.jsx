import '@/styles/globals.css'

export default function Category({category}) {

    return (
        <div className="lozenge">
            {category.name}
        </div>
    );
}

// Deterministic color palette for category badges
export const BADGE_COLORS = [
    'bg-indigo-50 text-indigo-700 border-indigo-200',
    'bg-violet-50 text-violet-700 border-violet-200',
    'bg-sky-50 text-sky-700 border-sky-200',
    'bg-emerald-50 text-emerald-700 border-emerald-200',
    'bg-amber-50 text-amber-700 border-amber-200',
    'bg-rose-50 text-rose-700 border-rose-200',
    'bg-teal-50 text-teal-700 border-teal-200',
    'bg-fuchsia-50 text-fuchsia-700 border-fuchsia-200',
];

export function hashName(name) {
    let h = 0;
    for (let i = 0; i < name.length; i++) {
        h = (h * 31 + name.charCodeAt(i)) >>> 0;
    }
    return h;
}

export function CategoryLite({category}) {
    const colorClass = BADGE_COLORS[hashName(category.name) % BADGE_COLORS.length];
    return (
        <span className={`inline-block text-xs font-medium px-2.5 py-0.5 rounded-full border ${colorClass}`}>
            {category.name}
        </span>
    );
}
