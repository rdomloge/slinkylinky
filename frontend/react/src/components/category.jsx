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
        <span className="float-right bg-blue-100 text-blue-800 text-xs font-medium me-2 px-2.5 mb-1 py-0.5 rounded dark:bg-gray-700 dark:text-blue-400 border border-blue-400">
            {category.name}
        </span>
    );
}