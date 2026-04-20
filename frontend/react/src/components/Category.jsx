import '@/styles/globals.css'

export const BADGE_COLORS = ['lozenge'];

export function hashName(name = '') {
    let h = 0;
    for (let i = 0; i < name.length; i++) {
        h = (h * 31 + name.charCodeAt(i)) >>> 0;
    }
    return h;
}

export default function Category({category}) {
    return (
        <div className="lozenge">
            {category.name}
        </div>
    );
}

export function CategoryLite({category}) {
    return (
        <span className="lozenge">
            {category.name}
        </span>
    );
}
