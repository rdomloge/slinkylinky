'use client'

import '@/styles/globals.css'

export default function Category({category}) {
    
    return (
        <div className="lozenge">
            {category.name}
        </div>
    );
}