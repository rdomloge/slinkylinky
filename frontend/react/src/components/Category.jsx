import '@/styles/globals.css'

export default function Category({category}) {
    
    return (
        <div className="lozenge">
            {category.name}
        </div>
    );
}

export function CategoryLite({category}) {
    return (
        <span className="inline-block bg-blue-50 text-blue-700 text-xs font-medium me-1.5 mb-1 px-2.5 py-0.5 rounded-full border border-blue-200">
            {category.name}
        </span>
    );
}