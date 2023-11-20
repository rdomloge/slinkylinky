'use client'

import '@/styles/globals.css'
import CategoriesCard from '@/components/categoriescard'

export default function LinkDemandCard({linkdemand}) {
    
    if(linkdemand === null) return <p>NULL</p>;
    else {
        return (
            <div className="card list-card">
                <div>{linkdemand.name}</div>
                <div>{linkdemand.url}</div>
                <div>Domain Authority needed {linkdemand.daNeeded}</div>
                <div>Requested {linkdemand.requested}</div>
                <CategoriesCard categoriesUrl={linkdemand._links.categories.href}/>
            </div>
        );
***REMOVED***
}